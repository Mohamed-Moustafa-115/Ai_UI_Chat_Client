import 'package:ai_chat_client/cubit/chat/message_area/message_area_cubit.dart';
import 'package:ai_chat_client/cubit/chat/message_area/message_area_state_.dart';
import 'package:ai_chat_client/widgets/chat_bubble.dart';
import 'package:ai_chat_client/widgets/message_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
        centerTitle: true,
      ),
      drawer: Drawer(

      ),
      body: BlocProvider(
        create: (_) => MessageAreaCubit(),
        child: Center(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.9,
            child: Column(
              children: [
                Flexible(
                  child: BlocBuilder<MessageAreaCubit, MessageAreaState>(
                    builder: (context, state) {
                      final cubit = context.read<MessageAreaCubit>();
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: cubit.messages.length,
                        itemBuilder: (context, index) {
                          final msg = cubit.messages[index];
                          return ChatBubble(
                            message: msg['message'] as String,
                            isUser: msg['isUser'] as bool,
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                const MessageArea(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}