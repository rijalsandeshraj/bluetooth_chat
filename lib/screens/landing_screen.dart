import 'package:bluetooth_chat/main.dart';
import 'package:bluetooth_chat/screens/chat_screen.dart';
import 'package:bluetooth_chat/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: allBluetooth.listenForConnection,
        builder: (context, snapshot) {
          final result = snapshot.data;
          if (result?.state == true) {
            return const ChatScreen();
          }
          return const HomeScreen();
        });
  }
}
