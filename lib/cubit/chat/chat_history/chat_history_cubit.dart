import 'package:ai_chat_client/cubit/chat/chat_history/chat_history_states.dart';
import 'package:ai_chat_client/services/sqlite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

class ChatHistoryCubit extends Cubit<ChatHistoryStates> {
  ChatHistoryCubit() : super(ChatHistoryInitialState(chatHistories: []));

  Future<void> loadChatHistories(int userId) async {
    try {
      // Here you would typically load chat histories from a database or API
      // For demonstration, we'll just emit the initial state with an empty list
      final chatHistories = await SqliteService().getChatHistoriesForUser(userId);
      if (!isClosed) {
        emit(ChatHistoryInitialState(chatHistories: chatHistories));
        // developer.log("Loaded chat histories for user $userId: $chatHistories");
      }
    } catch (e) {
      developer.log('Error loading chat histories: $e');
    }
  }

  Future<void> createNewChatHistory(int userId, String title) async {
    try {
      await SqliteService().createChatHistory(title, userId);
      final chatHistories = await SqliteService().getChatHistoriesForUser(userId);
      if (!isClosed) {
        emit(ChatHistoryInitialState(chatHistories: chatHistories));
        // developer.log('Created new chat history: $title');
      }
    } catch (e) {
      developer.log('Error creating chat history: $e');
    }
  }

  String getChatHistoryTitle(String chatTitle) {
    return chatTitle.isNotEmpty ? chatTitle : 'Untitled Chat';
  }
}
