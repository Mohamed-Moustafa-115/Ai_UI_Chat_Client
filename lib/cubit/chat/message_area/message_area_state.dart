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

  const MessageAreaState({
    this.messages = const [],
    this.status = MessageAreaStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == MessageAreaStatus.loading;

  MessageAreaState copyWith({
    List<ChatMessage>? messages,
    MessageAreaStatus? status,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return MessageAreaState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
