import 'dart:async';
import 'package:firebase_application/features/chat/data/models/chat_message_model.dart';
import 'package:firebase_application/features/chat/data/repositories/chat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  StreamSubscription<List<ChatMessageModel>>? _messagesSubscription;

  ChatBloc(this._chatRepository) : super(ChatInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  void _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    await _messagesSubscription?.cancel();

    try {
      await emit.forEach<List<ChatMessageModel>>(
        _chatRepository.getMessagesStream(),
        onData: (messages) {
          if (messages.isEmpty) {
            return ChatError(error: 'Chat messages are empty');
          }

          messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          return ChatLoaded(messages: messages);
        },
        onError: (error, stackTrace) => ChatError(error: error.toString()),
      );
    } catch (e) {
      emit(ChatError(error: e.toString()));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _chatRepository.sendMessage(event.message);
    } catch (e) {
      emit(ChatError(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
