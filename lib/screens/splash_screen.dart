import 'package:bluetooth_chat/main.dart';
import 'package:bluetooth_chat/screens/chat_screen.dart';
import 'package:bluetooth_chat/screens/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => StreamBuilder(
                  stream: allBluetooth.listenForConnection,
                  builder: (context, snapshot) {
                    final result = snapshot.data;
                    if (result?.state == true) {
                      return const ChatScreen();
                    }
                    print(result);
                    return const HomeScreen();
                  })));
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double iconSize = screenHeight / 9;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: iconSize),
            const SizedBox(height: 20),
            const Text('BLUETOOTH CHAT',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange))
          ],
        ),
      ),
    );
  }
}
