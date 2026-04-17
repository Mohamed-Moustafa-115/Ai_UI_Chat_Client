abstract class MessageAreaState {
  String message; 
  bool isUser;
  MessageAreaState({required this.message, required this.isUser});
}

class MessageAreaInitialState extends MessageAreaState {
  MessageAreaInitialState() : super(message: '', isUser: true);
}

class SendMessage extends MessageAreaState{
  SendMessage({required super.message, required super.isUser});
}

class LoadAiResponse extends MessageAreaState{
  LoadAiResponse() : super(message: '', isUser: false);
}