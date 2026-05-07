import 'package:ai_chat_client/cubit/chat/chat_history/chat_history_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> showNewChatDialog(BuildContext context) async {
  final TextEditingController _titleController = TextEditingController();
  // Get the cubit before showing the dialog
  final ChatHistoryCubit chatHistoryCubit = context.read<ChatHistoryCubit>();
  
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Create New Chat'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter a title for the new chat:'),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Chat Title',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_titleController.text.isNotEmpty) {
                final storage = FlutterSecureStorage();
                int userId = int.parse(await storage.read(key: 'userId') ?? '1');
                // Use the cubit that was obtained before showing the dialog
                chatHistoryCubit.createNewChatHistory(userId, _titleController.text);
                Navigator.pop(dialogContext);
              } else {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text('Please enter a chat title')),
                );
              }
            },
            child: const Text('Create Chat'),
          ),
        ],
      );
    },
  );
}
