import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../core/database/database_helper.dart';
import '../../core/services/ai_service.dart';
import '../../models/question.dart';
import '../../widgets/animated_card.dart';
import '../../widgets/gradient_button.dart';

class TopicDetailScreen extends StatefulWidget {
  final String category;
  final String topic;
  final Color color;

  const TopicDetailScreen({
    super.key,
    required this.category,
    required this.topic,
    required this.color,
  });

  @override
  State<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends State<TopicDetailScreen> {
  List<Question> _questions = [];
  int _currentIndex = 0;
  String? _selectedOption;
  bool _answered = false;
  bool _showExplanation = false;
  int _correctCount = 0;
  int _selectedDifficulty = 1;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final db = DatabaseHelper.instance;
    final rows = await db.queryWhere(
      'questions',
      'category = ? AND topic = ? AND difficulty = ?',
      [widget.category, widget.topic, _selectedDifficulty],
    );
    if (mounted) {
      setState(() {
        _questions = rows.map((r) => Question.fromMap(r)).toList();
        _currentIndex = 0;
        _selectedOption = null;
        _answered = false;
        _showExplanation = false;
      });
    }
  }

  void _checkAnswer(String option) {
    if (_answered) return;
    final q = _questions[_currentIndex];
    final isCorrect = option == q.correctOption;

    setState(() {
      _selectedOption = option;
      _answered = true;
      if (isCorrect) _correctCount++;
    });

    // Save answer
    DatabaseHelper.instance.insert('user_answers', {
      'question_id': q.id,
      'selected_option': option,
      'is_correct': isCorrect ? 1 : 0,
      'time_taken_seconds': 0,
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = false;
        _showExplanation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic),
        actions: [
          if (_questions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_currentIndex + 1}/${_questions.length}',
                  style: TextStyle(fontWeight: FontWeight.w600, color: widget.color),
                ),
              ),
            ),
        ],
      ),
      body: _questions.isEmpty
          ? _buildEmptyState(isDark)
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Difficulty selector
                  Row(
                    children: [1, 2, 3].map((d) {
                      final labels = ['Easy', 'Medium', 'Hard'];
                      final colors = [AppColors.success, AppColors.warning, AppColors.error];
                      final selected = _selectedDifficulty == d;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(labels[d - 1], style: TextStyle(fontSize: 12, color: selected ? Colors.white : colors[d - 1])),
                          selected: selected,
                          selectedColor: colors[d - 1],
                          backgroundColor: colors[d - 1].withOpacity(0.1),
                          onSelected: (s) {
                            setState(() => _selectedDifficulty = d);
                            _loadQuestions();
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  // Progress bar
                  LinearProgressIndicator(
                    value: (_currentIndex + 1) / _questions.length,
                    backgroundColor: widget.color.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation(widget.color),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 24),
                  // Question
                  AnimatedCard(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      _questions[_currentIndex].questionText,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1.5, color: isDark ? Colors.white : AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Options
                  ...['A', 'B', 'C', 'D'].map((opt) => _buildOption(opt, isDark)),
                  const SizedBox(height: 16),
                  // Explanation
                  if (_answered) ...[
                    GradientButton(
                      text: _showExplanation ? 'Hide Explanation' : 'Show Explanation',
                      icon: Icons.lightbulb_outline_rounded,
                      gradient: AppColors.goldGradient,
                      onPressed: () => setState(() => _showExplanation = !_showExplanation),
                    ),
                    if (_showExplanation) ...[
                      const SizedBox(height: 12),
                      AnimatedCard(
                        padding: const EdgeInsets.all(16),
                        color: AppColors.success.withOpacity(0.08),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('💡 Explanation', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.success)),
                            const SizedBox(height: 8),
                            Text(_questions[_currentIndex].explanation ?? 'No explanation available.', style: TextStyle(height: 1.5, color: isDark ? Colors.white70 : AppColors.textPrimary)),
                            if (_questions[_currentIndex].shortcutMethod?.isNotEmpty ?? false) ...[
                              const SizedBox(height: 12),
                              Text('⚡ Shortcut', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.accentGold)),
                              const SizedBox(height: 4),
                              Text(_questions[_currentIndex].shortcutMethod!, style: TextStyle(height: 1.5, color: isDark ? Colors.white70 : AppColors.textPrimary)),
                            ],
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    if (_currentIndex < _questions.length - 1)
                      GradientButton(
                        text: 'Next Question →',
                        gradient: AppColors.primaryGradient,
                        onPressed: _nextQuestion,
                      ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildOption(String letter, bool isDark) {
    final q = _questions[_currentIndex];
    final text = q.getOption(letter);
    final isSelected = _selectedOption == letter;
    final isCorrect = q.correctOption == letter;

    Color bgColor;
    Color borderColor;
    if (!_answered) {
      bgColor = isDark ? AppColors.darkCard : Colors.white;
      borderColor = isDark ? AppColors.darkBorder : Colors.grey.shade200;
    } else if (isCorrect) {
      bgColor = AppColors.success.withOpacity(0.1);
      borderColor = AppColors.success;
    } else if (isSelected && !isCorrect) {
      bgColor = AppColors.error.withOpacity(0.1);
      borderColor = AppColors.error;
    } else {
      bgColor = isDark ? AppColors.darkCard : Colors.white;
      borderColor = isDark ? AppColors.darkBorder : Colors.grey.shade200;
    }

    return GestureDetector(
      onTap: () => _checkAnswer(letter),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: isSelected || (_answered && isCorrect) ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _answered && isCorrect
                    ? AppColors.success
                    : (_answered && isSelected ? AppColors.error : widget.color.withOpacity(0.15)),
              ),
              child: Center(
                child: _answered && (isCorrect || isSelected)
                    ? Icon(isCorrect ? Icons.check : Icons.close, color: Colors.white, size: 18)
                    : Text(letter, style: TextStyle(fontWeight: FontWeight.w600, color: widget.color)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(text, style: TextStyle(fontSize: 15, color: isDark ? Colors.white : AppColors.textPrimary))),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📚', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text('No questions available', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text('Try a different difficulty level', style: TextStyle(color: isDark ? Colors.white38 : AppColors.textSecondary)),
        ],
      ),
    );
  }
}
