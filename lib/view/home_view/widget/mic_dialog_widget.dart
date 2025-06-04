import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:chat_bot/utill/images.dart';

void showMicDialog(
    BuildContext context, bool isListening, VoidCallback stopListening) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Voice Input'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isListening
              ? Lottie.asset(JsonFiles.micJson, height: 80, width: 80)
              : const Icon(Icons.mic_none, size: 60),
          const SizedBox(height: 12),
          Text(
            isListening ? 'Listening...' : 'Tap OK when done',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            stopListening();
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
