class Letter {
  final String letter;
  final String imagePath;
  final String audioPath;

  Letter({
    required this.letter,
    required this.imagePath,
    required this.audioPath,
  });

  factory Letter.fromMap(Map<String, dynamic> map) {
    return Letter(
      letter: map['letter'] as String,
      imagePath: map['image_path'] as String,
      audioPath: map['audio_path'] as String,
    );
  }
}