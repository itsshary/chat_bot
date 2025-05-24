import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SendMessageService {
  static Future<void> saveMessageToFirebase({
    required String uid,
    required String text, // User input
    required String message, // Bot reply
    required String role, // 'user' or 'bot'
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('chat_messages')
          .doc(uid)
          .collection('messages')
          .add({
        'text': text,
        'role': role,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving message to Firebase: $e');
    }
  }
}
