import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'premium_manager.dart';

/// Can sistemi — 5 can, 1 saatte 1 yenilenir, premium sınırsız
class LifeManager extends ChangeNotifier {
  static final LifeManager _instance = LifeManager._();
  factory LifeManager() => _instance;
  LifeManager._();

  static const int maxLives = 5;
  static const int regenMinutes = 60; // 1 saat = 60 dakika
  static const String _livesKey = 'lives_count';
  static const String _lastUsedKey = 'lives_last_used';

  int _lives = maxLives;
  Timer? _regenTimer;

  int get lives => PremiumManager().isPremium ? maxLives : _lives;
  bool get hasLives => PremiumManager().isPremium || _lives > 0;
  bool get isFull => _lives >= maxLives;

  /// Sonraki can yenilenmesine kalan süre
  Duration get timeUntilNextLife {
    if (_lives >= maxLives) return Duration.zero;
    final lastUsed = _prefs?.getString(_lastUsedKey);
    if (lastUsed == null) return Duration.zero;

    final lastTime = DateTime.tryParse(lastUsed);
    if (lastTime == null) return Duration.zero;

    final elapsed = DateTime.now().difference(lastTime);
    final regenDuration = Duration(minutes: regenMinutes);
    final livesRegened = elapsed.inMinutes ~/ regenMinutes;
    
    if (_lives + livesRegened >= maxLives) return Duration.zero;

    final nextRegenAt = lastTime.add(regenDuration * (livesRegened + 1));
    final remaining = nextRegenAt.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _lives = _prefs?.getInt(_livesKey) ?? maxLives;
    _applyRegen();
    _startRegenTimer();
  }

  /// Geçen süreye göre can yenile
  void _applyRegen() {
    if (_lives >= maxLives) return;

    final lastUsed = _prefs?.getString(_lastUsedKey);
    if (lastUsed == null) return;

    final lastTime = DateTime.tryParse(lastUsed);
    if (lastTime == null) return;

    final elapsed = DateTime.now().difference(lastTime);
    final livesRegened = elapsed.inMinutes ~/ regenMinutes;

    if (livesRegened > 0) {
      _lives = (_lives + livesRegened).clamp(0, maxLives);
      _save();
    }
  }

  /// Her dakika kontrol et
  void _startRegenTimer() {
    _regenTimer?.cancel();
    _regenTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      _applyRegen();
      notifyListeners();
    });
  }

  /// Quiz başlatırken 1 can harca — true dönerse quiz başlayabilir
  Future<bool> useLife() async {
    if (PremiumManager().isPremium) return true;

    _applyRegen(); // Önce yenilenmeyi uygula

    if (_lives <= 0) return false;

    _lives--;
    await _prefs?.setString(_lastUsedKey, DateTime.now().toIso8601String());
    await _save();
    notifyListeners();
    return true;
  }

  /// Ödül reklamı izledikten sonra 1 can ekle
  Future<void> addLife() async {
    if (_lives >= maxLives) return;
    _lives++;
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    await _prefs?.setInt(_livesKey, _lives);
  }

  /// Çıkışta timer'ı durdur
  void stopTimer() {
    _regenTimer?.cancel();
  }

  /// Giriş/çıkışta reset
  Future<void> reset() async {
    _lives = maxLives;
    await _save();
    notifyListeners();
  }
}