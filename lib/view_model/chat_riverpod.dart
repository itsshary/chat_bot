import 'dart:convert';
import 'package:chat_bot/firebase/send_message_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

const apiKey = 'Enter Your APi key ';

final chatControllerProvider =
    StateNotifierProvider<ChatController, ChatState>((ref) {
  return ChatController();
});

class ChatState {
  final List<Map<String, String>> messages;
  final bool isLoading;

  ChatState({required this.messages, required this.isLoading});

  ChatState copyWith({
    List<Map<String, String>>? messages,
    bool? isLoading,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChatController extends StateNotifier<ChatState> {
  ChatController() : super(ChatState(messages: [], isLoading: false));
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Save user message
    state = state.copyWith(
      messages: [
        ...state.messages,
        {'role': 'user', 'text': text}
      ],
      isLoading: true,
    );

    await SendMessageService.saveMessageToFirebase(
      uid: user.uid,
      text: text,
      message: '',
      role: 'user',
    );

    final response = await http.post(
      Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": text}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply = data['candidates'][0]['content']['parts'][0]['text'];

      state = state.copyWith(
        messages: [
          ...state.messages,
          {'role': 'bot', 'text': reply}
        ],
        isLoading: false,
      );

      // Save bot reply
      await SendMessageService.saveMessageToFirebase(
        uid: user.uid,
        text: '',
        message: reply,
        role: 'bot',
      );
    } else {
      final errorMessage = 'Error: ${response.body}';
      state = state.copyWith(
        messages: [
          ...state.messages,
          {'role': 'bot', 'text': errorMessage}
        ],
        isLoading: false,
      );

      // Save error message if needed
      await SendMessageService.saveMessageToFirebase(
        uid: user.uid,
        text: '',
        message: errorMessage,
        role: 'bot',
      );
    }
  }
}
