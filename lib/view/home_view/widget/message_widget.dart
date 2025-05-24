import 'package:chat_bot/utill/images.dart';
import 'package:chat_bot/utill/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/services.dart';

final FlutterTts flutterTts = FlutterTts();

Widget buildMessage(Map<String, String> message, BuildContext context) {
  final isUser = message['role'] == 'user';
  final text = message['text'] ?? '';

  return Align(
    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser)
          const CircleAvatar(backgroundImage: AssetImage(AppImages.logo)),
        if (!isUser) const SizedBox(width: 8),
        Flexible(
          child: GestureDetector(
            onTapDown: (details) async {
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;
              final result = await showMenu(
                context: context,
                position: RelativeRect.fromRect(
                  details.globalPosition & const Size(40, 40),
                  Offset.zero & overlay.size,
                ),
                items: [
                  const PopupMenuItem(value: 'copy', child: Text("Copy")),
                  const PopupMenuItem(
                      value: 'speak', child: Text("Text to Speech")),
                ],
              );

              if (result == 'copy') {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Copied!')));
              } else if (result == 'speak') {
                await flutterTts.speak(text);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue.shade100 : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(text, style: commonTextStyle(context)),
            ),
          ),
        ),
        if (isUser) const SizedBox(width: 8),
        if (isUser) const CircleAvatar(child: Icon(Icons.person)),
      ],
    ),
  );
}
