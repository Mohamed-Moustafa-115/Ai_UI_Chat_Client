import 'dart:developer';

import 'package:ai_chat_client/cubit/chat/message_area/message_area_state_.dart';
import 'package:ai_chat_client/services/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageAreaCubit extends Cubit<MessageAreaState> {
  List<Map<String, dynamic>> messages = [];

  MessageAreaCubit() : super(MessageAreaInitialState());

  void addUserMessage(String message) {
    messages.add({"message": message, "isUser": true});
    emit(SendMessage(message: message, isUser: true));
  }
  
  
  Future<void> sendMessage(String message, bool isUser) async {
    if (message.isEmpty) return;
    addUserMessage(message);
    
    try {
      // Send to API
      var response =await DioService().sendMessage(message);
      
      // TODO: Handle AI response and add it to messages
      // For now, just add a placeholder
      messages.add({"message": response, "isUser": false});
      emit(SendMessage(message: response, isUser: false));
      // emit(MessageReceivedState(messages: messages));
    } catch (e) {
      // emit(MessageErrorState(error: e.toString()));
      log("Error sending message: $e");
    }
  }

  void clearMessages() {
    messages.clear();
    emit(MessageAreaInitialState());
  }
}