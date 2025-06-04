class ChatMessage {
  final String role; // 'user' or 'bot'
  final String text;

  ChatMessage({required this.role, required this.text});

  Map<String, String> toMap() => {'role': role, 'text': text};
}
