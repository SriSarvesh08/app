import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../core/utils/helpers.dart';
import '../../models/question.dart';
import '../../widgets/animated_card.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/progress_ring.dart';

class TestResultScreen extends StatelessWidget {
  final Map<String, dynamic> results;

  const TestResultScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = results['total'] as int;
    final correct = results['correct'] as int;
    final wrong = results['wrong'] as int;
    final skipped = results['skipped'] as int;
    final score = results['score'] as double;
    final timeTaken = results['timeTaken'] as int;

    String grade;
    Color gradeColor;
    String emoji;
    if (score >= 90) { grade = 'Excellent!'; gradeColor = AppColors.success; emoji = '🏆'; }
    else if (score >= 70) { grade = 'Great Job!'; gradeColor = AppColors.info; emoji = '🌟'; }
    else if (score >= 50) { grade = 'Good Effort!'; gradeColor = AppColors.warning; emoji = '👍'; }
    else { grade = 'Keep Practicing!'; gradeColor = AppColors.error; emoji = '💪'; }

    return Scaffold(
      appBar: AppBar(title: const Text('Test Results')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Score card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: AppColors.primaryBlue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Column(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 56)),
                  const SizedBox(height: 12),
                  Text(grade, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 20),
                  ProgressRing(
                    progress: score / 100,
                    size: 120,
                    strokeWidth: 10,
                    progressColor: Colors.white,
                    backgroundColor: Colors.white24,
                    center: Text('${score.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  Text('Time: ${Helpers.formatTime(timeTaken)}', style: TextStyle(color: Colors.white.withOpacity(0.7))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Stats row
            Row(
              children: [
                _statCard('✅', 'Correct', '$correct', AppColors.success, isDark),
                const SizedBox(width: 10),
                _statCard('❌', 'Wrong', '$wrong', AppColors.error, isDark),
                const SizedBox(width: 10),
                _statCard('⏭️', 'Skipped', '$skipped', AppColors.warning, isDark),
              ],
            ),
            const SizedBox(height: 24),
            // AI Feedback
            AnimatedCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.smart_toy_rounded, color: AppColors.primaryBlue),
                      const SizedBox(width: 8),
                      Text('AI Feedback', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: isDark ? Colors.white : AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getAIFeedback(score, correct, wrong, skipped),
                    style: TextStyle(height: 1.6, color: isDark ? Colors.white70 : AppColors.textPrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GradientButton(
              text: 'Take Another Test',
              icon: Icons.refresh_rounded,
              gradient: AppColors.primaryGradient,
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text('Back to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String emoji, String label, String value, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: color)),
            Text(label, style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  String _getAIFeedback(double score, int correct, int wrong, int skipped) {
    if (score >= 90) {
      return '🎉 Outstanding performance! You\'re well prepared. Focus on maintaining this level of accuracy. Consider attempting harder questions to push your limits further.';
    } else if (score >= 70) {
      return '👏 Good performance! You have a strong foundation. Review the $wrong incorrect answers carefully. Focus on understanding why you got them wrong rather than just memorizing answers.';
    } else if (score >= 50) {
      return '📚 Decent attempt! You\'re on the right track. Spend more time on concept clarity. Practice similar questions daily and use shortcut methods to improve speed.';
    } else {
      return '💪 Don\'t worry! Every expert was once a beginner. Focus on building strong basics first. Start with easy-level questions and gradually increase difficulty. Consistency is key!';
    }
  }
}
