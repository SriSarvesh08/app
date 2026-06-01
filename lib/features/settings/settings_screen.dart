import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme/app_colors.dart';
import '../../core/providers/providers.dart';
import '../../widgets/animated_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final darkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile card
            AnimatedCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(child: Text('👤', style: TextStyle(fontSize: 32))),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Student', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: darkMode ? Colors.white : AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text('TNPSC Aspirant', style: TextStyle(color: darkMode ? Colors.white38 : AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Icon(Icons.edit_rounded, color: darkMode ? Colors.white38 : AppColors.textSecondary),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _sectionTitle('Appearance', darkMode),
            AnimatedCard(
              delayMs: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SwitchListTile(
                title: Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w500, color: darkMode ? Colors.white : AppColors.textPrimary)),
                subtitle: Text('Toggle dark/light theme', style: TextStyle(fontSize: 12, color: darkMode ? Colors.white38 : AppColors.textSecondary)),
                secondary: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: AppColors.accentGold),
                value: isDark,
                activeColor: AppColors.primaryBlue,
                onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
              ),
            ),
            const SizedBox(height: 24),

            _sectionTitle('AI Settings', darkMode),
            _settingTile(Icons.memory_rounded, 'AI Model', 'Gemma 2B (Offline)', darkMode, null),
            _settingTile(Icons.speed_rounded, 'Response Speed', 'Balanced', darkMode, null),
            _settingTile(Icons.language_rounded, 'Language', 'English', darkMode, null),
            const SizedBox(height: 24),

            _sectionTitle('Data', darkMode),
            _settingTile(Icons.download_rounded, 'Export Progress', 'Save your data', darkMode, () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Export feature coming soon!')));
            }),
            _settingTile(Icons.delete_outline_rounded, 'Clear All Data', 'Reset app data', darkMode, () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Clear All Data?'),
                  content: const Text('This will delete all progress, chat history, and test results. This cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data cleared!')));
                      },
                      child: const Text('Clear', style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            _sectionTitle('About', darkMode),
            _settingTile(Icons.info_outline_rounded, 'Version', '1.0.0', darkMode, null),
            _settingTile(Icons.privacy_tip_outlined, 'Privacy Policy', '', darkMode, null),
            _settingTile(Icons.description_outlined, 'Terms of Service', '', darkMode, null),
            const SizedBox(height: 24),

            // Credits
            Center(
              child: Column(
                children: [
                  const Text('🎓', style: TextStyle(fontSize: 32)),
                  const SizedBox(height: 8),
                  Text('examGenious', style: TextStyle(fontWeight: FontWeight.w600, color: darkMode ? Colors.white : AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text('Made with ❤️ for TNPSC aspirants', style: TextStyle(fontSize: 12, color: darkMode ? Colors.white38 : AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
    );
  }

  Widget _settingTile(IconData icon, String title, String subtitle, bool isDark, VoidCallback? onTap) {
    return AnimatedCard(
      padding: const EdgeInsets.all(16),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryBlue, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w500, color: isDark ? Colors.white : AppColors.textPrimary)),
                if (subtitle.isNotEmpty) Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : AppColors.textSecondary)),
              ],
            ),
          ),
          if (onTap != null) Icon(Icons.arrow_forward_ios_rounded, size: 14, color: isDark ? Colors.white24 : Colors.grey.shade400),
        ],
      ),
    );
  }
}
