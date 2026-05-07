import 'package:ai_chat_client/services/encryption.dart';
import 'package:ai_chat_client/services/sqlite.dart';
import 'package:ai_chat_client/views/main_menu.dart';
import 'package:bloc/bloc.dart';
import 'package:ai_chat_client/cubit/auth/login/login_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginCubit extends Cubit<LoginStates> {
  
  LoginCubit() : super(LoginInitialState());

  // Add additional methods here for handling different state transitions and actions.
  void attemptLogin(String username, String password, BuildContext context) async{
    emit(LoginAttemptState());
  var user = await SqliteService().getUserByUsername(username);
    if(user != null && EncryptionService().verifyPassword(password, user['password'])) {
      emit(SuccessState());
      final storage = FlutterSecureStorage();
      await storage.write(key: 'userId', value: user['id'].toString());
      await storage.write(key: 'loggedInUser', value: username);
      await storage.write(key: 'key', value: password);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainMenu()));
    } else {
      emit(FailureState(errorMessage: 'Invalid username or password'));

    }
  }
}
