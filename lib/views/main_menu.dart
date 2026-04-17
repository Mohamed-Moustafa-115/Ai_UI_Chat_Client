import 'package:ai_chat_client/cubit/chat/message_area/message_area_cubit.dart';
import 'package:ai_chat_client/cubit/chat/message_area/message_area_state.dart';
import 'package:ai_chat_client/widgets/chat_bubble.dart';
import 'package:ai_chat_client/widgets/message_area.dart';
import 'package:ai_chat_client/widgets/three_dots_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final ScrollController _messagesScrollController = ScrollController();

  @override
  void dispose() {
    _messagesScrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_messagesScrollController.hasClients) return;

      _messagesScrollController.animateTo(
        _messagesScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Menu'), centerTitle: true),
      drawer: Drawer(),
      body: BlocProvider(
        create: (_) => MessageAreaCubit(),
        child: BlocListener<MessageAreaCubit, MessageAreaState>(
          listenWhen: (previous, current) =>
              current.messages.length > previous.messages.length,
          listener: (context, state) {
            _scrollToBottom();
          },
          child: Center(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.9,
              child: Column(
                children: [
                  Flexible(
                    child: BlocBuilder<MessageAreaCubit, MessageAreaState>(
                      builder: (context, state) {
                        return ListView.builder(
                          controller: _messagesScrollController,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            final msg = state.messages[index];
                            return ChatBubble(
                              message: msg.message,
                              isUser: msg.isUser,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlocConsumer<MessageAreaCubit, MessageAreaState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state.status == MessageAreaStatus.loading) {
                        // show 3 dots loading indicator
                        return Align(
                          alignment: Alignment.bottomLeft,
                          child: TypingDots(
                            color: Colors.blue,
                            size: 10,
                            spacing: 3,
                          ),
                        );
                      } else if (state.status == MessageAreaStatus.error) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            state.errorMessage ?? 'An error occurred',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 8),
                  const MessageArea(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
