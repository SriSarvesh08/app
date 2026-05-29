import 'package:intl/intl.dart';
import 'dart:math';

class Helpers {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  static String getRandomMotivation() {
    final quotes = [
      'Keep pushing! Every question counts! 💪',
      'You\'re getting better every day! 📈',
      'Consistency is the key to success! 🔑',
      'One step at a time. You\'ll get there! 🚀',
      'Great progress today! Keep it up! ⭐',
    ];
    return quotes[Random().nextInt(quotes.length)];
  }

  static double calculateAccuracy(int correct, int total) {
    if (total == 0) return 0.0;
    return (correct / total) * 100;
  }

  static String getMasteryLabel(int level) {
    switch (level) {
      case 0: return 'Beginner';
      case 1: return 'Learner';
      case 2: return 'Intermediate';
      case 3: return 'Advanced';
      case 4: return 'Expert';
      case 5: return 'Master';
      default: return 'Beginner';
    }
  }

  static String getXPLabel(int xp) {
    if (xp < 100) return 'Newbie';
    if (xp < 500) return 'Learner';
    if (xp < 1000) return 'Achiever';
    if (xp < 2500) return 'Scholar';
    if (xp < 5000) return 'Expert';
    return 'Master';
  }
}
