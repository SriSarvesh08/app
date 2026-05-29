import 'dart:convert';
import 'package:flutter/services.dart';
import '../database/database_helper.dart';

/// Loads current affairs from JSON asset into SQLite database
class CurrentAffairsLoader {
  static Future<int> loadFromAsset() async {
    final db = DatabaseHelper.instance;

    final existingCount = await db.getCount('current_affairs');
    if (existingCount > 5) return existingCount;

    try {
      final jsonString = await rootBundle.loadString('assets/data/current_affairs.json');
      final data = json.decode(jsonString) as Map<String, dynamic>;
      final items = data['current_affairs'] as List<dynamic>;

      int loaded = 0;
      for (final item in items) {
        final map = item as Map<String, dynamic>;
        final existing = await db.queryWhere(
          'current_affairs',
          'title = ?',
          [map['title']],
        );
        if (existing.isEmpty) {
          await db.insert('current_affairs', {
            'title': map['title'],
            'content': map['content'],
            'category': map['category'],
            'date': map['date'],
            'month': map['month'],
            'year': map['year'],
          });
          loaded++;
        }
      }
      return loaded;
    } catch (e) {
      return 0;
    }
  }
}
