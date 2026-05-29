import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants/app_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(AppConstants.dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: AppConstants.dbVersion, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE,
        password_hash TEXT,
        avatar_index INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        streak_days INTEGER DEFAULT 0,
        total_xp INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        topic TEXT NOT NULL,
        difficulty INTEGER DEFAULT 1,
        question_text TEXT NOT NULL,
        option_a TEXT NOT NULL,
        option_b TEXT NOT NULL,
        option_c TEXT NOT NULL,
        option_d TEXT NOT NULL,
        correct_option TEXT NOT NULL,
        explanation TEXT,
        shortcut_method TEXT,
        language TEXT DEFAULT 'en'
      )
    ''');

    await db.execute('''
      CREATE TABLE user_answers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        question_id INTEGER,
        selected_option TEXT,
        is_correct INTEGER,
        time_taken_seconds INTEGER,
        answered_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER DEFAULT 1,
        message TEXT NOT NULL,
        is_user INTEGER NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE mock_tests (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER DEFAULT 1,
        test_name TEXT,
        total_questions INTEGER,
        correct_answers INTEGER,
        wrong_answers INTEGER,
        skipped INTEGER DEFAULT 0,
        score REAL,
        time_taken_seconds INTEGER,
        categories TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE current_affairs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT,
        date TEXT,
        month TEXT,
        year INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER DEFAULT 1,
        question_id INTEGER,
        note TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE user_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER DEFAULT 1,
        category TEXT,
        topic TEXT,
        total_attempted INTEGER DEFAULT 0,
        total_correct INTEGER DEFAULT 0,
        accuracy REAL DEFAULT 0.0,
        best_streak INTEGER DEFAULT 0,
        mastery_level INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE achievements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER DEFAULT 1,
        badge_name TEXT,
        badge_icon TEXT,
        description TEXT,
        unlocked_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Seed initial questions
    await _seedQuestions(db);
  }

  Future<void> _seedQuestions(Database db) async {
    final questions = [
      // Aptitude - Percentages
      {'category': 'aptitude', 'topic': 'Percentages', 'difficulty': 1, 'question_text': 'What is 25% of 200?', 'option_a': '40', 'option_b': '50', 'option_c': '60', 'option_d': '75', 'correct_option': 'B', 'explanation': '25% of 200 = (25/100) × 200 = 50', 'shortcut_method': '25% = 1/4, so 200/4 = 50'},
      {'category': 'aptitude', 'topic': 'Percentages', 'difficulty': 1, 'question_text': 'If a number is increased by 20%, then decreased by 20%, the net change is?', 'option_a': '0%', 'option_b': '-4%', 'option_c': '4%', 'option_d': '-2%', 'correct_option': 'B', 'explanation': 'Net change = -20×20/100 = -4%. The number decreases by 4%.', 'shortcut_method': 'For successive change: a + b + ab/100'},
      {'category': 'aptitude', 'topic': 'Percentages', 'difficulty': 2, 'question_text': 'A student scored 280 out of 400. What is the percentage?', 'option_a': '65%', 'option_b': '70%', 'option_c': '72%', 'option_d': '75%', 'correct_option': 'B', 'explanation': '(280/400) × 100 = 70%', 'shortcut_method': '280/4 = 70%'},

      // Aptitude - Profit and Loss
      {'category': 'aptitude', 'topic': 'Profit and Loss', 'difficulty': 1, 'question_text': 'A shopkeeper buys an article for ₹500 and sells it for ₹600. What is the profit percentage?', 'option_a': '10%', 'option_b': '15%', 'option_c': '20%', 'option_d': '25%', 'correct_option': 'C', 'explanation': 'Profit = 600-500 = 100. Profit% = (100/500)×100 = 20%', 'shortcut_method': 'Profit% = (Profit/CP)×100'},
      {'category': 'aptitude', 'topic': 'Profit and Loss', 'difficulty': 2, 'question_text': 'If SP is ₹450 and loss is 10%, find the CP.', 'option_a': '₹495', 'option_b': '₹500', 'option_c': '₹510', 'option_d': '₹550', 'correct_option': 'B', 'explanation': 'CP = SP×100/(100-Loss%) = 450×100/90 = 500', 'shortcut_method': 'CP = SP × 100/(100 - L%)'},

      // Aptitude - Time and Work
      {'category': 'aptitude', 'topic': 'Time and Work', 'difficulty': 1, 'question_text': 'A can do a work in 10 days. B can do the same work in 15 days. In how many days can they complete it together?', 'option_a': '5 days', 'option_b': '6 days', 'option_c': '7 days', 'option_d': '8 days', 'correct_option': 'B', 'explanation': 'A\'s rate = 1/10, B\'s rate = 1/15. Together = 1/10 + 1/15 = 5/30 = 1/6. So 6 days.', 'shortcut_method': 'Together = (A×B)/(A+B) = 150/25 = 6'},

      // Reasoning - Number Series
      {'category': 'reasoning', 'topic': 'Number Series', 'difficulty': 1, 'question_text': 'Find the next number: 2, 6, 12, 20, 30, ?', 'option_a': '40', 'option_b': '42', 'option_c': '44', 'option_d': '46', 'correct_option': 'B', 'explanation': 'Differences: 4, 6, 8, 10, 12. Next = 30 + 12 = 42', 'shortcut_method': 'Pattern: n(n+1). 6×7 = 42'},
      {'category': 'reasoning', 'topic': 'Number Series', 'difficulty': 2, 'question_text': 'Find the missing: 3, 9, 27, 81, ?', 'option_a': '162', 'option_b': '200', 'option_c': '243', 'option_d': '270', 'correct_option': 'C', 'explanation': 'Each number is multiplied by 3. 81 × 3 = 243', 'shortcut_method': 'Geometric series: ×3'},

      // Reasoning - Blood Relations
      {'category': 'reasoning', 'topic': 'Blood Relations', 'difficulty': 1, 'question_text': 'Pointing to a man, a woman said "His mother is the only daughter of my mother". How is the woman related to the man?', 'option_a': 'Mother', 'option_b': 'Grandmother', 'option_c': 'Sister', 'option_d': 'Aunt', 'correct_option': 'A', 'explanation': 'The only daughter of my mother = the woman herself. So the woman is the man\'s mother.', 'shortcut_method': 'Only daughter of my mother = myself'},

      // Verbal - Synonyms
      {'category': 'verbal', 'topic': 'Synonyms', 'difficulty': 1, 'question_text': 'Choose the synonym of "Abundant":', 'option_a': 'Scarce', 'option_b': 'Plentiful', 'option_c': 'Rare', 'option_d': 'Limited', 'correct_option': 'B', 'explanation': 'Abundant means existing in large quantities, which is the same as plentiful.', 'shortcut_method': ''},
      {'category': 'verbal', 'topic': 'Antonyms', 'difficulty': 1, 'question_text': 'Choose the antonym of "Optimistic":', 'option_a': 'Hopeful', 'option_b': 'Cheerful', 'option_c': 'Pessimistic', 'option_d': 'Positive', 'correct_option': 'C', 'explanation': 'Optimistic = hopeful. Its opposite is pessimistic = hopeless.', 'shortcut_method': ''},

      // Verbal - Grammar
      {'category': 'verbal', 'topic': 'Grammar', 'difficulty': 1, 'question_text': 'Choose the correct sentence:', 'option_a': 'He don\'t know nothing', 'option_b': 'He doesn\'t know anything', 'option_c': 'He don\'t knows anything', 'option_d': 'He doesn\'t knows nothing', 'correct_option': 'B', 'explanation': 'Third person singular uses "doesn\'t" + base verb. Avoid double negatives.', 'shortcut_method': 'He/She/It + doesn\'t + V1'},
    ];

    for (final q in questions) {
      await db.insert('questions', q);
    }
  }

  // CRUD Operations
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryWhere(String table, String where, List<dynamic> args) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: args);
  }

  Future<int> update(String table, Map<String, dynamic> data, String where, List<dynamic> args) async {
    final db = await database;
    return await db.update(table, data, where: where, whereArgs: args);
  }

  Future<int> delete(String table, String where, List<dynamic> args) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: args);
  }

  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? args]) async {
    final db = await database;
    return await db.rawQuery(sql, args);
  }

  Future<int> getCount(String table) async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM $table');
    return result.first['count'] as int;
  }
}
