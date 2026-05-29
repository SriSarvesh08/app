import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/routes/app_router.dart';
import '../../core/database/database_helper.dart';
import '../../core/utils/helpers.dart';
import '../../models/question.dart';
import '../../widgets/gradient_button.dart';

class MockTestScreen extends StatefulWidget {
  const MockTestScreen({super.key});

  @override
  State<MockTestScreen> createState() => _MockTestScreenState();
}

class _MockTestScreenState extends State<MockTestScreen> {
  List<Question> _questions = [];
  Map<int, String> _answers = {};
  int _currentIndex = 0;
  bool _testStarted = false;
  bool _testCompleted = false;
  int _timeRemaining = 0;
  int _totalTime = 0;
  Timer? _timer;

  // Config
  int _questionCount = 10;
  final Set<String> _selectedCategories = {'aptitude', 'reasoning', 'verbal'};

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _startTest() async {
    final db = DatabaseHelper.instance;
    List<Map<String, dynamic>> rows = [];

    for (final cat in _selectedCategories) {
      final catRows = await db.queryWhere('questions', 'category = ?', [cat]);
      rows.addAll(catRows);
    }

    rows.shuffle();
    final selected = rows.take(_questionCount).toList();

    if (selected.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No questions available. Try different categories.')),
        );
      }
      return;
    }

    _totalTime = selected.length * 60; // 1 min per question
    setState(() {
      _questions = selected.map((r) => Question.fromMap(r)).toList();
      _answers = {};
      _currentIndex = 0;
      _testStarted = true;
      _testCompleted = false;
      _timeRemaining = _totalTime;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining <= 0) {
        _submitTest();
      } else {
        setState(() => _timeRemaining--);
      }
    });
  }

  void _selectAnswer(String option) {
    setState(() {
      _answers[_currentIndex] = option;
    });
  }

  void _submitTest() {
    _timer?.cancel();
    int correct = 0;
    int wrong = 0;
    int skipped = 0;

    for (int i = 0; i < _questions.length; i++) {
      if (!_answers.containsKey(i)) {
        skipped++;
      } else if (_answers[i] == _questions[i].correctOption) {
        correct++;
      } else {
        wrong++;
      }
    }

    final score = (correct / _questions.length) * 100;
    final timeTaken = _totalTime - _timeRemaining;

    // Save result
    DatabaseHelper.instance.insert('mock_tests', {
      'test_name': 'Mock Test',
      'total_questions': _questions.length,
      'correct_answers': correct,
      'wrong_answers': wrong,
      'skipped': skipped,
      'score': score,
      'time_taken_seconds': timeTaken,
      'categories': _selectedCategories.join(','),
    });

    setState(() => _testCompleted = true);

    Navigator.pushNamed(context, AppRouter.testResult, arguments: {
      'total': _questions.length,
      'correct': correct,
      'wrong': wrong,
      'skipped': skipped,
      'score': score,
      'timeTaken': timeTaken,
      'questions': _questions,
      'answers': _answers,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!_testStarted) return _buildConfigScreen(isDark);
    return _buildTestScreen(isDark);
  }

  Widget _buildConfigScreen(bool isDark) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mock Test')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text('📋', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  const Text('TNPSC Mock Test', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text('Configure and start your practice exam', style: TextStyle(color: Colors.white.withOpacity(0.7))),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text('Select Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _categoryChip('aptitude', '📊 Aptitude', AppColors.aptitudeColor, isDark),
                _categoryChip('reasoning', '🧩 Reasoning', AppColors.reasoningColor, isDark),
                _categoryChip('verbal', '📝 Verbal', AppColors.verbalColor, isDark),
              ],
            ),
            const SizedBox(height: 28),
            Text('Number of Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
            const SizedBox(height: 12),
            Row(
              children: [5, 10, 15, 20].map((n) {
                final selected = _questionCount == n;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text('$n', style: TextStyle(color: selected ? Colors.white : (isDark ? Colors.white70 : AppColors.textPrimary), fontWeight: FontWeight.w600)),
                    selected: selected,
                    selectedColor: AppColors.primaryBlue,
                    backgroundColor: isDark ? AppColors.darkCard : Colors.grey.shade100,
                    onSelected: (_) => setState(() => _questionCount = n),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Time: ${_questionCount} minutes (1 min per question)', style: TextStyle(color: isDark ? Colors.white70 : AppColors.textPrimary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            GradientButton(
              text: 'Start Mock Test',
              icon: Icons.play_arrow_rounded,
              gradient: AppColors.primaryGradient,
              onPressed: _startTest,
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryChip(String key, String label, Color color, bool isDark) {
    final selected = _selectedCategories.contains(key);
    return FilterChip(
      label: Text(label, style: TextStyle(color: selected ? Colors.white : (isDark ? Colors.white70 : color), fontWeight: FontWeight.w500)),
      selected: selected,
      selectedColor: color,
      backgroundColor: color.withOpacity(0.1),
      checkmarkColor: Colors.white,
      onSelected: (s) {
        setState(() {
          if (s) {
            _selectedCategories.add(key);
          } else if (_selectedCategories.length > 1) {
            _selectedCategories.remove(key);
          }
        });
      },
    );
  }

  Widget _buildTestScreen(bool isDark) {
    if (_questions.isEmpty) return const SizedBox();
    final q = _questions[_currentIndex];
    final minutes = _timeRemaining ~/ 60;
    final seconds = _timeRemaining % 60;
    final isLowTime = _timeRemaining < 60;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentIndex + 1}/${_questions.length}'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Quit Test?'),
                content: const Text('Your progress will be lost.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                  TextButton(
                    onPressed: () {
                      _timer?.cancel();
                      Navigator.pop(ctx);
                      setState(() => _testStarted = false);
                    },
                    child: const Text('Quit', style: TextStyle(color: AppColors.error)),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isLowTime ? AppColors.error.withOpacity(0.15) : AppColors.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.timer_rounded, size: 18, color: isLowTime ? AppColors.error : AppColors.success),
                const SizedBox(width: 6),
                Text(
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                  style: TextStyle(fontWeight: FontWeight.w700, color: isLowTime ? AppColors.error : AppColors.success),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions.length,
            backgroundColor: AppColors.mockTestColor.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation(AppColors.mockTestColor),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? AppColors.darkBorder : Colors.grey.shade200),
                    ),
                    child: Text(q.questionText, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1.5, color: isDark ? Colors.white : AppColors.textPrimary)),
                  ),
                  const SizedBox(height: 20),
                  // Options
                  ...['A', 'B', 'C', 'D'].map((opt) {
                    final isSelected = _answers[_currentIndex] == opt;
                    return GestureDetector(
                      onTap: () => _selectAnswer(opt),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.mockTestColor.withOpacity(0.12) : (isDark ? AppColors.darkCard : Colors.white),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isSelected ? AppColors.mockTestColor : (isDark ? AppColors.darkBorder : Colors.grey.shade200), width: isSelected ? 2 : 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32, height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? AppColors.mockTestColor : AppColors.mockTestColor.withOpacity(0.12),
                              ),
                              child: Center(child: Text(opt, style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.mockTestColor))),
                            ),
                            const SizedBox(width: 14),
                            Expanded(child: Text(q.getOption(opt), style: TextStyle(fontSize: 15, color: isDark ? Colors.white : AppColors.textPrimary))),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          // Navigation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  if (_currentIndex > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() => _currentIndex--),
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('Previous'),
                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                      ),
                    ),
                  if (_currentIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    child: _currentIndex == _questions.length - 1
                        ? GradientButton(
                            text: 'Submit Test',
                            icon: Icons.check_circle_rounded,
                            gradient: AppColors.successGradient,
                            onPressed: _submitTest,
                          )
                        : GradientButton(
                            text: 'Next',
                            icon: Icons.arrow_forward_rounded,
                            gradient: AppColors.primaryGradient,
                            onPressed: () => setState(() => _currentIndex++),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
