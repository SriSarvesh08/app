import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme/app_colors.dart';
import '../../config/routes/app_router.dart';
import '../../core/utils/helpers.dart';
import '../../core/database/database_helper.dart';
import '../../core/providers/providers.dart';
import '../../core/services/streak_service.dart';
import '../../core/services/update_service.dart';
import '../../widgets/animated_card.dart';
import '../../widgets/glassmorphic_container.dart';
import '../../core/constants/translations.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _totalQuestions = 0;
  int _totalAnswered = 0;
  int _totalCorrect = 0;
  int _streak = 0;
  int _xp = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
    // Check for update after the first frame so the context is fully ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), _checkForUpdate);
    });
  }

  Future<void> _checkForUpdate() async {
    if (!mounted) return;
    final update = await UpdateService.instance.checkForUpdate();
    if (update != null && mounted) {
      _showUpdateDialog(update);
    }
  }

  void _showUpdateDialog(UpdateInfo update) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D1117), Color(0xFF1A237E)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🚀', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              const Text(
                'New Update Available!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'v${update.currentVersion} → v${update.latestVersion}',
                style: const TextStyle(color: AppColors.accentGold, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              if (update.releaseNotes.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    update.releaseNotes,
                    style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Later', style: TextStyle(color: Colors.white54)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGold,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        final uri = Uri.parse(update.downloadUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      },
                      child: const Text('Update Now', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadStats() async {
    final db = DatabaseHelper.instance;
    final qCount = await db.getCount('questions');
    final answers = await db.queryAll('user_answers');
    final correct = answers.where((a) => a['is_correct'] == 1).length;
    final streak = await StreakService.instance.getStreak();
    final xp = await StreakService.instance.getTotalXP();
    if (mounted) {
      setState(() {
        _totalQuestions = qCount;
        _totalAnswered = answers.length;
        _totalCorrect = correct;
        _streak = streak;
        _xp = xp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = ref.watch(languageProvider);
    final greeting = Helpers.getGreeting();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0D1117), const Color(0xFF161B22)]
                : [AppColors.primaryBlue, AppColors.lightBg],
            stops: const [0.0, 0.35],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(greeting, isDark, lang),
                const SizedBox(height: 20),
                _buildStatsRow(isDark, lang),
                const SizedBox(height: 20),
                _buildMotivation(isDark, lang),
                const SizedBox(height: 20),
                _buildCategoryGrid(isDark, lang),
                const SizedBox(height: 20),
                _buildQuickActions(isDark, lang),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(isDark, lang),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRouter.chat),
        child: const Icon(Icons.smart_toy_rounded, size: 28),
      ),
    );
  }

  Widget _buildHeader(String greeting, bool isDark, String lang) {
    final translatedGreeting = lang == 'ta'
        ? (greeting.contains('Morning')
            ? 'காலை வணக்கம்'
            : greeting.contains('Afternoon')
                ? 'மதிய வணக்கம்'
                : 'மாலை வணக்கம்')
        : greeting;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$translatedGreeting! 👋',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                      child: Row(children: [
                        const Text('🔥', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text('$_streak ${lang == 'en' ? 'Days' : 'நாட்கள்'}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
                      ]),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.accentGold.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                      child: Row(children: [
                        const Text('⭐', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text('$_xp XP', style: const TextStyle(color: AppColors.accentGold, fontWeight: FontWeight.w700, fontSize: 12)),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => ref.read(languageProvider.notifier).toggleLanguage(),
            child: Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.15),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Center(
                child: Text(
                  lang == 'en' ? 'தமிழ்' : 'EN',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRouter.settings),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.15),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: const Icon(Icons.settings_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool isDark, String lang) {
    final accuracy = Helpers.calculateAccuracy(_totalCorrect, _totalAnswered);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _statCard('📊', lang == 'en' ? 'Questions' : 'கேள்விகள்', '$_totalQuestions', AppColors.aptitudeColor, 0, isDark),
          const SizedBox(width: 12),
          _statCard('✅', lang == 'en' ? 'Answered' : 'பதிலளித்தவை', '$_totalAnswered', AppColors.success, 100, isDark),
          const SizedBox(width: 12),
          _statCard('🎯', lang == 'en' ? 'Accuracy' : 'துல்லியம்', '${accuracy.toStringAsFixed(0)}%', AppColors.accentGold, 200, isDark),
        ],
      ),
    );
  }

  Widget _statCard(String emoji, String label, String value, Color color, int delay, bool isDark) {
    return Expanded(
      child: AnimatedCard(
        delayMs: delay,
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white54 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivation(bool isDark, String lang) {
    final motiv = Helpers.getRandomMotivation();
    final translatedMotiv = lang == 'ta' 
        ? 'தொடர்ச்சியான முயற்சியே வெற்றிக்கு ஒரே வழி! இன்று உங்கள் திறமையை வளர்த்துக் கொள்ளுங்கள்.'
        : motiv;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedCard(
        delayMs: 300,
        gradient: AppColors.primaryGradient,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Text('💡', style: TextStyle(fontSize: 32)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                translatedMotiv,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(bool isDark, String lang) {
    final categories = [
      {'icon': '📊', 'title': lang == 'en' ? 'Aptitude' : 'திறனறிவு', 'subtitle': lang == 'en' ? 'Numbers & Logic' : 'மனக்கணக்குகள்', 'color': AppColors.aptitudeColor, 'route': AppRouter.aptitude},
      {'icon': '🧩', 'title': lang == 'en' ? 'Reasoning' : 'தருக்க அறிவு', 'subtitle': lang == 'en' ? 'Puzzles & Patterns' : 'புதிர்கள்', 'color': AppColors.reasoningColor, 'route': AppRouter.reasoning},
      {'icon': '📝', 'title': lang == 'en' ? 'Verbal' : 'மொழிப்பாடம்', 'subtitle': lang == 'en' ? 'English & Grammar' : 'இலக்கணம்', 'color': AppColors.verbalColor, 'route': AppRouter.verbal},
      {'icon': '📰', 'title': lang == 'en' ? 'Current Affairs' : 'நடப்பு நிகழ்வுகள்', 'subtitle': lang == 'en' ? 'Latest Updates' : 'புதிய தகவல்கள்', 'color': AppColors.currentAffairsColor, 'route': AppRouter.currentAffairs},
      {'icon': '📋', 'title': lang == 'en' ? 'Mock Tests' : 'மாதிரி தேர்வுகள்', 'subtitle': lang == 'en' ? 'Practice Exams' : 'பயிற்சி தேர்வுகள்', 'color': AppColors.mockTestColor, 'route': AppRouter.mockTest},
      {'icon': '🏛️', 'title': lang == 'en' ? 'General Studies' : 'பொது அறிவு', 'subtitle': lang == 'en' ? 'History & Polity' : 'வரலாறு & ஆட்சி', 'color': AppColors.generalStudiesColor, 'route': AppRouter.generalStudies},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang == 'en' ? 'Study Modules' : 'பாடப்பிரிவுகள்',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return AnimatedCard(
                delayMs: 400 + (index * 80),
                onTap: () => Navigator.pushNamed(context, cat['route'] as String),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (cat['color'] as Color).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(cat['icon'] as String, style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat['title'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          cat['subtitle'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white38 : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isDark, String lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang == 'en' ? 'Quick Actions' : 'விரைவுச் செயல்கள்',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          AnimatedCard(
            delayMs: 700,
            onTap: () => Navigator.pushNamed(context, AppRouter.chat),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.smart_toy_rounded, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang == 'en' ? 'Ask AI Assistant' : 'AI உதவியாளரிடம் கேளுங்கள்',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        lang == 'en' ? 'Get instant answers to your doubts' : 'உங்கள் சந்தேகங்களுக்கு உடனுக்குடன் பதில்களைப் பெறுங்கள்',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: isDark ? Colors.white38 : AppColors.textSecondary),
              ],
            ),
          ),
          AnimatedCard(
            delayMs: 800,
            onTap: () => Navigator.pushNamed(context, AppRouter.pdfAssistant),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang == 'en' ? 'PDF Notes Assistant' : 'PDF குறிப்பு உதவியாளர்',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        lang == 'en' ? 'Upload and study from your PDFs' : 'உங்களது PDF-களில் இருந்து படியுங்கள்',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: isDark ? Colors.white38 : AppColors.textSecondary),
              ],
            ),
          ),
          AnimatedCard(
            delayMs: 900,
            onTap: () => Navigator.pushNamed(context, AppRouter.bookmarks),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.bookmark_rounded, color: AppColors.accentGold),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang == 'en' ? 'Saved Bookmarks' : 'சேமித்த வினாக்கள்',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        lang == 'en' ? 'Review your saved questions' : 'சேமித்த கேள்விகளை மீண்டும் பார்க்கவும்',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: isDark ? Colors.white38 : AppColors.textSecondary),
              ],
            ),
          ),
          AnimatedCard(
            delayMs: 1000,
            onTap: () => Navigator.pushNamed(context, AppRouter.achievements),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.emoji_events_rounded, color: AppColors.success),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang == 'en' ? 'Achievements & Badges' : 'சாதனைகள் மற்றும் பதக்கங்கள்',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        lang == 'en' ? 'View your unlocked rewards' : 'நீங்கள் வென்ற பரிசுகளைப் பார்க்கவும்',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: isDark ? Colors.white38 : AppColors.textSecondary),
              ],
            ),
          ),
          AnimatedCard(
            delayMs: 1100,
            onTap: () => _showPYQDialog(context, lang),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.history_edu_rounded, color: AppColors.primaryBlue),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang == 'en' ? 'Previous Year Questions (PYQ)' : 'முந்தைய ஆண்டு வினாக்கள் (PYQ)',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        lang == 'en' ? 'Practice 2018-2025 TNPSC Exams' : '2018-2025 டி.என்.பி.எஸ்.சி தேர்வுகளைப் பயிற்சி செய்யுங்கள்',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: isDark ? Colors.white38 : AppColors.textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPYQDialog(BuildContext context, String lang) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang == 'en' ? 'Select Past TNPSC Exam' : 'டி.என்.பி.எஸ்.சி தேர்வைத் தேர்ந்தெடுக்கவும்',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Text('🎓', style: TextStyle(fontSize: 22)),
                title: Text(lang == 'en' ? 'TNPSC Group IV - 2024 Exam' : 'டி.என்.பி.எஸ்.சி தொகுதி IV - 2024'),
                trailing: const Icon(Icons.play_arrow_rounded, color: AppColors.success),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRouter.mockTest);
                },
              ),
              ListTile(
                leading: const Text('📋', style: TextStyle(fontSize: 22)),
                title: Text(lang == 'en' ? 'TNPSC Group II - 2023 Exam' : 'டி.என்.பி.எஸ்.சி தொகுதி II - 2023'),
                trailing: const Icon(Icons.play_arrow_rounded, color: AppColors.success),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRouter.mockTest);
                },
              ),
              ListTile(
                leading: const Text('🏛️', style: TextStyle(fontSize: 22)),
                title: Text(lang == 'en' ? 'TNPSC Group I - 2022 Exam' : 'டி.என்.பி.எஸ்.சி தொகுதி I - 2022'),
                trailing: const Icon(Icons.play_arrow_rounded, color: AppColors.success),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRouter.mockTest);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNav(bool isDark, String lang) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) {
          ref.read(bottomNavIndexProvider.notifier).state = i;
          switch (i) {
            case 0: break; // Home - already here
            case 1: Navigator.pushNamed(context, AppRouter.aptitude); break;
            case 2: Navigator.pushNamed(context, AppRouter.chat); break;
            case 3: Navigator.pushNamed(context, AppRouter.mockTest); break;
            case 4: Navigator.pushNamed(context, AppRouter.progress); break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home_rounded), label: lang == 'en' ? 'Home' : 'முகப்பு'),
          BottomNavigationBarItem(icon: const Icon(Icons.school_rounded), label: lang == 'en' ? 'Learn' : 'கற்க'),
          BottomNavigationBarItem(icon: const Icon(Icons.smart_toy_rounded), label: lang == 'en' ? 'AI Chat' : 'AI அரட்டை'),
          BottomNavigationBarItem(icon: const Icon(Icons.quiz_rounded), label: lang == 'en' ? 'Tests' : 'தேர்வுகள்'),
          BottomNavigationBarItem(icon: const Icon(Icons.bar_chart_rounded), label: lang == 'en' ? 'Progress' : 'முன்னேற்றம்'),
        ],
      ),
    );
  }
}
