import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  late final AudioPlayer _player;
  late final AudioPlayer _effectPlayer;
  bool _isPlaying = false;
  bool _isMusicEnabled = true;

  AudioManager._internal() {
    _player = AudioPlayer();
    _effectPlayer = AudioPlayer();
  }

  Future<void> playMusic() async {
    if (_isMusicEnabled && !_isPlaying) {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('audio/fon.mp3'));
      _isPlaying = true;
    }
  }

  Future<void> stopMusic() async {
    if (_isPlaying) {
      await _player.stop();
      _isPlaying = false;
    }
  }

  void toggleMusic() async {
    _isMusicEnabled = !_isMusicEnabled;
    
    if (_isMusicEnabled) {
      await playMusic();
    } else {
      await stopMusic();
    }
  }

  bool get isPlaying => _isPlaying;
  bool get isMusicEnabled => _isMusicEnabled;

  Future<void> playSound(String soundPath) async {
    if (_isMusicEnabled) {
      await _player.setVolume(0.3);
      await _effectPlayer.stop();
      await _effectPlayer.setReleaseMode(ReleaseMode.release);
      await _effectPlayer.play(AssetSource(soundPath));
      _effectPlayer.onPlayerComplete.listen((event) async {
        await _player.setVolume(1.0);
      });
    }
  }
}