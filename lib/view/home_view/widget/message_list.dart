import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:chat_bot/view_model/chat_riverpod.dart';
import 'package:chat_bot/view/home_view/widget/message_widget.dart';

Widget buildMessageList(ChatState chatState, BuildContext context) {
  if (chatState.messages.isEmpty && chatState.isLoading) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 60,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
    itemBuilder: (context, index) {
      if (index < chatState.messages.length) {
        return buildMessage(chatState.messages[index], context);
      } else {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText('Typing...',
                  textStyle:
                      const TextStyle(fontSize: 16.0, color: Colors.blue),
                  speed: const Duration(milliseconds: 100)),
            ],
            repeatForever: true,
          ),
        );
      }
    },
  );
}
