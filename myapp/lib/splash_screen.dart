import 'package:flutter/material.dart';
import 'dart:async';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Переходим на главный экран через 3 секунды
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFF1493), // Deep Pink
      body: Stack(
        children: [
          // Подпись по центру сверху
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Image.asset(
                'assets/signature.png',
                width: 260,
                height: 100,
              ),
            ),
          ),
          // Логотип большой внизу экрана
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/logo.png',
              width: screenHeight * 0.9, // Размер относительно высоты экрана
              height: screenHeight * 0.9, // Размер относительно высоты экрана
              fit: BoxFit.contain, // Сохраняет пропорции
              alignment: Alignment.bottomCenter, // Выравнивание по низу
            ),
          ),
        ],
      ),
    );
  }
} 