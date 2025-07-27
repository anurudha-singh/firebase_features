import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_application/features/chat/data/models/chat_message_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final String _collectionPath = 'messages';

  // ✅ Send a message
  Future<void> sendMessage(ChatMessageModel message) async {
    await _firestore.collection(_collectionPath).add(message.toMap());
  }

  // ✅ Stream messages in real-time (ordered by timestamp)
  Stream<List<ChatMessageModel>> getMessagesStream() {
    return _firestore
        .collection(_collectionPath)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs.map((doc) {
            return ChatMessageModel.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }
}
