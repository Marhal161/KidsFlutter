import 'package:flutter/material.dart';
import 'audio_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMusicPlaying = AudioManager().isMusicEnabled;

  @override
  void initState() {
    super.initState();
    _isMusicPlaying = AudioManager().isMusicEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[200], // Голубой фон
      body: Stack(
        children: [
          // Фон с облаками
          Positioned.fill(
            child: Image.asset(
              'assets/clouds.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Ряд картинок-кнопок
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Алфавит
                GestureDetector(
                  onTap: () {
                    print('Нажата кнопка Алфавит');
                    // Здесь можно добавить переход на нужный экран
                  },
                  child: Image.asset(
                    'assets/alphabet.png',
                    width: 180,
                    height: 270,
                  ),
                ),
                
                // Цифры
                GestureDetector(
                  onTap: () {
                    print('Нажата кнопка Цифры');
                    // Здесь можно добавить переход на нужный экран
                  },
                  child: Image.asset(
                    'assets/numbers.png',
                    width: 180,
                    height: 270,
                  ),
                ),
                
                // Животные
                GestureDetector(
                  onTap: () {
                    print('Нажата кнопка Животные');
                    // Здесь можно добавить переход на нужный экран
                  },
                  child: Image.asset(
                    'assets/animals.png',
                    width: 180,
                    height: 270,
                  ),
                ),
              ],
            ),
          ),
          
          // Кнопка настроек в правом верхнем углу
          Positioned(
            top: 5,
            right: 10,
            child: GestureDetector(
              onTap: () {
                _showSettingsDialog(context);
              },
              child: Image.asset(
                'assets/param.png',
                width: 45,
                height: 45,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Диалоговое окно настроек
  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: const Color(0xFFF5F5DC), // Бежевый цвет
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
                          value: _isMusicPlaying,
                          onChanged: (value) {
                            setState(() {
                              _isMusicPlaying = value;
                            });
                            setStateDialog(() {});
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
