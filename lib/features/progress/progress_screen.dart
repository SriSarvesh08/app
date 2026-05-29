import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/theme/app_colors.dart';
import '../../core/database/database_helper.dart';
import '../../core/utils/helpers.dart';
import '../../models/mock_test.dart';
import '../../widgets/animated_card.dart';
import '../../widgets/progress_ring.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _totalAnswered = 0;
  int _totalCorrect = 0;
  int _totalTests = 0;
  List<MockTest> _recentTests = [];
  Map<String, int> _categoryBreakdown = {};
  Map<String, double> _categoryAccuracy = {}; // Maps category -> accuracy percent

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = DatabaseHelper.instance;
    final answers = await db.queryAll('user_answers');
    final tests = await db.queryAll('mock_tests');

    // Category breakdown and accuracy calculation
    Map<String, int> catCount = {};
    Map<String, int> catCorrect = {};
    Map<String, int> catTotal = {};

    for (final a in answers) {
      final qRows = await db.queryWhere('questions', 'id = ?', [a['question_id']]);
      if (qRows.isNotEmpty) {
        final cat = qRows.first['category'] as String;
        catCount[cat] = (catCount[cat] ?? 0) + 1;
        catTotal[cat] = (catTotal[cat] ?? 0) + 1;
        if (a['is_correct'] == 1) {
          catCorrect[cat] = (catCorrect[cat] ?? 0) + 1;
        }
      }
    }

    Map<String, double> catAcc = {};
    catTotal.forEach((cat, total) {
      final correct = catCorrect[cat] ?? 0;
      catAcc[cat] = (correct / total) * 100;
    });

    if (mounted) {
      setState(() {
        _totalAnswered = answers.length;
        _totalCorrect = answers.where((a) => a['is_correct'] == 1).length;
        _totalTests = tests.length;
        _recentTests = tests.map((t) => MockTest.fromMap(t)).toList().reversed.take(5).toList();
        _categoryBreakdown = catCount;
        _categoryAccuracy = catAcc;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accuracy = Helpers.calculateAccuracy(_totalCorrect, _totalAnswered);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.accentGold),
            tooltip: 'Export Progress to PDF',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('PDF Export feature is ready to be connected!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview cards
            Row(
              children: [
                _overviewCard('📊', 'Answered', '$_totalAnswered', AppColors.aptitudeColor, isDark),
                const SizedBox(width: 10),
                _overviewCard('🎯', 'Accuracy', '${accuracy.toStringAsFixed(0)}%', AppColors.success, isDark),
                const SizedBox(width: 10),
                _overviewCard('📋', 'Tests', '$_totalTests', AppColors.mockTestColor, isDark),
              ],
            ),
            const SizedBox(height: 24),

            // Accuracy ring
            AnimatedCard(
              delayMs: 100,
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  ProgressRing(
                    progress: accuracy / 100,
                    size: 100,
                    strokeWidth: 10,
                    progressColor: accuracy > 70 ? AppColors.success : (accuracy > 40 ? AppColors.warning : AppColors.error),
                    center: Text('${accuracy.toStringAsFixed(0)}%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.textPrimary)),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Overall Accuracy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        Text('$_totalCorrect correct out of $_totalAnswered', style: TextStyle(color: isDark ? Colors.white54 : AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text(Helpers.getXPLabel(_totalCorrect * 10), style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.accentGold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Interactive weakness analytics bar chart
            if (_categoryAccuracy.isNotEmpty) ...[
              Text('Interactive Weakness Analytics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
              const SizedBox(height: 12),
              AnimatedCard(
                delayMs: 150,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Accuracy Trend by Category (%)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 180,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 100,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final cats = _categoryAccuracy.keys.toList();
                                  if (value.toInt() >= 0 && value.toInt() < cats.length) {
                                    final label = cats[value.toInt()];
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        label[0].toUpperCase() + label.substring(1),
                                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                      ),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 20,
                                getTitlesWidget: (value, meta) {
                                  return Text('${value.toInt()}%', style: const TextStyle(fontSize: 10));
                                },
                              ),
                            ),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups: _categoryAccuracy.entries.map((e) {
                            final idx = _categoryAccuracy.keys.toList().indexOf(e.key);
                            final val = e.value;
                            return BarChartGroupData(
                              x: idx,
                              barRods: [
                                BarChartRodData(
                                  toY: val,
                                  color: val < 60 ? AppColors.error : AppColors.success,
                                  width: 16,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Custom Offline AI Focus Areas Recommendations
              Text('Focus Areas & Recommendations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
              const SizedBox(height: 12),
              ..._categoryAccuracy.entries.map((e) {
                final isWeak = e.value < 60;
                return AnimatedCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        isWeak ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
                        color: isWeak ? AppColors.error : AppColors.success,
                        size: 28,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${e.key[0].toUpperCase() + e.key.substring(1)} (${e.value.toStringAsFixed(0)}% Accuracy)',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isWeak
                                  ? 'Focus on formula memorization and practice 10 easy questions daily before upgrading difficulty.'
                                  : 'Excellent work! Challenge yourself with advanced full-syllabus mock tests.',
                              style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],

            // Category breakdown progress bars
            if (_categoryBreakdown.isNotEmpty) ...[
              Text('Solved Questions Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
              const SizedBox(height: 12),
              ..._categoryBreakdown.entries.map((e) {
                final catColors = {
                  'aptitude': AppColors.aptitudeColor,
                  'reasoning': AppColors.reasoningColor,
                  'verbal': AppColors.verbalColor,
                };
                final color = catColors[e.key] ?? AppColors.info;
                final total = _categoryBreakdown.values.fold(0, (a, b) => a + b);
                final pct = total > 0 ? (e.value / total) : 0.0;
                return AnimatedCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(width: 8, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.key[0].toUpperCase() + e.key.substring(1), style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(value: pct, backgroundColor: color.withOpacity(0.1), valueColor: AlwaysStoppedAnimation(color), minHeight: 6),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text('${e.value}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: color)),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],

            // Recent tests
            if (_recentTests.isNotEmpty) ...[
              Text('Recent Tests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
              const SizedBox(height: 12),
              ..._recentTests.asMap().entries.map((entry) {
                final t = entry.value;
                return AnimatedCard(
                  delayMs: 200 + (entry.key * 80),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: t.score >= 70 ? AppColors.success.withOpacity(0.12) : AppColors.warning.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(child: Text('${t.score.toStringAsFixed(0)}%', style: TextStyle(fontWeight: FontWeight.w700, color: t.score >= 70 ? AppColors.success : AppColors.warning))),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.testName, style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
                            Text('${t.correctAnswers}/${t.totalQuestions} correct • ${Helpers.formatTime(t.timeTakenSeconds)}', style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],

            if (_totalAnswered == 0)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      const Text('📈', style: TextStyle(fontSize: 64)),
                      const SizedBox(height: 16),
                      Text('No data yet!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      Text('Start practicing to see your progress', style: TextStyle(color: isDark ? Colors.white38 : AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _overviewCard(String emoji, String label, String value, Color color, bool isDark) {
    return Expanded(
      child: AnimatedCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
            Text(label, style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
