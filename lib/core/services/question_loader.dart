import 'dart:convert';
import 'package:flutter/services.dart';
import '../database/database_helper.dart';

/// Loads questions from JSON asset file into SQLite database
class QuestionLoader {
  static Future<int> loadFromAsset() async {
    final db = DatabaseHelper.instance;
    
    // Check if already loaded
    final existingCount = await db.getCount('questions');
    if (existingCount > 15) return existingCount; // Already seeded + loaded

    try {
      final jsonString = await rootBundle.loadString('assets/data/questions.json');
      final data = json.decode(jsonString) as Map<String, dynamic>;
      final questions = data['questions'] as List<dynamic>;

      int loaded = 0;
      for (final q in questions) {
        final map = q as Map<String, dynamic>;
        // Check if question already exists
        final existing = await db.queryWhere(
          'questions',
          'question_text = ?',
          [map['question_text']],
        );
        if (existing.isEmpty) {
          await db.insert('questions', {
            'category': map['category'],
            'topic': map['topic'],
            'difficulty': map['difficulty'] ?? 1,
            'question_text': map['question_text'],
            'option_a': map['option_a'],
            'option_b': map['option_b'],
            'option_c': map['option_c'],
            'option_d': map['option_d'],
            'correct_option': map['correct_option'],
            'explanation': map['explanation'] ?? '',
            'shortcut_method': map['shortcut_method'] ?? '',
            'language': map['language'] ?? 'en',
          });
          loaded++;
        }
      }
      return loaded;
    } catch (e) {
      return 0;
    }
  }

  /// Add questions from a JSON string (for future updates)
  static Future<int> loadFromString(String jsonString) async {
    final db = DatabaseHelper.instance;
    try {
      final data = json.decode(jsonString) as Map<String, dynamic>;
      final questions = data['questions'] as List<dynamic>;
      int loaded = 0;

      for (final q in questions) {
        final map = q as Map<String, dynamic>;
        await db.insert('questions', {
          'category': map['category'],
          'topic': map['topic'],
          'difficulty': map['difficulty'] ?? 1,
          'question_text': map['question_text'],
          'option_a': map['option_a'],
          'option_b': map['option_b'],
          'option_c': map['option_c'],
          'option_d': map['option_d'],
          'correct_option': map['correct_option'],
          'explanation': map['explanation'] ?? '',
          'shortcut_method': map['shortcut_method'] ?? '',
          'language': map['language'] ?? 'en',
        });
        loaded++;
      }
      return loaded;
    } catch (e) {
      return 0;
    }
  }
}
