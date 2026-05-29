import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:math';

/// Notification service for daily study reminders
class NotificationService {
  static final NotificationService instance = NotificationService._init();
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  NotificationService._init();

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  Future<void> showStudyReminder() async {
    await initialize();
    final messages = [
      '📚 Time to study! Your TNPSC preparation awaits.',
      '🎯 Quick 10-minute practice session? Open the app!',
      '🔥 Don\'t break your streak! Practice today.',
      '💡 New questions are waiting for you!',
      '📊 Review your weak topics today!',
    ];
    final message = messages[Random().nextInt(messages.length)];

    const androidDetails = AndroidNotificationDetails(
      'study_reminders',
      'Study Reminders',
      channelDescription: 'Daily study reminders for TNPSC preparation',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      'TNPSC AI Assistant',
      message,
      details,
    );
  }

  Future<void> showAchievement(String title, String body) async {
    await initialize();
    const androidDetails = AndroidNotificationDetails(
      'achievements',
      'Achievements',
      channelDescription: 'Achievement unlocked notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const details = NotificationDetails(android: androidDetails);
    await _plugin.show(1, title, body, details);
  }

  Future<void> scheduleDailyChallenge() async {
    await initialize();
    const androidDetails = AndroidNotificationDetails(
      'daily_challenge',
      'Daily Challenge',
      channelDescription: 'Scheduled TNPSC Daily High-Yield Questions at 9:00 AM',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const details = NotificationDetails(android: androidDetails);
    await _plugin.periodicallyShow(
      2,
      '🔥 TNPSC Daily Challenge!',
      'Solve your high-yield daily practice question right now and boost your streak!',
      RepeatInterval.daily,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
