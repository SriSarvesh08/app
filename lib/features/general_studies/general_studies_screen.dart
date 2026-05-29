import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/routes/app_router.dart';
import '../../widgets/animated_card.dart';

class GeneralStudiesScreen extends StatelessWidget {
  const GeneralStudiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final topics = [
      'History of India',
      'Tamil Nadu History & Culture',
      'Indian Polity & Constitution',
      'Geography of India',
      'Indian Economy',
      'General Science (Physics)',
      'General Science (Chemistry)',
      'General Science (Biology)',
    ];
    
    final icons = ['🏛️', '🎭', '⚖️', '🌍', '📈', '⚛️', '🧪', '🧬'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('General Studies'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.generalStudiesColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('${topics.length} Topics',
              style: const TextStyle(fontSize: 12, color: AppColors.generalStudiesColor, fontWeight: FontWeight.w600)),
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
                'category': 'general_studies',
                'topic': topics[index],
                'color': AppColors.generalStudiesColor,
              });
            },
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.generalStudiesColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(child: Text(icons[index % icons.length], style: const TextStyle(fontSize: 22))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(topics[index],
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15,
                          color: isDark ? Colors.white : AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _difficultyDot(AppColors.success),
                          _difficultyDot(AppColors.warning),
                          _difficultyDot(AppColors.error),
                          const SizedBox(width: 8),
                          Text('3 levels', style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
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

  Widget _difficultyDot(Color color) {
    return Container(
      width: 8, height: 8,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
