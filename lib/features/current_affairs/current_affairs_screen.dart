import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../core/database/database_helper.dart';
import '../../widgets/animated_card.dart';

class CurrentAffairsScreen extends StatefulWidget {
  const CurrentAffairsScreen({super.key});

  @override
  State<CurrentAffairsScreen> createState() => _CurrentAffairsScreenState();
}

class _CurrentAffairsScreenState extends State<CurrentAffairsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _categories = ['All', 'National', 'International', 'Tamil Nadu', 'Sports', 'Science'];
  List<Map<String, dynamic>> _affairs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadAffairs();
  }

  Future<void> _loadAffairs() async {
    final db = DatabaseHelper.instance;
    final rows = await db.queryAll('current_affairs');
    if (mounted) {
      setState(() {
        _affairs = rows;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _filterByCategory(String category) {
    if (category == 'All') return _affairs;
    return _affairs.where((a) => a['category'] == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Affairs'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.currentAffairsColor,
          labelColor: AppColors.currentAffairsColor,
          unselectedLabelColor: isDark ? Colors.white38 : AppColors.textSecondary,
          tabs: _categories.map((c) => Tab(text: c)).toList(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                final items = _filterByCategory(category);
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('📰', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text('No updates in this category',
                            style: TextStyle(color: isDark ? Colors.white38 : AppColors.textSecondary)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return AnimatedCard(
                      delayMs: index * 80,
                      padding: const EdgeInsets.all(16),
                      onTap: () => _showDetail(context, item, isDark),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.currentAffairsColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item['category']?.toString() ?? '',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.currentAffairsColor),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${item['month'] ?? ''} ${item['year'] ?? ''}',
                                style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : AppColors.textSecondary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item['title']?.toString() ?? '',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: isDark ? Colors.white : AppColors.textPrimary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item['content']?.toString() ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13, height: 1.4, color: isDark ? Colors.white54 : AppColors.textSecondary),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
    );
  }

  void _showDetail(BuildContext context, Map<String, dynamic> item, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        expand: false,
        builder: (ctx, scroll) => SingleChildScrollView(
          controller: scroll,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.currentAffairsColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item['category']?.toString() ?? '',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.currentAffairsColor),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item['title']?.toString() ?? '',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                '${item['date'] ?? ''} • ${item['month'] ?? ''} ${item['year'] ?? ''}',
                style: TextStyle(color: isDark ? Colors.white38 : AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Text(
                item['content']?.toString() ?? '',
                style: TextStyle(fontSize: 15, height: 1.7, color: isDark ? Colors.white70 : AppColors.textPrimary),
              ),
              const SizedBox(height: 24),
              // Quick quiz question about this affair
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.accentGold.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.quiz_rounded, color: AppColors.accentGold, size: 20),
                        const SizedBox(width: 8),
                        Text('Quick Recall', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Can you recall the key details from this article? Try to summarize it in your own words!',
                      style: TextStyle(fontSize: 13, color: isDark ? Colors.white54 : AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
