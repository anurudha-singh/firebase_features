import 'package:firebase_application/features/bloc/auth_bloc.dart';
import 'package:firebase_application/features/chat/presentation/screens/chat_home_screen.dart';
import 'package:firebase_application/features/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is Authenticated) {
          return ChatHomeScreen(); // to be implemented
        } else {
          return LoginScreen(); // to be implemented
        }
      },
    );
  }
}
