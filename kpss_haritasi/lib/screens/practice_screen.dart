import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/province_data_helper.dart';
import '../data/sound_manager.dart';
import '../models/province.dart';
import '../models/app_colors.dart';
import '../models/theme_notifier.dart';
import '../widgets/turkey_map.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final Random _random = Random();
  final SoundManager _sound = SoundManager();

  bool _isLoading = true;
  List<ProvinceInfo> _allProvinces = [];
  List<ProvinceInfo> _questions = [];
  int _currentIndex = 0;
  bool _showResult = false;
  bool _isCorrect = false;
  bool _isFinished = false;

  String? _selectedProvinceId;
  final Set<String> _answeredCorrect = {};
  final Set<String> _answeredWrong = {};

  int _correctCount = 0;
  int _wrongCount = 0;

  ProvinceInfo get _currentProvince => _questions[_currentIndex];
  int get _totalQuestions => _questions.length;

  @override
  void initState() {
    super.initState();
    _loadAndStart();
  }

  Future<void> _loadAndStart() async {
    _allProvinces = await ProvinceDataHelper.loadProvinceList();
    _questions = List<ProvinceInfo>.from(_allProvinces)..shuffle(_random);
    if (mounted) setState(() => _isLoading = false);
  }

  void _handleProvinceTap(Province province) {
    if (_showResult || _isFinished) return;

    final correct = province.id == _currentProvince.id;

    if (correct) {
      _sound.playCorrect();
      HapticFeedback.lightImpact();
      _correctCount++;
    } else {
      _sound.playWrong();
      HapticFeedback.mediumImpact();
      _wrongCount++;
    }

    setState(() {
      _selectedProvinceId = province.id;
      _isCorrect = correct;
      _showResult = true;

      if (correct) {
        _answeredCorrect.add(province.id);
      } else {
        // Sadece doğru konumu kırmızı göster, tıklanan yerde değişiklik yok
        _answeredWrong.add(_currentProvince.id);
      }
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentIndex + 1 >= _totalQuestions) {
      _sound.playComplete();
      setState(() => _isFinished = true);
      _showSummaryDialog();
      return;
    }
    setState(() {
      _currentIndex++;
      _showResult = false;
      _selectedProvinceId = null;
    });
  }

  void _showSummaryDialog() {
    final percentage = (_correctCount / _totalQuestions * 100).round();
    final emoji = percentage >= 80 ? '🏆' : percentage >= 50 ? '👍' : '💪';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final sc = ThemeScope.colorsOf(ctx);
        return Dialog(
          backgroundColor: sc.cardBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(emoji, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text('Pratik Tamamlandı!', style: TextStyle(
                color: sc.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _buildStatChip(sc, '✓ $_correctCount doğru', sc.correct),
                const SizedBox(width: 12),
                _buildStatChip(sc, '✗ $_wrongCount yanlış', sc.wrong),
              ]),
              const SizedBox(height: 8),
              Text('%$percentage başarı', style: TextStyle(
                color: sc.textSecondary, fontSize: 14)),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(child: GestureDetector(
                  onTap: () { Navigator.pop(ctx); _restart(); },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [sc.accent, sc.accentDark]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text('Tekrar Dene', style: TextStyle(
                      color: sc.onGradientDark, fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                )),
                const SizedBox(width: 10),
                Expanded(child: GestureDetector(
                  onTap: () { Navigator.pop(ctx); Navigator.pop(context); },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: sc.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text('Menüye Dön', style: TextStyle(
                      color: sc.textSecondary, fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                )),
              ]),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildStatChip(AppColors c, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(text, style: TextStyle(
        color: color, fontSize: 14, fontWeight: FontWeight.w700)),
    );
  }

  void _restart() {
    setState(() {
      _questions.shuffle(_random);
      _currentIndex = 0;
      _correctCount = 0;
      _wrongCount = 0;
      _showResult = false;
      _isCorrect = false;
      _isFinished = false;
      _selectedProvinceId = null;
      _answeredCorrect.clear();
      _answeredWrong.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = ThemeScope.colorsOf(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: c.scaffoldBg,
        body: Center(child: CircularProgressIndicator(color: c.accent)),
      );
    }

    return Scaffold(
      backgroundColor: c.scaffoldBg,
      body: SafeArea(child: Column(children: [
        _buildHeader(c),
        _buildProgressBar(c),
        _buildQuestion(c),
        if (_showResult) _buildFeedback(c),
        Expanded(child: _buildMap(c)),
      ])),
    );
  }

  Widget _buildHeader(AppColors c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: c.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('← Çıkış', style: TextStyle(color: c.textSecondary, fontSize: 12)),
          ),
        ),
        const Spacer(),
        Text('${_currentIndex + 1} / $_totalQuestions',
          style: TextStyle(color: c.textSecondary, fontSize: 13)),
        const SizedBox(width: 12),
        Text('✓ $_correctCount', style: TextStyle(
          color: c.correct, fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(width: 8),
        Text('✗ $_wrongCount', style: TextStyle(
          color: c.wrong, fontSize: 13, fontWeight: FontWeight.w700)),
      ]),
    );
  }

  Widget _buildProgressBar(AppColors c) {
    final progress = _totalQuestions > 0 ? (_currentIndex + (_showResult ? 1 : 0)) / _totalQuestions : 0.0;
    return Container(height: 3, color: c.borderLight, child: Align(
      alignment: Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut,
        width: MediaQuery.of(context).size.width * progress,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [c.accent, c.correct]),
        ),
      ),
    ));
  }

  Widget _buildQuestion(AppColors c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(children: [
        Text('Bu ili haritada bul:', style: TextStyle(color: c.textMuted, fontSize: 12)),
        const SizedBox(height: 4),
        Text(_currentProvince.name, style: TextStyle(
          color: c.textPrimary, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          textAlign: TextAlign.center),
      ]),
    );
  }

  Widget _buildFeedback(AppColors c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4, left: 16, right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _isCorrect ? c.correctFeedbackBg : c.wrongFeedbackBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _isCorrect ? c.correctFeedbackBorder : c.wrongFeedbackBorder),
      ),
      child: Text(
        _isCorrect ? '✓ Doğru!' : '✗ Yanlış',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
          color: _isCorrect ? c.correct : c.wrong),
      ),
    );
  }

  Widget _buildMap(AppColors c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TurkeyMap(
        correctProvinceId: _currentProvince.id,
        showResult: _showResult,
        isCorrect: _isCorrect,
        selectedProvinceId: _selectedProvinceId,
        answeredCorrect: _answeredCorrect,
        answeredWrong: _answeredWrong,
        interactive: !_showResult && !_isFinished,
        onProvinceTap: _handleProvinceTap,
      ),
    );
  }
}