import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/province_data_helper.dart';
import '../data/sound_manager.dart';
import '../models/province.dart';
import '../models/map_item.dart';
import '../models/quiz_category.dart';
import '../models/app_colors.dart';
import '../models/theme_notifier.dart';
import '../widgets/turkey_map.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final QuizCategory category;
  final SpeedMode speed;
  const QuizScreen({super.key, required this.category, required this.speed});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  final Random _random = Random();
  final SoundManager _sound = SoundManager();

  bool _isLoading = true;
  int _currentIndex = 0;
  int _score = 0;
  bool _showResult = false;
  bool _isCorrect = false;
  final List<Map<String, dynamic>> _answers = [];

  List<ProvinceInfo> _allProvinces = [];
  List<ProvinceInfo> _provinceQuestions = [];
  List<ProvinceInfo> _options = [];
  String? _selectedProvinceId;
  final Set<String> _answeredCorrect = {};
  final Set<String> _answeredWrong = {};

  List<MapItem> _itemQuestions = [];
  String? _selectedItemId;
  final Set<String> _itemAnsweredCorrect = {};
  final Set<String> _itemAnsweredWrong = {};

  late int _questionTime;
  late int _remainingSeconds;
  Timer? _timer;

  bool get _isProvinceMode => QuizCatalog.isProvinceMode(widget.category.id);
  bool get _isGuessMode => widget.category.id == 'guess_province';
  bool get _isPractice => widget.speed == SpeedMode.practice;

  int get totalQuestions {
    if (_isPractice) {
      if (_isProvinceMode) return _provinceQuestions.length;
      return _itemQuestions.length;
    }
    return widget.category.questionCount;
  }

  late AnimationController _feedbackController;
  late Animation<double> _feedbackAnimation;

  @override
  void initState() {
    super.initState();
    _questionTime = widget.speed.secondsPerQuestion;
    _feedbackController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _feedbackAnimation = CurvedAnimation(parent: _feedbackController, curve: Curves.elasticOut);
    _loadAndStart();
  }

  @override
  void dispose() { _timer?.cancel(); _feedbackController.dispose(); super.dispose(); }

  Future<void> _loadAndStart() async {
    if (_isProvinceMode) { _allProvinces = await ProvinceDataHelper.loadProvinceList(); _startProvinceGame(); }
    else { _startItemGame(); }
    if (mounted) setState(() => _isLoading = false);
    if (!_isPractice) _startQuestionTimer();
  }

  // ════════ SORU BAŞI TIMER ════════

  void _startQuestionTimer() {
    if (_isPractice) return;
    _timer?.cancel();
    _remainingSeconds = _questionTime;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds > 0 && _remainingSeconds <= 3 && !_showResult) _sound.playTick();
        if (_remainingSeconds <= 0) { _remainingSeconds = 0; timer.cancel(); _onQuestionTimeUp(); }
      });
    });
  }

  void _onQuestionTimeUp() {
    if (_showResult || _isPractice) return;
    _sound.playWrong();
    HapticFeedback.mediumImpact();
    setState(() {
      _isCorrect = false; _showResult = true;
      _answers.add({'name': _currentQuestionName, 'correct': false, 'selected': 'Süre doldu', 'points': 0});
      if (!_isProvinceMode) _itemAnsweredWrong.add(_itemQuestions[_currentIndex].id);
      _feedbackController.forward(from: 0);
    });
    Future.delayed(const Duration(milliseconds: 1500), () { if (!mounted) return; _nextQuestion(); });
  }

  // ════════ İL MODU ════════

  void _startProvinceGame() {
    final s = List<ProvinceInfo>.from(_allProvinces)..shuffle(_random);
    _provinceQuestions = _isPractice ? s : s.take(widget.category.questionCount).toList();
    _resetCommon();
    if (_isGuessMode) _generateOptions();
  }

  void _generateOptions() {
    final correct = _provinceQuestions[_currentIndex];
    final others = _allProvinces.where((p) => p.id != correct.id).toList()..shuffle(_random);
    _options = [correct, ...others.take(3)]..shuffle(_random);
  }

  ProvinceInfo get _currentProvince => _provinceQuestions[_currentIndex];

  void _handleProvinceTap(Province province) {
    if (_showResult) return;
    _timer?.cancel();
    final correct = province.id == _currentProvince.id;
    _recordAnswer(correct, _currentProvince.name, province.name);
    setState(() { _selectedProvinceId = province.id; if (correct) _answeredCorrect.add(province.id); else _answeredWrong.add(province.id); });
  }

  void _handleOptionTap(ProvinceInfo option) {
    if (_showResult) return;
    _timer?.cancel();
    final correct = option.id == _currentProvince.id;
    _recordAnswer(correct, _currentProvince.name, option.name);
    setState(() { _selectedProvinceId = option.id; if (correct) _answeredCorrect.add(_currentProvince.id); else _answeredWrong.add(_currentProvince.id); });
  }

  // ════════ MAPITEM MODU ════════

  void _startItemGame() {
    final allItems = List<MapItem>.from(widget.category.items)..shuffle(_random);
    _itemQuestions = _isPractice ? allItems : allItems.take(widget.category.questionCount).toList();
    _resetCommon();
  }

  MapItem get _currentItem => _itemQuestions[_currentIndex];

  void _handleItemTap(MapItem item) {
    if (_showResult) return;
    _timer?.cancel();
    final correct = item.name == _currentItem.name;
    _recordAnswer(correct, _currentItem.name, item.name);
    setState(() {
      _selectedItemId = item.id;
      if (correct) _itemAnsweredCorrect.add(item.id);
      else _itemAnsweredWrong.add(_currentItem.id);
    });
  }

  // ════════ ORTAK ════════

  String get _currentQuestionName => _isProvinceMode ? _currentProvince.name : _currentItem.name;

  void _resetCommon() {
    _currentIndex = 0; _score = 0; _showResult = false;
    _selectedProvinceId = null; _selectedItemId = null;
    _answers.clear(); _answeredCorrect.clear(); _answeredWrong.clear();
    _itemAnsweredCorrect.clear(); _itemAnsweredWrong.clear();
  }

  int _calculatePoints() {
    if (_isPractice) return 0;
    return 10 + (_remainingSeconds * widget.speed.multiplier);
  }

  void _recordAnswer(bool correct, String qName, String sName) {
    final points = correct ? _calculatePoints() : 0;
    if (correct) { _sound.playCorrect(); HapticFeedback.lightImpact(); }
    else { _sound.playWrong(); HapticFeedback.mediumImpact(); }
    setState(() {
      _isCorrect = correct; _showResult = true; _score += points;
      _answers.add({'name': qName, 'correct': correct, 'selected': sName, 'points': points});
      _feedbackController.forward(from: 0);
    });
    Future.delayed(const Duration(milliseconds: 1200), () { if (!mounted) return; _nextQuestion(); });
  }

  void _nextQuestion() {
    if (_currentIndex + 1 >= totalQuestions) {
      _timer?.cancel();
      _sound.playComplete();
      if (_isPractice) { _showPracticeSummary(); return; }
      _goToResult();
      return;
    }
    setState(() {
      _currentIndex++; _showResult = false;
      _selectedProvinceId = null; _selectedItemId = null;
      if (_isGuessMode) _generateOptions();
    });
    if (!_isPractice) _startQuestionTimer();
  }

  void _goToResult() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultScreen(
      score: _score, totalQuestions: totalQuestions, answers: _answers,
      category: widget.category, speed: widget.speed,
    )));
  }

  void _showPracticeSummary() {
    final correctCount = _answers.where((a) => a['correct'] == true).length;
    final wrongCount = totalQuestions - correctCount;
    final percentage = (correctCount / totalQuestions * 100).round();
    final emoji = percentage >= 80 ? '🏆' : percentage >= 50 ? '👍' : '💪';

    showDialog(context: context, barrierDismissible: false, builder: (ctx) {
      final sc = ThemeScope.colorsOf(ctx);
      return Dialog(
        backgroundColor: sc.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('Tamamlandı!', style: TextStyle(color: sc.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(color: sc.correct.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: sc.correct.withValues(alpha: 0.3))),
              child: Text('✓ $correctCount doğru', style: TextStyle(color: sc.correct, fontSize: 14, fontWeight: FontWeight.w700))),
            const SizedBox(width: 12),
            Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(color: sc.wrong.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: sc.wrong.withValues(alpha: 0.3))),
              child: Text('✗ $wrongCount yanlış', style: TextStyle(color: sc.wrong, fontSize: 14, fontWeight: FontWeight.w700))),
          ]),
          const SizedBox(height: 8),
          Text('%$percentage başarı', style: TextStyle(color: sc.textSecondary, fontSize: 14)),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: GestureDetector(
              onTap: () { Navigator.pop(ctx); Navigator.pop(context); },
              child: Container(padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(border: Border.all(color: sc.border), borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: Text('Menüye Dön', style: TextStyle(color: sc.textSecondary, fontSize: 15, fontWeight: FontWeight.w600))),
            )),
          ]),
        ])),
      );
    });
  }

  // ════════ BUILD ════════

  @override
  Widget build(BuildContext context) {
    final c = ThemeScope.colorsOf(context);
    if (_isLoading) return Scaffold(backgroundColor: c.scaffoldBg, body: Center(child: CircularProgressIndicator(color: c.accent)));
    return Scaffold(
      backgroundColor: c.scaffoldBg,
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        return isLandscape ? _buildLandscapeLayout(c, constraints) : _buildPortraitLayout(c);
      })),
    );
  }

  Widget _buildPortraitLayout(AppColors c) {
    return Column(children: [
      _buildHeader(c),
      if (!_isPractice) _buildTimerBar(c),
      _buildQuestion(c),
      if (_showResult) _buildFeedback(c),
      Expanded(child: _buildMap(c)),
      if (_isGuessMode && !_showResult) _buildOptions(c),
    ]);
  }

  Widget _buildLandscapeLayout(AppColors c, BoxConstraints constraints) {
    return Column(children: [
      _buildHeader(c),
      if (!_isPractice) _buildTimerBar(c),
      Expanded(child: Row(children: [
        SizedBox(width: constraints.maxWidth * 0.3, child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(children: [
            _buildQuestion(c),
            if (_showResult) _buildFeedback(c),
            if (_isGuessMode && !_showResult) _buildOptions(c),
          ]),
        )),
        Expanded(child: _buildMap(c)),
      ])),
    ]);
  }

  Widget _buildHeader(AppColors c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(children: [
        GestureDetector(
          onTap: () { _timer?.cancel(); Navigator.pop(context); },
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(border: Border.all(color: c.border), borderRadius: BorderRadius.circular(8)),
            child: Text('← Çıkış', style: TextStyle(color: c.textSecondary, fontSize: 12))),
        ),
        const Spacer(),
        Text('${_currentIndex + 1} / $totalQuestions', style: TextStyle(color: c.textSecondary, fontSize: 13)),
        if (!_isPractice) ...[
          const SizedBox(width: 10),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _remainingSeconds <= 3 ? c.wrong.withValues(alpha: 0.2) : c.timerBg,
              borderRadius: BorderRadius.circular(8)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.timer_outlined, size: 14, color: _remainingSeconds <= 3 ? c.wrong : c.textSecondary),
              const SizedBox(width: 3),
              Text('${_remainingSeconds}s', style: TextStyle(
                color: _remainingSeconds <= 3 ? c.wrong : c.textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
            ]),
          ),
          const SizedBox(width: 10),
          Text('⭐ $_score', style: TextStyle(color: c.accent, fontSize: 14, fontWeight: FontWeight.w700)),
        ],
      ]),
    );
  }

  Widget _buildTimerBar(AppColors c) {
    final progress = _questionTime > 0 ? _remainingSeconds / _questionTime : 0.0;
    return Container(height: 3, color: c.borderLight, child: Align(
      alignment: Alignment.centerLeft,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 900), curve: Curves.linear,
        width: MediaQuery.of(context).size.width * progress,
        decoration: BoxDecoration(gradient: LinearGradient(
          colors: _remainingSeconds <= 3 ? [c.wrong, c.wrong] : [c.accent, c.correct])),
      ),
    ));
  }

  Widget _buildQuestion(AppColors c) {
    final showName = !_isGuessMode;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: showName
          ? Column(children: [
              Text(widget.category.questionLabel, style: TextStyle(color: c.textMuted, fontSize: 12)),
              const SizedBox(height: 4),
              Text(_currentQuestionName, style: TextStyle(color: c.textPrimary, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5), textAlign: TextAlign.center),
            ])
          : Text(widget.category.questionLabel, style: TextStyle(color: c.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildFeedback(AppColors c) {
    final points = _answers.isNotEmpty ? (_answers.last['points'] as int? ?? 0) : 0;
    final lastAnswer = _answers.isNotEmpty ? _answers.last : null;
    final isTimeUp = lastAnswer != null && lastAnswer['selected'] == 'Süre doldu';

    String? infoNote;
    if (!_isProvinceMode) { final desc = _currentItem.description; if (desc.isNotEmpty) infoNote = desc; }

    String feedbackText;
    if (isTimeUp) { feedbackText = '⏰ Süre doldu!'; }
    else if (_isCorrect) { feedbackText = _isPractice ? '✓ Doğru!' : '✓ Doğru! +$points puan'; }
    else { feedbackText = '✗ Yanlış'; }

    return AnimatedBuilder(animation: _feedbackAnimation, builder: (context, child) {
      return Transform.scale(scale: _feedbackAnimation.value.clamp(0.0, 1.2),
        child: Container(
          margin: const EdgeInsets.only(bottom: 4, left: 16, right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _isCorrect ? c.correctFeedbackBg : c.wrongFeedbackBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _isCorrect ? c.correctFeedbackBorder : c.wrongFeedbackBorder)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(feedbackText, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _isCorrect ? c.correct : c.wrong)),
            if (infoNote != null) ...[const SizedBox(height: 3),
              Text('💡 $infoNote', style: TextStyle(fontSize: 10, color: c.textSecondary), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis)],
          ]),
        ),
      );
    });
  }

  Widget _buildMap(AppColors c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TurkeyMap(
        highlightedProvinceId: _isGuessMode && !_showResult ? _currentProvince.id : null,
        correctProvinceId: _isProvinceMode ? _currentProvince.id : null,
        showResult: _showResult, isCorrect: _isCorrect,
        selectedProvinceId: _selectedProvinceId, answeredCorrect: _answeredCorrect, answeredWrong: _answeredWrong,
        interactive: !_showResult && (widget.category.id == 'find_province' || !_isProvinceMode),
        onProvinceTap: widget.category.id == 'find_province' ? _handleProvinceTap : null,
        itemMode: !_isProvinceMode, items: !_isProvinceMode ? _itemQuestions : const [],
        selectedItemId: _selectedItemId, correctItemId: !_isProvinceMode ? _currentItem.id : null,
        itemAnsweredCorrect: _itemAnsweredCorrect, itemAnsweredWrong: _itemAnsweredWrong,
        onItemTap: !_isProvinceMode ? _handleItemTap : null, itemColor: widget.category.gradient[0],
      ),
    );
  }

  Widget _buildOptions(AppColors c) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: GridView.count(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 3.0,
        children: _options.map((option) {
          Color bg = c.cardBg; Color border = c.border; Color textColor = c.textPrimary;
          if (_showResult) {
            if (option.id == _currentProvince.id) { bg = c.correctFeedbackBg; border = c.correct; textColor = c.correct; }
            else if (option.id == _selectedProvinceId) { bg = c.wrongFeedbackBg; border = c.wrong; textColor = c.wrong; }
          }
          return GestureDetector(
            onTap: () => _handleOptionTap(option),
            child: AnimatedContainer(duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(color: bg, border: Border.all(color: border, width: 2), borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: Text(option.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor), textAlign: TextAlign.center)),
          );
        }).toList(),
      ),
    );
  }
}