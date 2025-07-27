import 'package:firebase_application/features/chat/data/models/chat_message_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessageModel> messages;
  ChatLoaded({required this.messages});
}

class ChatError extends ChatState {
  final String error;
  ChatError({required this.error});
}
