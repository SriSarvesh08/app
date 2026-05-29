import 'package:shared_preferences/shared_preferences.dart';

/// Service to track daily study streaks, XP, and daily quiz completion.
/// Persists data via SharedPreferences for fast access.
class StreakService {
  static final StreakService instance = StreakService._init();
  StreakService._init();

  static const _keyLastActiveDate = 'last_active_date';
  static const _keyStreakDays = 'streak_days';
  static const _keyTotalXP = 'total_xp';
  static const _keyDailyQuizDone = 'daily_quiz_done_date';
  static const _keyTotalQuizzesTaken = 'total_quizzes_taken';

  /// Call this on every app launch to update streak.
  Future<void> checkAndUpdateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayString();
    final lastActive = prefs.getString(_keyLastActiveDate);

    if (lastActive == null) {
      // First time user
      await prefs.setString(_keyLastActiveDate, today);
      await prefs.setInt(_keyStreakDays, 1);
      return;
    }

    if (lastActive == today) return; // Already checked in today

    final lastDate = DateTime.tryParse(lastActive);
    final todayDate = DateTime.tryParse(today);
    if (lastDate != null && todayDate != null) {
      final diff = todayDate.difference(lastDate).inDays;
      if (diff == 1) {
        // Consecutive day — increment streak
        final current = prefs.getInt(_keyStreakDays) ?? 0;
        await prefs.setInt(_keyStreakDays, current + 1);
      } else if (diff > 1) {
        // Streak broken — reset
        await prefs.setInt(_keyStreakDays, 1);
      }
    }

    await prefs.setString(_keyLastActiveDate, today);
  }

  Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyStreakDays) ?? 0;
  }

  Future<int> getTotalXP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTotalXP) ?? 0;
  }

  /// Award XP for completing an action (answering question, finishing quiz, etc.)
  Future<void> addXP(int points) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_keyTotalXP) ?? 0;
    await prefs.setInt(_keyTotalXP, current + points);
  }

  /// Check if today's daily quiz is already completed.
  Future<bool> isDailyQuizDone() async {
    final prefs = await SharedPreferences.getInstance();
    final doneDate = prefs.getString(_keyDailyQuizDone);
    return doneDate == _todayString();
  }

  /// Mark daily quiz as completed for today.
  Future<void> completeDailyQuiz() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDailyQuizDone, _todayString());
    final total = prefs.getInt(_keyTotalQuizzesTaken) ?? 0;
    await prefs.setInt(_keyTotalQuizzesTaken, total + 1);
    await addXP(50); // Bonus XP for daily quiz
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
