import 'package:flutter/material.dart';
import '../data/stats_manager.dart';
import '../models/app_colors.dart';
import '../models/theme_notifier.dart';
import '../models/quiz_category.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = ThemeScope.colorsOf(context);
    return Scaffold(
      backgroundColor: c.scaffoldBg,
      body: SafeArea(
        child: Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(border: Border.all(color: c.border), borderRadius: BorderRadius.circular(8)),
                  child: Text('← Geri', style: TextStyle(color: c.textSecondary, fontSize: 12)))),
              const Spacer(),
              Text('İstatistikler', style: TextStyle(color: c.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
              const Spacer(), const SizedBox(width: 60),
            ]),
            const SizedBox(height: 24),
            _buildStreakCard(c),
            const SizedBox(height: 20),
            _buildSectionTitle('GENEL', c),
            const SizedBox(height: 12),
            _buildOverallStats(c),
            const SizedBox(height: 24),
            _buildSectionTitle('KATEGORİLER', c),
            const SizedBox(height: 12),
            ...QuizCatalog.groups.expand((g) => g.categories.map((cat) => Padding(padding: const EdgeInsets.only(bottom: 8), child: _buildCategoryRow(cat, c)))),
          ])),
        )),
      ),
    );
  }

  Widget _buildStreakCard(AppColors c) {
    final streak = StatsManager.currentStreak; final longest = StatsManager.longestStreak;
    final todayCount = StatsManager.todayQuizCount; final goal = StatsManager.dailyGoal; final reached = StatsManager.dailyGoalReached;
    return Container(width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: reached ? [c.accent, c.accentDark] : [c.cardBg, c.cardBg]),
        borderRadius: BorderRadius.circular(16),
        border: reached ? null : Border.all(color: c.border),
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _streakStat('🔥', '$streak', 'Streak', reached ? const Color(0xFF0F172A) : c.accent),
          Container(width: 1, height: 36, color: reached ? const Color(0xFF0F172A).withValues(alpha: 0.2) : c.border),
          _streakStat('🏅', '$longest', 'En Uzun', reached ? const Color(0xFF0F172A) : c.textPrimary),
          Container(width: 1, height: 36, color: reached ? const Color(0xFF0F172A).withValues(alpha: 0.2) : c.border),
          _streakStat(reached ? '✅' : '📋', '$todayCount/$goal', 'Bugün', reached ? const Color(0xFF0F172A) : c.textPrimary),
        ]),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(
          value: (todayCount / goal).clamp(0.0, 1.0), minHeight: 5,
          backgroundColor: reached ? const Color(0xFF0F172A).withValues(alpha: 0.2) : c.border,
          valueColor: AlwaysStoppedAnimation<Color>(reached ? const Color(0xFF0F172A) : c.accent),
        )),
        const SizedBox(height: 5),
        Text(reached ? 'Günlük hedef tamamlandı!' : 'Günlük hedefe ${goal - todayCount} quiz kaldı',
            style: TextStyle(fontSize: 11, color: reached ? const Color(0xFF0F172A).withValues(alpha: 0.7) : c.textMuted)),
      ]),
    );
  }

  Widget _streakStat(String emoji, String value, String label, Color color) {
    return Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 18)), const SizedBox(height: 3),
      Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
      Text(label, style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 10)),
    ]);
  }

  Widget _buildOverallStats(AppColors c) {
    return Container(width: double.infinity, padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(14)),
      child: Wrap(alignment: WrapAlignment.spaceAround, spacing: 16, runSpacing: 12, children: [
        _statBox('Quiz', '${StatsManager.totalQuizzesPlayed}', const Color(0xFF3B82F6)),
        _statBox('Doğru', '${StatsManager.totalCorrectAnswers}', const Color(0xFF22C55E)),
        _statBox('Yanlış', '${StatsManager.totalWrongAnswers}', const Color(0xFFEF4444)),
        _statBox('Puan', '${StatsManager.totalPoints}', c.accent),
        _statBox('Doğruluk', '%${StatsManager.accuracy.toStringAsFixed(0)}', const Color(0xFF8B5CF6)),
      ]),
    );
  }

  Widget _statBox(String label, String value, Color color) {
    return SizedBox(width: 80, child: Column(children: [
      Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w800)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
    ]));
  }

  Widget _buildCategoryRow(QuizCategory cat, AppColors c) {
    final played = StatsManager.getCategoryPlayed(cat.id); final accuracy = StatsManager.getCategoryAccuracy(cat.id); final best = StatsManager.getBestScore(cat.id);
    return Container(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        Text(cat.icon, style: const TextStyle(fontSize: 18)), const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(cat.name, style: TextStyle(color: c.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
          Text(played > 0 ? '$played oyun · %${accuracy.toStringAsFixed(0)} doğruluk' : 'Henüz oynanmadı',
              style: TextStyle(color: c.textMuted, fontSize: 10)),
        ])),
        if (best > 0) Text('⭐ $best', style: TextStyle(color: c.accent, fontSize: 13, fontWeight: FontWeight.w700)),
      ]),
    );
  }

  Widget _buildSectionTitle(String title, AppColors c) {
    return Row(children: [
      Container(width: 20, height: 1, color: c.border), const SizedBox(width: 8),
      Text(title, style: TextStyle(fontSize: 11, letterSpacing: 3, color: c.textMuted, fontWeight: FontWeight.w600)),
      const SizedBox(width: 8),
      Expanded(child: Container(height: 1, color: c.border)),
    ]);
  }
}