import 'package:ai_chat_client/cubit/auth/login/login_cubit.dart';
import 'package:ai_chat_client/cubit/auth/login/login_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login'), centerTitle: true),
        body: Center(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(controller: _usernameController),

                SizedBox(height: 16),
                
                TextField(controller: _passwordController, obscureText: true),

                SizedBox(height: 16),

                BlocBuilder<LoginCubit, LoginStates>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        context.read<LoginCubit>().attemptLogin(
                          _usernameController.text,
                          _passwordController.text,
                          context
                        );
                      },
                      child: const Text('Login'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
