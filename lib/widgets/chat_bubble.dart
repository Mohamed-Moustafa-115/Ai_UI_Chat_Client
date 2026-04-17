import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  
  

  const ChatBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    List<Widget> chatBubble = [
    CircleAvatar(child: Icon(isUser ? Icons.person : Icons.smart_toy, size: 24)),
          SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6,
              ),
              decoration: BoxDecoration(
                color: isUser ? Colors.blueAccent : Colors.grey[400],
                borderRadius: BorderRadius.circular(16),
              ),
              child: SelectableText(
                message,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
                
              ),
            ),
          ),
       
  ];
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: isUser?chatBubble.reversed.toList():chatBubble,
      ),
    );
  }
}