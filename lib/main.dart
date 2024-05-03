import 'package:all_bluetooth/all_bluetooth.dart';
import 'package:bluetooth_chat/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

final allBluetooth = AllBluetooth();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Chat',
      home: const SplashScreen(),
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
    );
  }
}
