class MockTest {
  final int? id;
  final String testName;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final int skipped;
  final double score;
  final int timeTakenSeconds;
  final String? categories;
  final DateTime createdAt;

  MockTest({
    this.id,
    required this.testName,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    this.skipped = 0,
    required this.score,
    required this.timeTakenSeconds,
    this.categories,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory MockTest.fromMap(Map<String, dynamic> map) {
    return MockTest(
      id: map['id'] as int?,
      testName: map['test_name'] as String? ?? 'Mock Test',
      totalQuestions: map['total_questions'] as int,
      correctAnswers: map['correct_answers'] as int,
      wrongAnswers: map['wrong_answers'] as int,
      skipped: map['skipped'] as int? ?? 0,
      score: (map['score'] as num).toDouble(),
      timeTakenSeconds: map['time_taken_seconds'] as int,
      categories: map['categories'] as String?,
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'test_name': testName,
      'total_questions': totalQuestions,
      'correct_answers': correctAnswers,
      'wrong_answers': wrongAnswers,
      'skipped': skipped,
      'score': score,
      'time_taken_seconds': timeTakenSeconds,
      'categories': categories,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
