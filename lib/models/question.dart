class Question {
  final int? id;
  final String category;
  final String topic;
  final int difficulty;
  final String questionText;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctOption;
  final String? explanation;
  final String? shortcutMethod;
  final String language;

  Question({
    this.id,
    required this.category,
    required this.topic,
    this.difficulty = 1,
    required this.questionText,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
    this.explanation,
    this.shortcutMethod,
    this.language = 'en',
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as int?,
      category: map['category'] as String,
      topic: map['topic'] as String,
      difficulty: map['difficulty'] as int? ?? 1,
      questionText: map['question_text'] as String,
      optionA: map['option_a'] as String,
      optionB: map['option_b'] as String,
      optionC: map['option_c'] as String,
      optionD: map['option_d'] as String,
      correctOption: map['correct_option'] as String,
      explanation: map['explanation'] as String?,
      shortcutMethod: map['shortcut_method'] as String?,
      language: map['language'] as String? ?? 'en',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'topic': topic,
      'difficulty': difficulty,
      'question_text': questionText,
      'option_a': optionA,
      'option_b': optionB,
      'option_c': optionC,
      'option_d': optionD,
      'correct_option': correctOption,
      'explanation': explanation,
      'shortcut_method': shortcutMethod,
      'language': language,
    };
  }

  String getOption(String letter) {
    switch (letter.toUpperCase()) {
      case 'A': return optionA;
      case 'B': return optionB;
      case 'C': return optionC;
      case 'D': return optionD;
      default: return '';
    }
  }
}
