class UserProgress {
  final int? id;
  final String category;
  final String topic;
  final int totalAttempted;
  final int totalCorrect;
  final double accuracy;
  final int bestStreak;
  final int masteryLevel;

  UserProgress({
    this.id,
    required this.category,
    required this.topic,
    this.totalAttempted = 0,
    this.totalCorrect = 0,
    this.accuracy = 0.0,
    this.bestStreak = 0,
    this.masteryLevel = 0,
  });

  factory UserProgress.fromMap(Map<String, dynamic> map) {
    return UserProgress(
      id: map['id'] as int?,
      category: map['category'] as String,
      topic: map['topic'] as String,
      totalAttempted: map['total_attempted'] as int? ?? 0,
      totalCorrect: map['total_correct'] as int? ?? 0,
      accuracy: (map['accuracy'] as num?)?.toDouble() ?? 0.0,
      bestStreak: map['best_streak'] as int? ?? 0,
      masteryLevel: map['mastery_level'] as int? ?? 0,
    );
  }
}
