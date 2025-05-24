import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showUserDataDialog(BuildContext context) {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('User Data'),
        content: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chat_messages')
              .doc(uid)
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            final messages = snapshot.data!.docs;

            return ListView(
              children: messages.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['text'] ?? ''),
                );
              }).toList(),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          )
        ],
      );
    },
  );
}
