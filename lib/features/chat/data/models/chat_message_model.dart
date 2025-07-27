import '../../domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  ChatMessageModel({
    required String id,
    required String senderId,
    required String text,
    required DateTime timestamp,
  }) : super(id: id, senderId: senderId, text: text, timestamp: timestamp);

  factory ChatMessageModel.fromMap(Map<String, dynamic> map, String docId) {
    return ChatMessageModel(
      id: docId,
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      // timestamp: (map['timestamp'] as TimeStamp),
      timestamp: map['timestamp'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'senderId': senderId, 'text': text, 'timestamp': DateTime.now()};
  }
}
