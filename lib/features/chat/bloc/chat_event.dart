import 'package:firebase_application/features/chat/data/models/chat_message_model.dart';

abstract class ChatEvent {}

class LoadMessagesEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final ChatMessageModel message;

  SendMessageEvent({required this.message});
}
