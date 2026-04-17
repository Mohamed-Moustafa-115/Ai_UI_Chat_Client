import 'package:ai_chat_client/views/login.dart';
import 'package:flutter/material.dart';

class AiChatClient extends StatelessWidget {
  const AiChatClient({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
