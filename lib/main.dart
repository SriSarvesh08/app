import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/database/database_helper.dart';
import 'core/services/question_loader.dart';
import 'core/services/current_affairs_loader.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Catch any Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  // Initialize database - critical, must succeed
  try {
    await DatabaseHelper.instance.database;
  } catch (e) {
    debugPrint('Database init error: $e');
  }

  // Do not block UI startup for loading JSON data!
  Future.microtask(() async {
    try {
      await QuestionLoader.loadFromAsset();
    } catch (e) {
      debugPrint('QuestionLoader error: $e');
    }

    try {
      await CurrentAffairsLoader.loadFromAsset();
    } catch (e) {
      debugPrint('CurrentAffairsLoader error: $e');
    }

    try {
      await NotificationService.instance.initialize();
      await NotificationService.instance.scheduleDailyChallenge();
    } catch (e) {
      debugPrint('NotificationService error: $e');
    }
  });

  runApp(
    const ProviderScope(
      child: TNPSCApp(),
    ),
  );
}
