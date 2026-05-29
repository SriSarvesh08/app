import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isDarkMode') ?? false;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', state);
  }
}

// Current user provider
final currentUserProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {'id': 1, 'name': 'Student', 'streak_days': 0, 'total_xp': 0};
});

// Bottom nav index
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

// Language provider ('en' or 'ta')
final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('en') {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('app_lang') ?? 'en';
  }

  Future<void> toggleLanguage() async {
    state = state == 'en' ? 'ta' : 'en';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_lang', state);
  }
}

// Chat loading state
final chatLoadingProvider = StateProvider<bool>((ref) => false);

// Selected difficulty
final difficultyProvider = StateProvider<int>((ref) => 1);

// Mock test timer
final testTimerProvider = StateProvider<int>((ref) => 0);
