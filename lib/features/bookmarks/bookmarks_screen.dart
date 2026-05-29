import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/routes/app_router.dart';
import '../../core/database/database_helper.dart';
import '../../widgets/animated_card.dart';

/// Bookmarks screen — view & manage saved questions.
class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<Map<String, dynamic>> _bookmarks = [];
  String _filter = 'All';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final rows = await DatabaseHelper.instance.rawQuery('''
      SELECT b.id as bookmark_id, b.note, q.*
      FROM bookmarks b INNER JOIN questions q ON b.question_id = q.id
      ORDER BY b.created_at DESC
    ''');
    if (mounted) setState(() { _bookmarks = rows; _loading = false; });
  }

  List<Map<String, dynamic>> get _filtered {
    if (_filter == 'All') return _bookmarks;
    return _bookmarks.where((b) => b['category'] == _filter.toLowerCase()).toList();
  }

  Future<void> _remove(int id) async {
    await DatabaseHelper.instance.delete('bookmarks', 'id = ?', [id]);
    _load();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark removed'), duration: Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('${_bookmarks.length} saved',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accentGold)),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _bookmarks.isEmpty
              ? _emptyState(isDark)
              : Column(
                  children: [
                    // Filter chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: ['All', 'Aptitude', 'Reasoning', 'Verbal'].map((f) {
                          final active = _filter == f;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(f, style: TextStyle(fontSize: 12,
                                color: active ? Colors.white : (isDark ? Colors.white70 : AppColors.textPrimary))),
                              selected: active,
                              selectedColor: AppColors.primaryBlue,
                              backgroundColor: isDark ? AppColors.darkCard : Colors.grey.shade100,
                              onSelected: (_) => setState(() => _filter = f),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Expanded(
                      child: items.isEmpty
                          ? Center(child: Text('No bookmarks in this category',
                              style: TextStyle(color: isDark ? Colors.white38 : AppColors.textSecondary)))
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                              itemCount: items.length,
                              itemBuilder: (context, i) => _card(items[i], i, isDark),
                            ),
                    ),
                  ],
                ),
    );
  }

  Widget _card(Map<String, dynamic> bm, int index, bool isDark) {
    final catColors = {'aptitude': AppColors.aptitudeColor, 'reasoning': AppColors.reasoningColor, 'verbal': AppColors.verbalColor};
    final color = catColors[bm['category']] ?? AppColors.info;

    return Dismissible(
      key: Key('bm_${bm['bookmark_id']}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(color: AppColors.error.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.delete_rounded, color: AppColors.error),
      ),
      onDismissed: (_) => _remove(bm['bookmark_id'] as int),
      child: AnimatedCard(
        delayMs: index * 60,
        padding: const EdgeInsets.all(16),
        onTap: () => Navigator.pushNamed(context, AppRouter.topicDetail, arguments: {
          'category': bm['category'] as String, 'topic': bm['topic'] as String, 'color': color,
        }),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
              child: Text((bm['category'] as String).toUpperCase(),
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
            ),
            const SizedBox(width: 8),
            Text(bm['topic'] as String, style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : AppColors.textSecondary)),
            const Spacer(),
            GestureDetector(
              onTap: () => _remove(bm['bookmark_id'] as int),
              child: const Icon(Icons.bookmark_rounded, color: AppColors.accentGold, size: 22),
            ),
          ]),
          const SizedBox(height: 12),
          Text(bm['question_text'] as String,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, height: 1.5, color: isDark ? Colors.white : AppColors.textPrimary),
            maxLines: 3, overflow: TextOverflow.ellipsis),
        ]),
      ),
    );
  }

  Widget _emptyState(bool isDark) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: 100, height: 100,
        decoration: BoxDecoration(color: AppColors.accentGold.withOpacity(0.1), borderRadius: BorderRadius.circular(28)),
        child: const Center(child: Text('🔖', style: TextStyle(fontSize: 48))),
      ),
      const SizedBox(height: 20),
      Text('No Bookmarks Yet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.textPrimary)),
      const SizedBox(height: 8),
      Text('Bookmark questions during practice\nto review them later',
        style: TextStyle(color: isDark ? Colors.white38 : AppColors.textSecondary, height: 1.5), textAlign: TextAlign.center),
    ]));
  }
}
