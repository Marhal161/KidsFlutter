class Number {
  final int number;
  final String imagePath;
  final String audioPath;
  final String imageSPath;
  final String imageBPath;

  Number({
    required this.number,
    required this.imagePath,
    required this.audioPath,
    required this.imageSPath,
    required this.imageBPath,
  });

  factory Number.fromMap(Map<String, dynamic> map) {
    return Number(
      number: map['number'] as int,
      imagePath: map['image_path'] as String,
      audioPath: map['audio_path'] as String,
      imageSPath: map['image_s_path'] as String,
      imageBPath: map['image_b_path'] as String,
    );
  }
} 