import 'package:flutter/material.dart';
import '../data/stats_manager.dart';
import '../data/auth_service.dart';
import '../data/life_manager.dart';
import '../data/ad_manager.dart';
import '../data/premium_manager.dart';
import '../models/app_colors.dart';
import '../models/theme_notifier.dart';
import '../models/quiz_category.dart';
import '../widgets/banner_ad_widget.dart';
import 'quiz_screen.dart';
import 'practice_screen.dart';
import 'leaderboard_screen.dart';
import 'profile_screen.dart';
import 'premium_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _username = '';

  @override
  void initState() { super.initState(); _loadUsername(); }

  Future<void> _loadUsername() async {
    final name = await AuthService().getUsername() ?? '';
    if (mounted) setState(() => _username = name);
  }

  @override
  Widget build(BuildContext context) {
    final c = ThemeScope.colorsOf(context);
    return Scaffold(
      backgroundColor: c.scaffoldBg,
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final hPad = isLandscape ? constraints.maxWidth * 0.15 : 24.0;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 16),
          child: Column(children: [
            SizedBox(height: isLandscape ? 8 : 16),
            Row(children: [
              if (!PremiumManager().isPremium) _buildLivesIndicator(c)
              else Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: c.wrong.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text('❤️ ∞', style: TextStyle(color: c.wrong, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const Spacer(),
              Text('KPSS HARİTASI', style: TextStyle(fontSize: 13, letterSpacing: 6, color: c.accent, fontWeight: FontWeight.w600)),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  if (mounted) setState(() {});
                  _loadUsername();
                },
                child: Container(width: 36, height: 36,
                  decoration: BoxDecoration(color: c.accent, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Text(_username.isNotEmpty ? _username[0].toUpperCase() : '?',
                    style: TextStyle(color: c.onGradientDark, fontSize: 16, fontWeight: FontWeight.w800)),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            Text('Coğrafya Quiz', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: c.textPrimary, letterSpacing: -1)),
            const SizedBox(height: 16),
            _buildDailyCard(c),
            const SizedBox(height: 8),
            _buildPracticeButton(c),
            ...QuizCatalog.groups.map((group) => _buildGroup(context, group, c)),
            const SizedBox(height: 20),
            _buildLeaderboardButton(c),
            if (!PremiumManager().isPremium) ...[const SizedBox(height: 10), _buildPremiumButton(c)],
            const SizedBox(height: 16),
            const BannerAdWidget(),
            const SizedBox(height: 32),
          ]),
        );
      })),
    );
  }

  Widget _buildPracticeButton(AppColors c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 8),
      child: GestureDetector(
        onTap: () { Navigator.push(context, MaterialPageRoute(builder: (_) => const PracticeScreen())).then((_) { if (mounted) setState(() {}); }); },
        child: Container(
          width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [c.accent.withValues(alpha: 0.15), c.accent.withValues(alpha: 0.05)], begin: Alignment.centerLeft, end: Alignment.centerRight),
            borderRadius: BorderRadius.circular(14), border: Border.all(color: c.accent.withValues(alpha: 0.3)),
          ),
          child: Row(children: [
            const Text('🧠', style: TextStyle(fontSize: 24)), const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Pratik Modu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: c.accent)),
              const SizedBox(height: 2),
              Text('81 il · Süresiz · Puansız', style: TextStyle(fontSize: 12, color: c.textSecondary)),
            ])),
            Icon(Icons.arrow_forward_rounded, color: c.accent.withValues(alpha: 0.5), size: 20),
          ]),
        ),
      ),
    );
  }

  Widget _buildDailyCard(AppColors c) {
    final streak = StatsManager.currentStreak;
    final todayCount = StatsManager.todayQuizCount;
    final goal = StatsManager.dailyGoal;
    final reached = StatsManager.dailyGoalReached;
    final diamonds = StatsManager.totalDiamonds;
    return Container(
      width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: reached ? c.accent.withValues(alpha: 0.12) : c.cardBg,
        borderRadius: BorderRadius.circular(12), border: Border.all(color: reached ? c.accent.withValues(alpha: 0.3) : c.border),
      ),
      child: Row(children: [
        if (streak > 0) ...[
          Text('🔥 $streak', style: TextStyle(color: c.accent, fontSize: 14, fontWeight: FontWeight.w700)),
          Container(width: 1, height: 20, margin: const EdgeInsets.symmetric(horizontal: 8), color: c.border),
        ],
        Expanded(child: Row(children: [
          Text(reached ? '✅' : '📋', style: const TextStyle(fontSize: 14)), const SizedBox(width: 6),
          Flexible(child: Text(reached ? 'Günlük hedef tamam!' : '$todayCount / $goal farklı quiz',
            style: TextStyle(color: reached ? c.accent : c.textSecondary, fontSize: 13, fontWeight: reached ? FontWeight.w600 : FontWeight.w400))),
        ])),
        if (diamonds > 0) ...[
          Container(width: 1, height: 20, margin: const EdgeInsets.symmetric(horizontal: 8), color: c.border),
          Text('💎 $diamonds', style: const TextStyle(color: Color(0xFF818CF8), fontSize: 13, fontWeight: FontWeight.w700)),
        ],
        const SizedBox(width: 6),
        ...List.generate(goal, (i) => Container(width: 8, height: 8, margin: const EdgeInsets.only(left: 3),
          decoration: BoxDecoration(shape: BoxShape.circle, color: i < todayCount ? c.accent : c.border))),
      ]),
    );
  }

  Widget _buildGroup(BuildContext context, QuizGroup group, AppColors c) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(top: 20, bottom: 12), child: Row(children: [
        Container(width: 20, height: 1, color: c.border), const SizedBox(width: 8),
        Text(group.title, style: TextStyle(fontSize: 11, letterSpacing: 3, color: c.textMuted, fontWeight: FontWeight.w600)),
        const SizedBox(width: 8), Expanded(child: Container(height: 1, color: c.border)),
      ])),
      ...group.categories.map((cat) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: _CategoryButton(category: cat, colors: c, onTap: () => _showSpeedPicker(context, cat)),
      )),
    ]);
  }

  Widget _buildLeaderboardButton(AppColors c) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardScreen())),
      child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(gradient: LinearGradient(colors: [c.accent, c.accentDark]), borderRadius: BorderRadius.circular(12)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('🏆', style: TextStyle(fontSize: 18)), const SizedBox(width: 8),
          Text('Sıralama', style: TextStyle(color: c.onGradientDark, fontSize: 14, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }

  Widget _buildLivesIndicator(AppColors c) {
    final life = LifeManager();
    final remaining = life.timeUntilNextLife;
    final hasTimer = !life.isFull && remaining.inSeconds > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: life.lives > 0 ? c.wrong.withValues(alpha: 0.1) : c.wrong.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10), border: Border.all(color: c.wrong.withValues(alpha: 0.2)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('❤️ ${life.lives}', style: TextStyle(color: c.wrong, fontSize: 13, fontWeight: FontWeight.w700)),
        if (hasTimer) ...[const SizedBox(width: 6), Text('${remaining.inMinutes}dk', style: TextStyle(color: c.textMuted, fontSize: 10))],
      ]),
    );
  }

  void _showNoLivesDialog(AppColors c) {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (ctx) {
      final sc = ThemeScope.colorsOf(ctx);
      final remaining = LifeManager().timeUntilNextLife;
      final minutes = remaining.inMinutes;
      final seconds = remaining.inSeconds % 60;
      return Container(padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: sc.sheetBg, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: sc.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20), const Text('💔', style: TextStyle(fontSize: 48)), const SizedBox(height: 12),
          Text('Canın Bitti!', style: TextStyle(color: sc.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Sonraki can: ${minutes}dk ${seconds}sn', style: TextStyle(color: sc.textSecondary, fontSize: 14)),
          const SizedBox(height: 24),
          if (AdManager().isRewardedReady)
            GestureDetector(
              onTap: () { Navigator.pop(ctx); AdManager().showRewarded(onReward: () async { await LifeManager().addLife(); if (mounted) setState(() {}); }); },
              child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(gradient: LinearGradient(colors: [sc.accent, sc.accentDark]), borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: Text('🎬 Reklam İzle → +1 Can', style: TextStyle(color: sc.onGradientDark, fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () { Navigator.pop(ctx); Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen())); },
            child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF818CF8), Color(0xFF6366F1)]), borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center, child: const Text('💎 Premium Al → Sınırsız Can', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(onTap: () => Navigator.pop(ctx), child: Text('Bekle', style: TextStyle(color: sc.textMuted, fontSize: 13))),
          const SizedBox(height: 16),
        ]),
      );
    });
  }

  Widget _buildPremiumButton(AppColors c) {
    return GestureDetector(
      onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen())); if (mounted) setState(() {}); },
      child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF818CF8), Color(0xFF6366F1)]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: const Color(0xFF818CF8).withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('💎', style: TextStyle(fontSize: 18)), const SizedBox(width: 8),
          const Text('Premium Al', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
        ]),
      ),
    );
  }

  void _showSpeedPicker(BuildContext context, QuizCategory category) {
    if (category.isPremium && !PremiumManager().isPremium) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen())).then((_) { if (mounted) setState(() {}); });
      return;
    }
    if (!PremiumManager().isPremium && !LifeManager().hasLives) {
      _showNoLivesDialog(ThemeScope.colorsOf(context));
      return;
    }
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (ctx) => _SpeedPickerSheet(category: category, onSelect: (speed) async {
        Navigator.pop(ctx);
        // Practice modunda can harcanmaz
        if (speed != SpeedMode.practice) {
          final canPlay = await LifeManager().useLife();
          if (!canPlay) { if (mounted) _showNoLivesDialog(ThemeScope.colorsOf(context)); return; }
        }
        if (!mounted) return;
        Navigator.push(context, MaterialPageRoute(builder: (_) => QuizScreen(category: category, speed: speed)))
            .then((_) { if (mounted) setState(() {}); });
      }),
    );
  }
}

class _SpeedPickerSheet extends StatelessWidget {
  final QuizCategory category;
  final void Function(SpeedMode) onSelect;
  const _SpeedPickerSheet({required this.category, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final c = ThemeScope.colorsOf(context);
    final bestScore = StatsManager.getBestScore(category.id);
    final screenHeight = MediaQuery.of(context).size.height;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.85),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: BoxDecoration(color: c.sheetBg, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: c.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(category.icon, style: const TextStyle(fontSize: 22)), const SizedBox(width: 8),
            Text(category.name, style: TextStyle(color: c.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 6),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('${category.questionCount} soru', style: TextStyle(color: c.textSecondary, fontSize: 13)),
            if (bestScore > 0) ...[
              Text('  ·  ', style: TextStyle(color: c.border, fontSize: 13)),
              Text('En iyi: ⭐ $bestScore', style: TextStyle(color: c.accent, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ]),
          const SizedBox(height: 20),
          ...SpeedMode.values.where((s) => s != SpeedMode.practice).map((speed) {
            final perQ = speed.secondsPerQuestion;
            final highScore = StatsManager.getHighScore(category.id, speed.name);
            return Padding(padding: const EdgeInsets.only(bottom: 10), child: GestureDetector(
              onTap: () => onSelect(speed),
              child: Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(color: c.sheetItemBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: c.border, width: 1.5)),
                child: Row(children: [
                  Text(speed.icon, style: const TextStyle(fontSize: 20)), const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(speed.label, style: TextStyle(color: c.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                    Row(children: [
                      Text('Soru başı ${perQ}sn', style: TextStyle(color: c.textMuted, fontSize: 11)),
                      if (highScore > 0) ...[const Text(' ⭐ ', style: TextStyle(fontSize: 10)),
                        Text('$highScore', style: TextStyle(color: c.accent, fontSize: 11, fontWeight: FontWeight.w600))],
                    ]),
                  ])),
                  Text('×${speed.multiplier}', style: TextStyle(color: c.accent, fontSize: 16, fontWeight: FontWeight.w800)),
                ]),
              ),
            ));
          }),
          // Tümü (practice) modu
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => onSelect(SpeedMode.practice),
            child: Container(
              width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: c.sheetItemBg, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.accent.withValues(alpha: 0.3), width: 1.5)),
              child: Row(children: [
                const Text('📚', style: TextStyle(fontSize: 20)), const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Tümü', style: TextStyle(color: c.accent, fontSize: 15, fontWeight: FontWeight.w600)),
                  Text('${category.items.length} soru · Süresiz · Puansız', style: TextStyle(color: c.textMuted, fontSize: 11)),
                ])),
              ]),
            ),
          ),
        ])),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final QuizCategory category;
  final AppColors colors;
  final VoidCallback onTap;
  const _CategoryButton({required this.category, required this.colors, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bestScore = StatsManager.getBestScore(category.id);
    final locked = category.isPremium && !PremiumManager().isPremium;
    return GestureDetector(onTap: onTap, child: Opacity(opacity: locked ? 0.7 : 1.0, child: Container(
      width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: category.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: category.gradient[0].withValues(alpha: 0.25), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Row(children: [
        Text(category.icon, style: const TextStyle(fontSize: 24)), const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(category.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: category.textColor)),
            if (locked) ...[const SizedBox(width: 6), Icon(Icons.lock_rounded, color: category.textColor.withValues(alpha: 0.7), size: 14)],
          ]),
          const SizedBox(height: 2),
          Text(locked ? 'Premium' : category.subtitle, style: TextStyle(fontSize: 12, color: category.textColor.withValues(alpha: 0.75))),
        ])),
        if (locked) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: const Color(0xFF0F172A).withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)),
          child: const Text('💎', style: TextStyle(fontSize: 14)))
        else if (bestScore > 0) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: const Color(0xFF0F172A).withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)),
          child: Text('⭐ $bestScore', style: TextStyle(color: category.textColor, fontSize: 12, fontWeight: FontWeight.w700)))
        else Icon(Icons.arrow_forward_rounded, color: category.textColor.withValues(alpha: 0.5), size: 20),
      ]),
    )));
  }
}