import 'package:flutter/material.dart';
import '../models/number.dart';
import '../audio_manager.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  final Number number;
  const GameScreen({Key? key, required this.number}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<int> cloudNumbers;
  late List<int> targetClouds;
  final Random random = Random();
  late List<bool> highlightClouds;
  int correctCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeGame();
    // Воспроизводим звук при старте игры
    AudioManager().playSound('numbersAudio/found_num/found_${widget.number.number}.mp3');
    highlightClouds = List.generate(11, (index) => false);
    correctCount = 0;
  }

  void _initializeGame() {
    // Создаем список всех возможных цифр (1-9)
    List<int> allNumbers = List.generate(9, (index) => index + 1);
    
    // Выбираем 3 случайных облака для целевой цифры
    targetClouds = List.generate(11, (index) => index)
        .toList()
        ..shuffle(random);
    targetClouds = targetClouds.sublist(0, 3);

    // Заполняем все облака случайными цифрами
    cloudNumbers = List.generate(11, (index) {
      if (targetClouds.contains(index)) {
        return widget.number.number;
      } else {
        // Выбираем случайную цифру, отличную от целевой
        allNumbers.remove(widget.number.number);
        int randomNumber = allNumbers[random.nextInt(allNumbers.length)];
        allNumbers.add(widget.number.number); // Возвращаем целевую цифру обратно в список
        return randomNumber;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    final List<Map<String, double>> cloudParams = [
      // Верхний ряд (4 облака)
      {'left': 0.12, 'top': 0.15, 'w': 0.18, 'h': 0.16},
      {'left': 0.30, 'top': 0.15, 'w': 0.20, 'h': 0.18},
      {'left': 0.48, 'top': 0.15, 'w': 0.18, 'h': 0.16},
      {'left': 0.64, 'top': 0.15, 'w': 0.20, 'h': 0.18},
      // Средний ряд (3 облака)
      {'left': 0.17, 'top': 0.40, 'w': 0.22, 'h': 0.20},
      {'left': 0.39, 'top': 0.40, 'w': 0.24, 'h': 0.22},
      {'left': 0.61, 'top': 0.40, 'w': 0.22, 'h': 0.20},
      // Нижний ряд (4 облака)
      {'left': 0.12, 'top': 0.65, 'w': 0.20, 'h': 0.18},
      {'left': 0.30, 'top': 0.65, 'w': 0.18, 'h': 0.16},
      {'left': 0.49, 'top': 0.65, 'w': 0.20, 'h': 0.18},
      {'left': 0.66, 'top': 0.65, 'w': 0.18, 'h': 0.16},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF8A2BE2),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/clouds3.png',
              fit: BoxFit.cover,
            ),
          ),
          ...List.generate(cloudParams.length, (i) => Positioned(
            left: screenWidth * cloudParams[i]['left']!,
            top: screenHeight * cloudParams[i]['top']!,
            child: GestureDetector(
              onTap: () {
                if (cloudNumbers[i] == widget.number.number) {
                  AudioManager().playSound('audio/yes.mp3');
                  setState(() {
                    highlightClouds[i] = true;
                    correctCount++;
                  });
                  if (correctCount == 3) {
                    Future.delayed(const Duration(milliseconds: 400), () async {
                      // Проигрываем случайный complite звук
                      int compliteNum = random.nextInt(3) + 1;
                      await AudioManager().playSound('audio/complite$compliteNum.mp3');
                      // Перемешиваем облака и сбрасываем подсветку и счетчик
                      setState(() {
                        _initializeGame();
                        highlightClouds = List.generate(11, (index) => false);
                        correctCount = 0;
                      });
                    });
                  }
                } else {
                  AudioManager().playSound('audio/no.mp3');
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  boxShadow: highlightClouds[i]
                      ? [BoxShadow(color: Colors.yellow.withOpacity(0.7), blurRadius: 30, spreadRadius: 5)]
                      : [],
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/cloude2.png',
                      width: screenWidth * cloudParams[i]['w']!,
                      height: screenHeight * cloudParams[i]['h']!,
                    ),
                    Image.asset(
                      'assets/numbers/small/${cloudNumbers[i]}S.png',
                      width: screenWidth * cloudParams[i]['w']! * 0.5,
                      height: screenHeight * cloudParams[i]['h']! * 0.5,
                    ),
                  ],
                ),
              ),
            ),
          )),
          // Кнопки настройки и возврата на главный экран
          Positioned(
            top: 5,
            right: 10,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    // TODO: реализовать показ настроек, например, вызвать _showSettingsDialog(context)
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
          // Кнопка возврата к предыдущему экрану
          Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 36),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
} 