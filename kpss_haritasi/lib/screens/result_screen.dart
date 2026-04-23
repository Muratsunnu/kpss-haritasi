import 'package:flutter/material.dart';
import 'package:kpss_haritasi/data/premium_manager.dart';
import '../data/stats_manager.dart';
import '../data/ad_manager.dart';
import '../models/quiz_category.dart';
import '../models/theme_notifier.dart';
import 'menu_screen.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final List<Map<String, dynamic>> answers;
  final QuizCategory category;
  final SpeedMode speed;
  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.answers,
    required this.category,
    required this.speed,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isNewRecord = false;
  bool _countedForDaily = false;

  @override
  void initState() {
    super.initState();
    _saveStats();
  }

  Future<void> _saveStats() async {
    final correctCount = widget.answers
        .where((a) => a['correct'] == true)
        .length;
    final wrongCount = widget.totalQuestions - correctCount;
    final counted = await StatsManager.recordQuizResult(
      correctCount: correctCount,
      wrongCount: wrongCount,
      points: widget.score,
      categoryId: widget.category.id,
    );
    final isNew = await StatsManager.saveHighScore(
      widget.category.id,
      widget.speed.name,
      widget.score,
    );
    if (mounted)
      setState(() {
        _isNewRecord = isNew;
        _countedForDaily = counted;
      });

    // Her 3 quizde bir geçiş reklamı
    AdManager().showInterstitialIfReady();
  }

  QuizCategory? _buildRetryCategory() {
    if (QuizCatalog.isProvinceMode(widget.category.id)) return null;
    final wrongNames = widget.answers
        .where((a) => a['correct'] == false)
        .map((a) => a['name'] as String)
        .toSet();
    if (wrongNames.isEmpty) return null;
    final wrongItems = widget.category.items
        .where((item) => wrongNames.contains(item.name))
        .toList();
    if (wrongItems.isEmpty) return null;
    return QuizCategory(
      id: widget.category.id,
      name: '${widget.category.name} (Tekrar)',
      subtitle: '${wrongItems.length} yanlış',
      icon: widget.category.icon,
      gradient: widget.category.gradient,
      textColor: widget.category.textColor,
      questionLabel: widget.category.questionLabel,
      items: wrongItems,
      questionCount: wrongItems.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = ThemeScope.colorsOf(context);
    final correctCount = widget.answers
        .where((a) => a['correct'] == true)
        .length;
    final percentage = (correctCount / widget.totalQuestions * 100).round();
    final emoji = percentage >= 80
        ? '🏆'
        : percentage >= 50
        ? '👍'
        : '💪';
    final message = percentage >= 80
        ? 'Harika! Coğrafya bilgin çok iyi!'
        : percentage >= 50
        ? 'Fena değil! Biraz daha pratik yapmalısın.'
        : 'Çalışmaya devam! Her seferinde daha iyi olacaksın.';
    final retryCategory = _buildRetryCategory();

    return Scaffold(
      backgroundColor: c.scaffoldBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 6),
                  if (_isNewRecord)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [c.accent, c.accentDark],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '🎉 YENİ REKOR!',
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: c.cardBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${widget.speed.icon} ${widget.speed.label} · ×${widget.speed.multiplier}',
                      style: TextStyle(color: c.textSecondary, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$correctCount / ${widget.totalQuestions} doğru',
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('⭐', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 6),
                      Text(
                        '${widget.score}',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: c.accent,
                        ),
                      ),
                      Text(
                        ' puan',
                        style: TextStyle(fontSize: 14, color: c.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_countedForDaily && PremiumManager().isPremium)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF818CF8).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF818CF8).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        '💎 +${widget.score} elmas · Günlük seriye sayıldı!',
                        style: const TextStyle(
                          color: Color(0xFF818CF8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: c.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 180),
                    decoration: BoxDecoration(
                      color: c.cardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(10),
                      itemCount: widget.answers.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: c.border, height: 1),
                      itemBuilder: (context, index) {
                        final answer = widget.answers[index];
                        final isCorrect = answer['correct'] as bool;
                        final points = answer['points'] as int? ?? 0;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Text(
                                isCorrect ? '✅' : '❌',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  answer['name'] as String,
                                  style: TextStyle(
                                    color: c.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (isCorrect)
                                Text(
                                  '+$points',
                                  style: TextStyle(
                                    color: c.accent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              else
                                Flexible(
                                  child: Text(
                                    answer['selected'] as String,
                                    style: TextStyle(
                                      color: c.wrong,
                                      fontSize: 10,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      _ActionButton(
                        label: 'Ana Menü',
                        color: c.cardBg,
                        textColor: c.textPrimary,
                        borderColor: c.border,
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MenuScreen(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                      _ActionButton(
                        label: 'Tekrar Oyna',
                        gradient: [c.accent, c.accentDark],
                        textColor: const Color(0xFF0F172A),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizScreen(
                                category: widget.category,
                                speed: widget.speed,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  if (retryCategory != null) ...[
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(
                              category: retryCategory,
                              speed: widget.speed,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: c.wrong.withValues(alpha: 0.5),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '🔄 Yanlışları Tekrarla (${retryCategory.questionCount})',
                          style: TextStyle(
                            color: c.wrong,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color? color;
  final List<Color>? gradient;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;
  const _ActionButton({
    required this.label,
    this.color,
    this.gradient,
    required this.textColor,
    this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
        decoration: BoxDecoration(
          color: gradient == null ? color : null,
          gradient: gradient != null ? LinearGradient(colors: gradient!) : null,
          borderRadius: BorderRadius.circular(12),
          border: borderColor != null && gradient == null
              ? Border.all(color: borderColor!)
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
