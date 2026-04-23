import 'package:flutter/material.dart';
import '../data/stats_manager.dart';
import '../data/auth_service.dart';
import '../data/sound_manager.dart';
import '../data/notification_manager.dart';
import '../models/app_colors.dart';
import '../models/theme_notifier.dart';
import '../models/quiz_category.dart';
import '../data/premium_manager.dart';
import 'login_screen.dart';
import 'premium_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = '';
  String _email = '';
  List<String> _badges = [];
  bool _notifEnabled = true;

  @override
  void initState() { super.initState(); _loadProfile(); }

  Future<void> _loadProfile() async {
    final auth = AuthService();
    final username = await auth.getUsername() ?? '';
    final email = auth.currentUser?.email ?? '';
    final badges = await auth.getBadges();
    final notif = await NotificationManager().isEnabled();
    if (mounted) setState(() { _username = username; _email = email; _badges = badges; _notifEnabled = notif; });
  }

  @override
  Widget build(BuildContext context) {
    final c = ThemeScope.colorsOf(context);
    final theme = ThemeScope.of(context);

    return Scaffold(backgroundColor: c.scaffoldBg, body: SafeArea(
      child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(children: [
          // Header
          Row(children: [
            GestureDetector(onTap: () => Navigator.pop(context),
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(border: Border.all(color: c.border), borderRadius: BorderRadius.circular(8)),
                child: Text('← Geri', style: TextStyle(color: c.textSecondary, fontSize: 12)))),
            const Spacer(),
            Text('Profil', style: TextStyle(color: c.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
            const Spacer(), const SizedBox(width: 60),
          ]),
          const SizedBox(height: 24),

          // Profil kartı
          Container(width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [c.accent.withValues(alpha: 0.15), c.accent.withValues(alpha: 0.05)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16), border: Border.all(color: c.accent.withValues(alpha: 0.2))),
            child: Column(children: [
              Container(width: 64, height: 64, decoration: BoxDecoration(color: c.accent, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(_username.isNotEmpty ? _username[0].toUpperCase() : '?',
                  style: TextStyle(color: c.onGradientDark, fontSize: 28, fontWeight: FontWeight.w800))),
              const SizedBox(height: 12),
              Text(_username, style: TextStyle(color: c.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(_email, style: TextStyle(color: c.textSecondary, fontSize: 12)),
              if (PremiumManager().isPremium) ...[const SizedBox(height: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF818CF8), Color(0xFF6366F1)]), borderRadius: BorderRadius.circular(12)),
                  child: const Text('💎 Premium', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)))],
            ])),

          if (!PremiumManager().isPremium) ...[const SizedBox(height: 12),
            GestureDetector(
              onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen())); if (mounted) setState(() {}); },
              child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF818CF8), Color(0xFF6366F1)]), borderRadius: BorderRadius.circular(12)),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('💎', style: TextStyle(fontSize: 18)), SizedBox(width: 8),
                  Text('Premium Al', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700))])))],
          const SizedBox(height: 20),

          // Rozetler
          _buildSectionTitle('ROZETLER', c),
          const SizedBox(height: 12),
          Container(width: double.infinity, padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(14)),
            child: _badges.isEmpty
              ? Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('Henüz rozet yok\nAy sonunda ilk 10\'a gir, rozet kazan!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: c.textMuted, fontSize: 12))))
              : Wrap(spacing: 8, runSpacing: 8, children: _badges.map((b) {
                String emoji = '🏅';
                if (b.contains('1.liği')) emoji = '🥇';
                else if (b.contains('2.liği')) emoji = '🥈';
                else if (b.contains('3.lüğü')) emoji = '🥉';
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      b.contains('1.liği') ? const Color(0xFFFFD700).withValues(alpha: 0.2) :
                      b.contains('2.liği') ? const Color(0xFFC0C0C0).withValues(alpha: 0.2) :
                      b.contains('3.lüğü') ? const Color(0xFFCD7F32).withValues(alpha: 0.2) :
                      c.accent.withValues(alpha: 0.15),
                      c.cardBg]),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: c.border)),
                  child: Text('$emoji $b', style: TextStyle(color: c.textPrimary, fontSize: 11, fontWeight: FontWeight.w600)));
              }).toList())),
          const SizedBox(height: 20),

          // Ayarlar
          _buildSectionTitle('AYARLAR', c),
          const SizedBox(height: 12),
          Container(decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(14)),
            child: Column(children: [
              _buildSettingRow(icon: theme.isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, label: 'Tema',
                trailing: Text(theme.isDark ? 'Koyu' : 'Açık', style: TextStyle(color: c.textSecondary, fontSize: 13)),
                onTap: () { theme.toggle(); setState(() {}); }, c: c),
              Divider(height: 1, color: c.border, indent: 48),
              _buildSettingRow(icon: SoundManager().isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded, label: 'Ses Efektleri',
                trailing: Text(SoundManager().isMuted ? 'Kapalı' : 'Açık', style: TextStyle(color: c.textSecondary, fontSize: 13)),
                onTap: () { SoundManager().toggleMute(); setState(() {}); }, c: c),
              Divider(height: 1, color: c.border, indent: 48),
              _buildSettingRow(icon: _notifEnabled ? Icons.notifications_active_rounded : Icons.notifications_off_rounded, label: 'Bildirimler',
                trailing: Text(_notifEnabled ? 'Açık' : 'Kapalı', style: TextStyle(color: c.textSecondary, fontSize: 13)),
                onTap: () async { await NotificationManager().toggle(); _loadProfile(); }, c: c),
            ])),
          const SizedBox(height: 20),

          // Streak
          _buildSectionTitle('GÜNLÜK HEDEF', c),
          const SizedBox(height: 12),
          _buildStreakCard(c),
          const SizedBox(height: 20),

          // İstatistikler
          _buildSectionTitle('İSTATİSTİKLER', c),
          const SizedBox(height: 12),
          _buildOverallStats(c),
          const SizedBox(height: 20),

          // Kategoriler
          _buildSectionTitle('KATEGORİLER', c),
          const SizedBox(height: 12),
          ...QuizCatalog.groups.expand((g) => g.categories.map(
            (cat) => Padding(padding: const EdgeInsets.only(bottom: 8), child: _buildCategoryRow(cat, c)))),
          const SizedBox(height: 20),

          // Çıkış
          GestureDetector(
            onTap: () async {
              await StatsManager.clearOnLogout();
              await PremiumManager().clearLocal();
              await AuthService().signOut();
              if (!mounted) return;
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
            },
            child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: c.wrong.withValues(alpha: 0.3))),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.logout_rounded, color: c.wrong, size: 18), const SizedBox(width: 8),
                Text('Çıkış Yap', style: TextStyle(color: c.wrong, fontSize: 13, fontWeight: FontWeight.w600))]))),
          const SizedBox(height: 32),
        ])),
      )),
    ));
  }

  Widget _buildSettingRow({required IconData icon, required String label, required Widget trailing, required VoidCallback onTap, required AppColors c}) {
    return GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque,
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Icon(icon, color: c.textSecondary, size: 20), const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(color: c.textPrimary, fontSize: 14, fontWeight: FontWeight.w500))),
          trailing, const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded, color: c.textMuted, size: 18)])));
  }

  Widget _buildStreakCard(AppColors c) {
    final streak = StatsManager.currentStreak;
    final longest = StatsManager.longestStreak;
    final todayCount = StatsManager.todayQuizCount;
    final goal = StatsManager.dailyGoal;
    final reached = StatsManager.dailyGoalReached;
    return Container(width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: reached ? [c.accent, c.accentDark] : [c.cardBg, c.cardBg]),
        borderRadius: BorderRadius.circular(16), border: reached ? null : Border.all(color: c.border)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _streakStat('🔥', '$streak', 'Streak', reached ? const Color(0xFF0F172A) : c.accent),
          Container(width: 1, height: 36, color: reached ? const Color(0xFF0F172A).withValues(alpha: 0.2) : c.border),
          _streakStat('🏅', '$longest', 'En Uzun', reached ? const Color(0xFF0F172A) : c.textPrimary),
          Container(width: 1, height: 36, color: reached ? const Color(0xFF0F172A).withValues(alpha: 0.2) : c.border),
          _streakStat(reached ? '✅' : '📋', '$todayCount/$goal', 'Bugün', reached ? const Color(0xFF0F172A) : c.textPrimary),
        ]),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: (todayCount / goal).clamp(0.0, 1.0), minHeight: 5,
            backgroundColor: reached ? const Color(0xFF0F172A).withValues(alpha: 0.2) : c.border,
            valueColor: AlwaysStoppedAnimation<Color>(reached ? const Color(0xFF0F172A) : c.accent))),
        const SizedBox(height: 5),
        Text(reached ? 'Günlük hedef tamamlandı!' : 'Günlük hedefe ${goal - todayCount} quiz kaldı',
          style: TextStyle(fontSize: 11, color: reached ? const Color(0xFF0F172A).withValues(alpha: 0.7) : c.textMuted)),
      ]));
  }

  Widget _streakStat(String emoji, String value, String label, Color color) {
    return Column(children: [
      Text(emoji, style: const TextStyle(fontSize: 18)), const SizedBox(height: 3),
      Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
      Text(label, style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 10))]);
  }

  Widget _buildOverallStats(AppColors c) {
    return Container(width: double.infinity, padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(14)),
      child: Wrap(alignment: WrapAlignment.spaceAround, spacing: 16, runSpacing: 12, children: [
        _statBox('Quiz', '${StatsManager.totalQuizzesPlayed}', const Color(0xFF3B82F6)),
        _statBox('Doğru', '${StatsManager.totalCorrectAnswers}', const Color(0xFF22C55E)),
        _statBox('Yanlış', '${StatsManager.totalWrongAnswers}', const Color(0xFFEF4444)),
        _statBox('Puan', '${StatsManager.totalPoints}', c.accent),
        _statBox('Elmas', '${StatsManager.totalDiamonds}', const Color(0xFF818CF8)),
        _statBox('Prestij', '${StatsManager.totalPrestige}', const Color(0xFFEAB308)),
        _statBox('Doğruluk', '%${StatsManager.accuracy.toStringAsFixed(0)}', const Color(0xFF8B5CF6)),
      ]));
  }

  Widget _statBox(String label, String value, Color color) {
    return SizedBox(width: 80, child: Column(children: [
      Text(value, style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w800)),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10))]));
  }

  Widget _buildCategoryRow(QuizCategory cat, AppColors c) {
    final played = StatsManager.getCategoryPlayed(cat.id);
    final accuracy = StatsManager.getCategoryAccuracy(cat.id);
    final best = StatsManager.getBestScore(cat.id);
    return Container(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        Text(cat.icon, style: const TextStyle(fontSize: 18)), const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(cat.name, style: TextStyle(color: c.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
          Text(played > 0 ? '$played oyun · %${accuracy.toStringAsFixed(0)} doğruluk' : 'Henüz oynanmadı',
            style: TextStyle(color: c.textMuted, fontSize: 10))])),
        if (best > 0) Text('⭐ $best', style: TextStyle(color: c.accent, fontSize: 13, fontWeight: FontWeight.w700)),
      ]));
  }

  Widget _buildSectionTitle(String title, AppColors c) {
    return Row(children: [
      Container(width: 20, height: 1, color: c.border), const SizedBox(width: 8),
      Text(title, style: TextStyle(fontSize: 11, letterSpacing: 3, color: c.textMuted, fontWeight: FontWeight.w600)),
      const SizedBox(width: 8), Expanded(child: Container(height: 1, color: c.border))]);
  }
}