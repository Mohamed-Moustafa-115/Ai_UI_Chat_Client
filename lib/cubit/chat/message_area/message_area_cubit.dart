import 'dart:developer';

import 'package:ai_chat_client/cubit/chat/message_area/message_area_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageAreaCubit extends Cubit<MessageAreaState> {
  MessageAreaCubit() : super(const MessageAreaState());

  Future<void> sendMessage(String message, bool isUser) async {
    final trimmedMessage = message.trim();
    if (trimmedMessage.isEmpty) return;

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
      await Future.delayed(
        const Duration(seconds: 3),
      ); // Simulate network delay
      final response =
          "This is a simulated response from the AI model for the message: '$trimmedMessage'";
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
