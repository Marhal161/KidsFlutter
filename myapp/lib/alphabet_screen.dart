import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'letter.dart';
import 'audio_manager.dart';

class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({Key? key}) : super(key: key);

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Letter> _letters = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadLetters();
  }

  Future<void> _loadLetters() async {
    try {
      final lettersData = await _dbHelper.getAllLetters();
      setState(() {
        _letters = lettersData.map((data) => Letter.fromMap(data)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузки букв: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00FF00), // Ярко-зеленый фон
      body: Stack(
        children: [
          // Фоновое изображение flow.png на весь экран
          Positioned.fill(
            child: Image.asset(
              'assets/flow.png',
              fit: BoxFit.cover,
            ),
          ),
          // Только одна картинка по центру
          if (!_isLoading && _letters.isNotEmpty)
            Center(
              child: GestureDetector(
                onTap: () {
                  AudioManager().playSound(_letters[_currentIndex].audioPath);
                },
                child: Image.asset(
                  _letters[_currentIndex].imagePath,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.8,
                ),
              ),
            ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),

          // Кнопка следующей буквы (правый нижний угол)
          if (!_isLoading && _letters.length > 1)
            Positioned(
              right: 20,
              bottom: 20,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = (_currentIndex + 1) % _letters.length;
                  });
                },
                child: Image.asset(
                  'assets/next.png',
                  width: 60,
                  height: 60,
                ),
              ),
            ),

            // Кнопка предыдущей буквы (левый нижний угол)
            if (!_isLoading && _letters.length > 1)
              Positioned(
                left: 20,
                bottom: 20,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = (_currentIndex - 1 + _letters.length) % _letters.length;
                    });
                  },
                  child: Transform.rotate(
                    angle: 3.1416, // 180 градусов
                    child: Image.asset(
                      'assets/next.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
              ),

          // Кнопки настройки и возврата на главный экран в правом верхнем углу
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

  // Диалоговое окно настроек (скопировано с главной страницы)
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
