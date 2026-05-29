import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/routes/app_router.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/animated_card.dart';

class VerbalScreen extends StatelessWidget {
  const VerbalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topics = AppConstants.verbalTopics;
    final icons = ['📖', '🔄', '✍️', '🔍', '📄', '✏️', '📝', '💬'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verbal Ability'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.verbalColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('${topics.length} Topics',
              style: TextStyle(fontSize: 12, color: AppColors.verbalColor, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return AnimatedCard(
            delayMs: index * 60,
            onTap: () {
              Navigator.pushNamed(context, AppRouter.topicDetail, arguments: {
                'category': AppConstants.categoryVerbal,
                'topic': topics[index],
                'color': AppColors.verbalColor,
              });
            },
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.verbalColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(child: Text(icons[index % icons.length], style: const TextStyle(fontSize: 22))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(topics[index],
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15,
                      color: isDark ? Colors.white : AppColors.textPrimary)),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16,
                  color: isDark ? Colors.white24 : Colors.grey.shade400),
              ],
            ),
          );
        },
      ),
    );
  }
}
