import 'package:chat_bot/view_model/chat_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_bot/utill/app_constants.dart';
import 'package:chat_bot/utill/dimensions.dart';

Widget buildInputRow({
  required TextEditingController controller,
  required bool isListening,
  required VoidCallback onMicPressed,
  required ChatController chatController,
}) {
  return Padding(
    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: AppConstants.askSomething,
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            isListening ? Icons.stop : Icons.mic,
            color: isListening ? Colors.red : Colors.black,
          ),
          onPressed: onMicPressed,
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () async {
            final message = controller.text.trim();
            if (message.isNotEmpty &&
                FirebaseAuth.instance.currentUser != null) {
              await chatController.sendMessage(message);
              controller.clear();
            }
          },
        ),
      ],
    ),
  );
}
