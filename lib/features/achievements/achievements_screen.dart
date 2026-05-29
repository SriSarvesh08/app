import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../core/database/database_helper.dart';
import '../../widgets/animated_card.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  List<Map<String, dynamic>> _achievements = [];
  bool _loading = true;

  final List<Map<String, dynamic>> _allBadges = [
    {'title': 'First Steps', 'description': 'Complete your first mock test', 'icon': '🎯', 'condition': 'test_count >= 1'},
    {'title': 'Consistent Scholar', 'description': 'Maintain a 3-day study streak', 'icon': '🔥', 'condition': 'streak >= 3'},
    {'title': 'Quiz Master', 'description': 'Score 90%+ in a Mock Test', 'icon': '👑', 'condition': 'score >= 90'},
    {'title': 'Knowledge Seeker', 'description': 'Answer 100 questions', 'icon': '📚', 'condition': 'answered >= 100'},
    {'title': 'Perfect Accuracy', 'description': 'Answer 10 questions correctly in a row', 'icon': '⭐', 'condition': 'combo >= 10'},
    {'title': 'Early Bird', 'description': 'Study before 6 AM', 'icon': '🌅', 'condition': 'time <= 6'},
  ];

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final db = DatabaseHelper.instance;
    final rows = await db.queryAll('achievements');
    if (mounted) {
      setState(() {
        _achievements = rows;
        _loading = false;
      });
    }
  }

  bool _isUnlocked(String title) {
    return _achievements.any((a) => a['title'] == title);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements & Badges'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('${_achievements.length} Unlocked',
              style: const TextStyle(fontSize: 12, color: AppColors.accentGold, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: _allBadges.length,
              itemBuilder: (context, index) {
                final badge = _allBadges[index];
                final unlocked = _isUnlocked(badge['title']);

                return AnimatedCard(
                  delayMs: index * 100,
                  padding: const EdgeInsets.all(16),
                  color: unlocked
                      ? (isDark ? AppColors.darkCard : Colors.white)
                      : (isDark ? AppColors.darkSurface : Colors.grey.shade100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64, height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: unlocked
                              ? AppColors.accentGold.withOpacity(0.15)
                              : Colors.grey.withOpacity(0.2),
                          border: unlocked
                              ? Border.all(color: AppColors.accentGold.withOpacity(0.5), width: 2)
                              : null,
                        ),
                        child: Center(
                          child: Text(badge['icon'],
                              style: TextStyle(fontSize: 32, color: unlocked ? null : Colors.grey)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        badge['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: unlocked
                              ? (isDark ? Colors.white : AppColors.textPrimary)
                              : (isDark ? Colors.white38 : AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        badge['description'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.3,
                          color: unlocked
                              ? (isDark ? Colors.white70 : AppColors.textSecondary)
                              : (isDark ? Colors.white24 : Colors.grey),
                        ),
                      ),
                      if (!unlocked) ...[
                        const SizedBox(height: 12),
                        const Icon(Icons.lock_rounded, size: 16, color: Colors.grey),
                      ]
                    ],
                  ),
                );
              },
            ),
    );
  }
}
