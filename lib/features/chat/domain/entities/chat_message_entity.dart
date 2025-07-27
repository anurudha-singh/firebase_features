class ChatMessageEntity {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  ChatMessageEntity({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });
}
