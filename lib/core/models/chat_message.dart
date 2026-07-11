class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final String? imagePath;

  ChatMessage({
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.imagePath,
  });
}
