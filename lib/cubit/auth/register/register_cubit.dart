import 'package:ai_chat_client/services/encryption.dart';
import 'package:ai_chat_client/services/sqlite.dart';
import 'package:ai_chat_client/views/login.dart';
import 'package:bloc/bloc.dart';
import 'package:ai_chat_client/cubit/auth/register/register_states.dart';
import 'package:flutter/material.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  void attemptRegister(
    String name,
    String username,
    String password,
    String confirmPassword,
    BuildContext context,
  ) {
    emit(RegisterAttemptState());

    // Validation
    if (name.isEmpty || username.isEmpty || password.isEmpty) {
      emit(FailureState(errorMessage: 'All fields are required'));
      return;
    }

    if (password != confirmPassword) {
      emit(FailureState(errorMessage: 'Passwords do not match'));
      return;
    }

    if (password.length < 6) {
      emit(FailureState(errorMessage: 'Password must be at least 6 characters'));
      return;
    }

    // For now, simulate successful registration
    // In a real app, you would save to database here
    SqliteService().addNewUser(name, username, EncryptionService().hashPassword(password));
    emit(SuccessState());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }
}
