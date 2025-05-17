import 'package:flutter/material.dart';
import '../models/number.dart';
import '../audio_manager.dart';
import 'game_screen.dart';

class NumberDetailScreen extends StatelessWidget {
  final Number number;
  const NumberDetailScreen({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF8A2BE2),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/clouds2.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    AudioManager().playSound(number.audioPath);
                  },
                  child: Image.asset(
                    number.imageBPath,
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.5,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GameScreen(number: number)),
                    );
                  },
                  child: Image.asset(
                    'assets/game.png',
                    width: 35,
                    height: 35,
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          Positioned(
            top: 30,
            left: 30,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 36),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          // Кнопки настройки и возврата на главный экран
          Positioned(
            top: 5,
            right: 10,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    _showSettingsDialog(context);
                  },
                  child: Image.asset(
                    'assets/param.png',
                    width: 35,
                    height: 35,
                  ),
                ),
                const SizedBox(width: 14),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Image.asset(
                    'assets/home.png',
                    width: 35,
                    height: 35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isMusicPlaying = AudioManager().isMusicEnabled;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: const Color(0xFFF5F5DC),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Настройки',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Музыка:',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Switch(
                          value: isMusicPlaying,
                          onChanged: (value) {
                            setStateDialog(() {
                              isMusicPlaying = value;
                            });
                            AudioManager().toggleMusic();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Закрыть'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
} 