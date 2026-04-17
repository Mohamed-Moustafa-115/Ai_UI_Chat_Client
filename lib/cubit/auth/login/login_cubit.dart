import 'package:ai_chat_client/views/main_menu.dart';
import 'package:bloc/bloc.dart';
import 'package:ai_chat_client/cubit/auth/login/login_states.dart';
import 'package:flutter/material.dart';

class LoginCubit extends Cubit<LoginStates> {
  
  LoginCubit() : super(LoginInitialState());

  // Add additional methods here for handling different state transitions and actions.
  void attemptLogin(String username, String password, BuildContext context) {
    emit(LoginAttemptState());
    if(username == 'admin' && password == 'password') {
      emit(SuccessState());
      print("Login successful");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainMenu()));
    } else {
      emit(FailureState(errorMessage: 'Invalid username or password'));

    }
  }
}
