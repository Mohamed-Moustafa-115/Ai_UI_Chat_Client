enum MessageAreaStatus { initial, loading, success, error }

class ChatMessage {
  final String message;
  final bool isUser;

  const ChatMessage({required this.message, required this.isUser});
}

class MessageAreaState {
  final List<ChatMessage> messages;
  final MessageAreaStatus status;
  final String? errorMessage;
  final int? chatHistoryId;
  final String? chatTitle;

  const MessageAreaState({
    this.messages = const [],
    this.status = MessageAreaStatus.initial,
    this.errorMessage,
    this.chatHistoryId,
    this.chatTitle,
  });

  bool get isLoading => status == MessageAreaStatus.loading;

  MessageAreaState copyWith({
    List<ChatMessage>? messages,
    MessageAreaStatus? status,
    String? errorMessage,
    int? chatHistoryId,
      final String? chatTitle,
    bool clearErrorMessage = false,
  }) {
    return MessageAreaState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      chatHistoryId: chatHistoryId ?? this.chatHistoryId,
      chatTitle: chatTitle ?? this.chatTitle,
    );
  }
}
