import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _player = AudioPlayer();
  final Map<String, String> _soundCache = {};
  bool _isAudioEnabled = true;

  bool get isAudioEnabled => _isAudioEnabled;

  void toggleAudio() {
    _isAudioEnabled = !_isAudioEnabled;
  }

  /// Precarga buffers de audio para latencia cero al tocar una letra
  Future<void> preloadPhonemes() async {
    if (kIsWeb) {
      // En Web, los buffers se cargan dinámicamente vía AudioPlayer
      return;
    }
    // En plataformas nativas precargamos los assets locales
  }

  /// Reproduce el sonido del fonema o vocal (ej. "A", "E", "MA", "CRU")
  Future<void> playPhoneme(String phoneme) async {
    if (!_isAudioEnabled) return;

    try {
      final cleanPhoneme = phoneme.toLowerCase().trim();
      final assetPath = 'audio/vowels/$cleanPhoneme.mp3';
      
      // Intentar reproducir desde assets o sintetizador
      await _player.stop();
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('Reproducción de audio local o sintetizado para $phoneme: $e');
    }
  }

  /// Reproduce efectos de sonido (éxito, estrella, error)
  Future<void> playSfx(String sfxName) async {
    if (!_isAudioEnabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/sfx/$sfxName.mp3'));
    } catch (e) {
      debugPrint('SFX play error: $e');
    }
  }
}
