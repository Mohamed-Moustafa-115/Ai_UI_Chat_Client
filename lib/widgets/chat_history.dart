import 'package:ai_chat_client/cubit/chat/chat_history/chat_history_cubit.dart';
import 'package:ai_chat_client/cubit/chat/message_area/message_area_cubit.dart';
import 'package:ai_chat_client/widgets/new_chat_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/chat/chat_history/chat_history_states.dart';

class ChatHistory extends StatelessWidget {
  const ChatHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatHistoryCubit()..loadChatHistories(1),
      child: BlocBuilder<ChatHistoryCubit, ChatHistoryStates>(
        builder: (context, state) {
          if (state is ChatHistoryInitialState) {
            return ListView(
              children: [
                const DrawerHeader(child: Text('Chat Histories')),
                ...state.chatHistories.map(
                  (chat) => ListTile(
                    title: Text(chat['title'] ?? 'Untitled Chat'),
                    onTap: () async {
                      // Load the selected chat history
                      // print(chat['id']);
                      await context.read<MessageAreaCubit>().loadMessages(chat['id'], chat['title'] ?? 'Untitled Chat');
                      Navigator.pop(context); // Close the drawer
                    },
                  ),
                ),
                ListTile(
                  title: const Text('New Chat'),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    showNewChatDialog(context);
                  },
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
