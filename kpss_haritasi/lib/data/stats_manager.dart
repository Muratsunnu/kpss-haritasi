import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'leaderboard_service.dart';
import 'auth_service.dart';
import 'premium_manager.dart';
import 'notification_manager.dart';

/// Üç puan sistemi:
/// ⭐ Normal puan — her quizden kazanılır, sürekli birikir
/// 💎 Elmas puan — aylık, günlük 3 FARKLI kategori tamamlandığında, ay sonunda sıfırlanır
/// 🏅 Prestij puan — ay bitince elmaslar buraya eklenir, sürekli birikir
class StatsManager {
  static SharedPreferences? _prefs;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _p => _prefs!;
  static String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  static DocumentReference? get _userStatsRef {
    final uid = _uid;
    if (uid == null) return null;
    return _db.collection('user_stats').doc(uid);
  }

  // ════════ CLOUD SYNC ════════

  static Future<void> loadFromCloud() async {
    final ref = _userStatsRef;
    if (ref == null) return;

    try {
      final doc = await ref.get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>? ?? {};

        await _p.setInt('stat_total_quizzes', data['totalQuizzes'] ?? 0);
        await _p.setInt('stat_total_correct', data['totalCorrect'] ?? 0);
        await _p.setInt('stat_total_wrong', data['totalWrong'] ?? 0);
        await _p.setInt('stat_total_points', data['totalPoints'] ?? 0);
        await _p.setInt('stat_total_diamonds', data['totalDiamonds'] ?? 0);
        await _p.setInt('stat_total_prestige', data['totalPrestige'] ?? 0);
        await _p.setString('stat_diamond_month', data['diamondMonth'] ?? '');

        await _p.setInt('streak_current', data['streakCurrent'] ?? 0);
        await _p.setInt('streak_longest', data['streakLongest'] ?? 0);
        await _p.setString('streak_last_date', data['streakLastDate'] ?? '');
        await _p.setInt('streak_shield_used_month', data['streakShieldUsedMonth'] ?? 0);

        final today = _todayKey;
        final cloudToday = data['lastDailyDate'] ?? '';
        if (cloudToday == today) {
          await _p.setInt('daily_points_$today', data['todayPoints'] ?? 0);
          final cats = List<String>.from(data['todayCategories'] ?? []);
          await _p.setString('daily_cats_$today', jsonEncode(cats));
        } else {
          await _p.setInt('daily_points_$today', 0);
          await _p.setString('daily_cats_$today', jsonEncode([]));
        }

        final categories = data['categories'] as Map<String, dynamic>? ?? {};
        for (final catId in categories.keys) {
          final catData = categories[catId] as Map<String, dynamic>? ?? {};
          await _p.setInt('stat_cat_${catId}_played', catData['played'] ?? 0);
          await _p.setInt('stat_cat_${catId}_correct', catData['correct'] ?? 0);
          await _p.setInt('stat_cat_${catId}_wrong', catData['wrong'] ?? 0);
        }

        final highScores = data['highScores'] as Map<String, dynamic>? ?? {};
        for (final key in highScores.keys) {
          await _p.setInt('high_$key', highScores[key] ?? 0);
        }
      } else {
        await _clearStatsLocal();
      }
    } catch (_) {}

    _checkStreakOnLoad();
    await _checkMonthlyReset();
  }

  /// Ay değişti mi kontrol et — elmasları prestije aktar
  static Future<void> _checkMonthlyReset() async {
    final currentMonth = _currentMonthKey;
    final savedMonth = _p.getString('stat_diamond_month') ?? '';

    if (savedMonth.isEmpty) {
      // İlk kez — sadece ay'ı kaydet
      await _p.setString('stat_diamond_month', currentMonth);
      return;
    }

    if (savedMonth != currentMonth) {
      // Ay değişmiş — rozet kontrolü yap, sonra elmasları prestije aktar
      try {
        final rank = await LeaderboardService().getPreviousMonthRank();
        if (rank >= 1 && rank <= 10) {
          // Ay adını Türkçe olarak al
          const aylar = ['', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];
          final parts = savedMonth.split('-');
          final yil = parts[0];
          final ayNo = int.tryParse(parts[1]) ?? 0;
          final ayAdi = aylar[ayNo];

          String badge;
          if (rank == 1) { badge = '$yil $ayAdi 1.liği'; }
          else if (rank == 2) { badge = '$yil $ayAdi 2.liği'; }
          else if (rank == 3) { badge = '$yil $ayAdi 3.lüğü'; }
          else { badge = '$yil $ayAdi Top 10'; }
          await AuthService().addBadge(badge);
        }
      } catch (_) {}

      final diamonds = totalDiamonds;
      if (diamonds > 0) {
        await _p.setInt('stat_total_prestige', totalPrestige + diamonds);
      }
      await _p.setInt('stat_total_diamonds', 0);
      await _p.setString('stat_diamond_month', currentMonth);
      await _syncToCloud();
    }
  }

  static String get _currentMonthKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  static void _checkStreakOnLoad() {
    final lastDate = _p.getString('streak_last_date') ?? '';
    final today = _todayKey;
    final yesterday = _yesterdayKey;

    if (lastDate == today || lastDate == yesterday) return;

    if (lastDate.isNotEmpty && currentStreak > 0) {
      if (PremiumManager().isPremium && !_isShieldUsedThisMonth()) {
        _p.setString('streak_last_date', yesterday);
        _p.setInt('streak_shield_used_month', DateTime.now().month);
        _syncToCloud();
      } else {
        _p.setInt('streak_current', 0);
        _syncToCloud();
      }
    }
  }

  static bool _isShieldUsedThisMonth() {
    final usedMonth = _p.getInt('streak_shield_used_month') ?? 0;
    return usedMonth == DateTime.now().month;
  }

  static bool get hasStreakShield {
    return PremiumManager().isPremium && !_isShieldUsedThisMonth();
  }

  static Future<void> _syncToCloud() async {
    final ref = _userStatsRef;
    if (ref == null) return;

    try {
      final categories = <String, dynamic>{};
      for (final catId in _allCategoryIds) {
        final played = _p.getInt('stat_cat_${catId}_played') ?? 0;
        if (played > 0) {
          categories[catId] = {
            'played': played,
            'correct': _p.getInt('stat_cat_${catId}_correct') ?? 0,
            'wrong': _p.getInt('stat_cat_${catId}_wrong') ?? 0,
          };
        }
      }

      final highScores = <String, dynamic>{};
      for (final catId in _allCategoryIds) {
        for (final speed in ['slow', 'medium', 'fast']) {
          final key = '${catId}_$speed';
          final score = _p.getInt('high_$key') ?? 0;
          if (score > 0) highScores[key] = score;
        }
      }

      final today = _todayKey;

      await ref.set({
        'totalQuizzes': totalQuizzesPlayed,
        'totalCorrect': totalCorrectAnswers,
        'totalWrong': totalWrongAnswers,
        'totalPoints': totalPoints,
        'totalDiamonds': totalDiamonds,
        'totalPrestige': totalPrestige,
        'diamondMonth': _p.getString('stat_diamond_month') ?? '',
        'streakCurrent': currentStreak,
        'streakLongest': longestStreak,
        'streakLastDate': _p.getString('streak_last_date') ?? '',
        'streakShieldUsedMonth': _p.getInt('streak_shield_used_month') ?? 0,
        'lastDailyDate': today,
        'todayPoints': _p.getInt('daily_points_$today') ?? 0,
        'todayCategories': todayCategories,
        'categories': categories,
        'highScores': highScores,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  static Future<void> clearOnLogout() async {
    await _clearStatsLocal();
  }

  static Future<void> _clearStatsLocal() async {
    final keysToRemove = _p.getKeys().where((key) =>
        key.startsWith('stat_') ||
        key.startsWith('daily_') ||
        key.startsWith('streak_') ||
        key.startsWith('high_'));

    for (final key in keysToRemove.toList()) {
      await _p.remove(key);
    }
  }

  static const List<String> _allCategoryIds = [
    'find_province', 'guess_province', 'metropolitan',
    'plateau', 'mountain', 'plain', 'pass', 'coastal', 'soil', 'vegetation',
    'lake', 'river', 'gulf',
    'mine', 'agriculture',
  ];

  // ════════ EN YÜKSEK PUAN ════════

  static String _highScoreKey(String categoryId, String speedName) =>
      'high_${categoryId}_$speedName';

  static int getHighScore(String categoryId, String speedName) {
    return _p.getInt(_highScoreKey(categoryId, speedName)) ?? 0;
  }

  static int getBestScore(String categoryId) {
    int best = 0;
    for (final speed in ['slow', 'medium', 'fast']) {
      final s = getHighScore(categoryId, speed);
      if (s > best) best = s;
    }
    return best;
  }

  static Future<bool> saveHighScore(
      String categoryId, String speedName, int score) async {
    final key = _highScoreKey(categoryId, speedName);
    final current = _p.getInt(key) ?? 0;
    if (score > current) {
      await _p.setInt(key, score);
      await _syncToCloud();
      return true;
    }
    return false;
  }

  // ════════ GENEL İSTATİSTİKLER ════════

  static int get totalQuizzesPlayed => _p.getInt('stat_total_quizzes') ?? 0;
  static int get totalCorrectAnswers => _p.getInt('stat_total_correct') ?? 0;
  static int get totalWrongAnswers => _p.getInt('stat_total_wrong') ?? 0;
  static int get totalPoints => _p.getInt('stat_total_points') ?? 0;
  static int get totalDiamonds => _p.getInt('stat_total_diamonds') ?? 0;
  static int get totalPrestige => _p.getInt('stat_total_prestige') ?? 0;

  static int get totalAnswers => totalCorrectAnswers + totalWrongAnswers;
  static double get accuracy =>
      totalAnswers > 0 ? totalCorrectAnswers / totalAnswers * 100 : 0;

  static Future<bool> recordQuizResult({
    required int correctCount,
    required int wrongCount,
    required int points,
    required String categoryId,
  }) async {
    await _p.setInt('stat_total_quizzes', totalQuizzesPlayed + 1);
    await _p.setInt('stat_total_correct', totalCorrectAnswers + correctCount);
    await _p.setInt('stat_total_wrong', totalWrongAnswers + wrongCount);
    await _p.setInt('stat_total_points', totalPoints + points);

    final catKey = 'stat_cat_${categoryId}_played';
    await _p.setInt(catKey, (_p.getInt(catKey) ?? 0) + 1);
    await _p.setInt('stat_cat_${categoryId}_correct',
        (_p.getInt('stat_cat_${categoryId}_correct') ?? 0) + correctCount);
    await _p.setInt('stat_cat_${categoryId}_wrong',
        (_p.getInt('stat_cat_${categoryId}_wrong') ?? 0) + wrongCount);

    final today = _todayKey;
    final cats = todayCategories;
    final isNewCategory = !cats.contains(categoryId);
    bool countedForDaily = false;

    if (isNewCategory && !dailyGoalReached) {
      cats.add(categoryId);
      await _p.setString('daily_cats_$today', jsonEncode(cats));

      if (PremiumManager().isPremium) {
        final dailyPointsKey = 'daily_points_$today';
        await _p.setInt(dailyPointsKey, (_p.getInt(dailyPointsKey) ?? 0) + points);
      }

      countedForDaily = true;

      if (cats.length >= dailyGoal) {
        await _completeDailyGoal(today);
        NotificationManager().cancelDailyReminder();
      }
    }

    await _syncToCloud();
    return countedForDaily;
  }

  static int getCategoryPlayed(String categoryId) =>
      _p.getInt('stat_cat_${categoryId}_played') ?? 0;
  static int getCategoryCorrect(String categoryId) =>
      _p.getInt('stat_cat_${categoryId}_correct') ?? 0;
  static int getCategoryWrong(String categoryId) =>
      _p.getInt('stat_cat_${categoryId}_wrong') ?? 0;
  static double getCategoryAccuracy(String categoryId) {
    final total = getCategoryCorrect(categoryId) + getCategoryWrong(categoryId);
    return total > 0 ? getCategoryCorrect(categoryId) / total * 100 : 0;
  }

  // ════════ GÜNLÜK HEDEF & STREAK ════════

  static const int dailyGoal = 3;

  static String get _todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static List<String> get todayCategories {
    final raw = _p.getString('daily_cats_$_todayKey') ?? '[]';
    try {
      return List<String>.from(jsonDecode(raw));
    } catch (_) {
      return [];
    }
  }

  static int get todayQuizCount => todayCategories.length;
  static bool get dailyGoalReached => todayQuizCount >= dailyGoal;
  static int get currentStreak => _p.getInt('streak_current') ?? 0;
  static int get longestStreak => _p.getInt('streak_longest') ?? 0;
  static int get todayDiamondPoints => _p.getInt('daily_points_$_todayKey') ?? 0;

  static Future<void> _completeDailyGoal(String today) async {
    final lastStreakDate = _p.getString('streak_last_date') ?? '';
    final yesterday = _yesterdayKey;

    int streak = currentStreak;
    if (lastStreakDate == yesterday) {
      streak += 1;
    } else if (lastStreakDate == today) {
      return;
    } else {
      streak = 1;
    }

    await _p.setInt('streak_current', streak);
    await _p.setString('streak_last_date', today);
    if (streak > longestStreak) {
      await _p.setInt('streak_longest', streak);
    }

    if (PremiumManager().isPremium) {
      final dailyPoints = _p.getInt('daily_points_$today') ?? 0;
      if (dailyPoints > 0) {
        await _p.setInt('stat_total_diamonds', totalDiamonds + dailyPoints);
        try {
          await LeaderboardService().addDailyPoints(dailyPoints);
        } catch (_) {}
      }
    }
  }

  static String get _yesterdayKey {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return '${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}';
  }

  static Future<void> resetAll() async {
    await _p.clear();
  }
}