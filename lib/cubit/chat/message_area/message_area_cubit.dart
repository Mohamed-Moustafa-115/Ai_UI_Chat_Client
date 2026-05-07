import 'dart:developer';

import 'package:ai_chat_client/cubit/chat/message_area/message_area_state.dart';
import 'package:ai_chat_client/services/dio.dart';
import 'package:ai_chat_client/services/encryption.dart';
import 'package:ai_chat_client/services/sqlite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MessageAreaCubit extends Cubit<MessageAreaState> {
  MessageAreaCubit() : super(const MessageAreaState());


  Future<void> loadMessages(int chatHistoryId ,String chatTitle) async {
    final storage = FlutterSecureStorage();
    emit(state.copyWith(chatHistoryId: chatHistoryId, chatTitle: chatTitle));
    
    try {
      final encryptedMessages = await SqliteService().getMessagesForChatHistory(
        chatHistoryId,
      );
      
      if (encryptedMessages.isEmpty) {
        emit(state.copyWith(messages: []));
        return;
      }

      final key = await storage.read(key: 'key');
      final iv = await storage.read(key: 'loggedInUser');
      

      final decryptedMessages = <ChatMessage>[];
      for (var msg in encryptedMessages) {
        try {
          final decrypted = await EncryptionService().decrypt(
            msg['content'],
            key,
            iv,
          );
          decryptedMessages.add(ChatMessage(
            message: decrypted,
            isUser: msg['is_user_message'] == 1,
          ));
        } catch (e) {
          log('Error decrypting message: $e');
        }
      }
      
      emit(state.copyWith(messages: decryptedMessages, chatHistoryId: chatHistoryId));
    } catch (e, stackTrace) {
      log('Error loading messages', error: e, stackTrace: stackTrace);
      emit(state.copyWith(errorMessage: 'Failed to load messages: $e'));
    }
  }

  Future<void> sendMessage(String message, bool isUser) async {
    final storage = FlutterSecureStorage();

    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) return;
    
    // Use the stored chatHistoryId from state
    final chatId = state.chatHistoryId;
    
    // Check if chatHistoryId is set
    if (chatId == null) {
      emit(state.copyWith(
        status: MessageAreaStatus.error,
        errorMessage: 'No chat selected. Please open a chat first.',
      ));
      return;
    }
    
    log('Sending message for chat ID: $chatId');
    await SqliteService().storeMessage(
      chatId,
      await EncryptionService().encrypt(
        trimmedMessage,
        await storage.read(key: 'key'),
        await storage.read(key: 'loggedInUser'),
      ),
      isUser,
    );

    final updatedMessages = List<ChatMessage>.from(state.messages)
      ..add(ChatMessage(message: trimmedMessage, isUser: isUser));

    emit(
      state.copyWith(
        messages: updatedMessages,
        status: MessageAreaStatus.loading,
        clearErrorMessage: true,
      ),
    );

    try {
      final response = await DioService().sendMessage(trimmedMessage);
      final aiResponse = response.trim();

      if (aiResponse.isEmpty) {
        emit(
          state.copyWith(
            status: MessageAreaStatus.error,
            errorMessage: 'Failed to get a response from the AI model.',
          ),
        );
        return;
      }
      await SqliteService().storeMessage(
        chatId,
        await EncryptionService().encrypt(
          aiResponse,
          await storage.read(key: 'key'),
          await storage.read(key: 'loggedInUser'),
        ),
        false,
      );
      emit(
        state.copyWith(
          messages: [
            ...updatedMessages,
            ChatMessage(message: aiResponse, isUser: false),
          ],
          status: MessageAreaStatus.success,
          clearErrorMessage: true,
        ),
      );
    } catch (e, stackTrace) {
      log('Error sending message', error: e, stackTrace: stackTrace);
      emit(
        state.copyWith(
          status: MessageAreaStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void clearMessages() {
    emit(const MessageAreaState());
  }
}
