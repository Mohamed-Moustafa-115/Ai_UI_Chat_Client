abstract class ChatHistoryStates {
    final List<Map<String, dynamic>> chatHistories;
    ChatHistoryStates({required this.chatHistories});
}

class ChatHistoryInitialState extends ChatHistoryStates {
  ChatHistoryInitialState({required List<Map<String, dynamic>> chatHistories}) : super(chatHistories: chatHistories);
}

class NewChatHistoryState extends ChatHistoryStates {
  NewChatHistoryState({required List<Map<String, dynamic>> chatHistories}) : super(chatHistories: chatHistories);
}