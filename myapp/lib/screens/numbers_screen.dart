import 'package:flutter/material.dart';
import 'database_helper.dart';
import '../models/number.dart';
import '../audio_manager.dart';
import 'number_detail_screen.dart';

class NumbersScreen extends StatefulWidget {
  const NumbersScreen({Key? key}) : super(key: key);

  @override
  State<NumbersScreen> createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Number> _numbers = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadNumbers();
  }

  Future<void> _loadNumbers() async {
    try {
      final numbersData = await _dbHelper.getAllNumbers();
      setState(() {
        _numbers = numbersData.map((data) => Number.fromMap(data)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузки цифр: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8A2BE2), // Фиолетовый фон
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          final numberSize = screenWidth * 0.11;
          final List<Map<String, double>> numberPositions = [
            {'left': 0.03, 'top': 0.30}, // 1
            {'left': 0.13, 'top': 0.42}, // 2
            {'left': 0.21, 'top': 0.58}, // 3
            {'left': 0.32, 'top': 0.48}, // 4
            {'left': 0.46, 'top': 0.33}, // 5
            {'left': 0.60, 'top': 0.48}, // 6
            {'left': 0.73, 'top': 0.65}, // 7
            {'left': 0.83, 'top': 0.48}, // 8
            {'left': 0.91, 'top': 0.33}, // 9
          ];
          return Stack(
            children: [
              // Фоновое облако на весь экран
              Positioned.fill(
                child: Image.asset(
                  'assets/cloude.png',
                  fit: BoxFit.cover,
                ),
              ),
              // Соединяющие точки между цифрами
              Positioned.fill(
                child: CustomPaint(
                  painter: DottedLinePainter(numberPositions, numberSize, screenWidth, screenHeight),
                ),
              ),
              // Адаптивные цифры
              ...List.generate(9, (i) => Positioned(
                left: screenWidth * numberPositions[i]['left']!,
                top: screenHeight * numberPositions[i]['top']!,
                child: GestureDetector(
                  onTap: () {
                    if (_numbers.length > i) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NumberDetailScreen(number: _numbers[i]),
                        ),
                      );
                    }
                  },
                  child: Image.asset(
                    'assets/numbers/${i + 1}.png',
                    width: numberSize,
                    height: numberSize,
                  ),
                ),
              )),
              if (_isLoading)
                const Center(child: CircularProgressIndicator()),
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
          );
        },
      ),
    );
  }

  // Диалоговое окно настроек
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

class DottedLinePainter extends CustomPainter {
  final List<Map<String, double>> positions;
  final double numberSize;
  final double screenWidth;
  final double screenHeight;

  DottedLinePainter(this.positions, this.numberSize, this.screenWidth, this.screenHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple[300]!
      ..strokeWidth = 4;
    for (int i = 0; i < positions.length - 1; i++) {
      final start = Offset(
        screenWidth * positions[i]['left']! + numberSize / 2,
        screenHeight * positions[i]['top']! + numberSize / 2,
      );
      final end = Offset(
        screenWidth * positions[i + 1]['left']! + numberSize / 2,
        screenHeight * positions[i + 1]['top']! + numberSize / 2,
      );
      _drawDottedLine(canvas, start, end, paint);
    }
  }

  void _drawDottedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const double dotSpacing = 18;
    final totalDistance = (end - start).distance;
    final direction = (end - start) / totalDistance;
    for (double d = 0; d < totalDistance; d += dotSpacing) {
      final offset = start + direction * d;
      canvas.drawCircle(offset, 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 