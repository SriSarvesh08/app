class AppConstants {
  static const String appName = 'examGenious';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Your Smart Offline Exam Coach';
  static const String dbName = 'tnpsc_ai.db';
  static const int dbVersion = 1;
  static const String modelName = 'gemma-2b-it-q4_k_m.gguf';
  static const int maxTokens = 512;
  static const double temperature = 0.7;

  static const String categoryAptitude = 'aptitude';
  static const String categoryReasoning = 'reasoning';
  static const String categoryVerbal = 'verbal';
  static const String categoryCurrentAffairs = 'current_affairs';

  static const List<String> aptitudeTopics = [
    'Percentages', 'Ratio and Proportion', 'Profit and Loss',
    'Time and Work', 'Time and Distance', 'Simplification',
    'Number Systems', 'Average', 'Probability',
    'Simple Interest', 'Compound Interest',
  ];

  static const List<String> reasoningTopics = [
    'Blood Relations', 'Coding-Decoding', 'Seating Arrangement',
    'Direction Sense', 'Number Series', 'Puzzle Solving',
    'Logical Reasoning', 'Syllogism', 'Analogy',
  ];

  static const List<String> verbalTopics = [
    'Synonyms', 'Antonyms', 'Grammar', 'Error Detection',
    'Reading Comprehension', 'Sentence Correction',
    'Fill in the Blanks', 'Idioms and Phrases',
  ];

  static const List<String> motivationalQuotes = [
    '"Success is not final, failure is not fatal." 💪',
    '"The secret of getting ahead is getting started." 🚀',
    '"Believe you can and you\'re halfway there." ✨',
    '"Every expert was once a beginner." 📖',
    '"Hard work beats talent when talent doesn\'t work hard." 🔥',
  ];
}
