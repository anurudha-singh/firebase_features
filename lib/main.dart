import 'package:firebase_application/features/bloc/auth_bloc.dart';
import 'package:firebase_application/features/chat/bloc/chat_bloc.dart';
import 'package:firebase_application/features/chat/data/repositories/chat_repository.dart';
import 'package:firebase_application/features/data/repositories/auth_repository.dart';
import 'package:firebase_application/features/presentation/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authRepository = AuthRepository();

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository)..add(AuthStarted()),
        ),
        BlocProvider<ChatBloc>(create: (_) => ChatBloc(ChatRepository())),
      ],
      child: MaterialApp(title: 'Chat App', home: AuthGate()),
    );
  }
}
