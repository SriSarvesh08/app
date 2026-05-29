import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final TTSService instance = TTSService._init();
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;

  TTSService._init();

  Future<void> initialize() async {
    if (_isInitialized) return;
    await _tts.setLanguage('en-IN');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    await initialize();
    // Strip markdown formatting for TTS
    final cleanText = text
        .replaceAll(RegExp(r'\*\*'), '')
        .replaceAll(RegExp(r'[•📊🧩📝📰🎯💡💪🔥✨📖🏆👋🤖📋⏰⚡💰📅🌟💎🔢✍️👨‍👩‍👧‍👦🔐⚖️📌🗺️]'), '')
        .replaceAll(RegExp(r'\n+'), '. ');
    await _tts.speak(cleanText);
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  Future<void> setLanguage(String lang) async {
    await _tts.setLanguage(lang == 'ta' ? 'ta-IN' : 'en-IN');
  }
}
