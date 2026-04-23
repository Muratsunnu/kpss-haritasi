import 'package:flutter/material.dart';
import '../data/auth_service.dart';
import '../data/leaderboard_service.dart';
import '../data/premium_manager.dart';
import '../models/app_colors.dart';
import '../models/theme_notifier.dart';
import 'premium_screen.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});
  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<LeaderboardEntry> _topPlayers = [];
  LeaderboardEntry? _myRank;
  bool _loading = true;
  final _auth = AuthService();

  @override
  void initState() { super.initState(); _loadData(); }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final result = await LeaderboardService().getLeaderboard();
      if (mounted) setState(() { _topPlayers = result.top; _myRank = result.me; _loading = false; });
    } catch (e) {
      debugPrint('LEADERBOARD ERROR: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  String get _currentMonth {
    final now = DateTime.now();
    const months = ['', 'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran', 'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];
    return '${months[now.month]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final c = ThemeScope.colorsOf(context);
    final currentUid = _auth.currentUser?.uid;
    return Scaffold(backgroundColor: c.scaffoldBg, body: SafeArea(
      child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 500),
        child: Column(children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context),
                child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(border: Border.all(color: c.border), borderRadius: BorderRadius.circular(8)),
                  child: Text('← Geri', style: TextStyle(color: c.textSecondary, fontSize: 12)))),
              const Spacer(),
              Text('Sıralama', style: TextStyle(color: c.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
              const Spacer(), const SizedBox(width: 60),
            ])),
          Container(margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: c.accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
            child: Text('🏆 $_currentMonth', style: TextStyle(color: c.accent, fontSize: 13, fontWeight: FontWeight.w600))),
          const SizedBox(height: 16),
          Expanded(child: !PremiumManager().isPremium ? _buildPremiumGate(c)
            : _loading ? Center(child: CircularProgressIndicator(color: c.accent))
            : _topPlayers.isEmpty ? Center(child: Text('Henüz sıralama yok\nGünlük serini tamamla!', textAlign: TextAlign.center, style: TextStyle(color: c.textSecondary, fontSize: 14)))
            : RefreshIndicator(onRefresh: _loadData, color: c.accent,
                child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _topPlayers.length + (_showMyRankSeparately ? 2 : 0),
                  itemBuilder: (context, index) {
                    if (index < _topPlayers.length) return _buildPlayerRow(_topPlayers[index], c, currentUid);
                    if (index == _topPlayers.length && _showMyRankSeparately) {
                      return Padding(padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(children: [
                          Expanded(child: Container(height: 1, color: c.border)),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('Senin sıran', style: TextStyle(color: c.textMuted, fontSize: 11))),
                          Expanded(child: Container(height: 1, color: c.border)),
                        ]));
                    }
                    if (_showMyRankSeparately && _myRank != null) return _buildPlayerRow(_myRank!, c, currentUid);
                    return const SizedBox.shrink();
                  }))),
        ])))),
    );
  }

  bool get _showMyRankSeparately => _myRank != null && _myRank!.rank > 10;

  Widget _buildPlayerRow(LeaderboardEntry entry, AppColors c, String? currentUid) {
    final isMe = entry.uid == currentUid;
    final rankIcon = _getRankIcon(entry.rank);
    return Container(margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ? c.accent.withValues(alpha: 0.1) : c.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isMe ? c.accent.withValues(alpha: 0.3) : c.border)),
      child: Row(children: [
        SizedBox(width: 36, child: rankIcon != null
          ? Text(rankIcon, style: const TextStyle(fontSize: 22))
          : Text('${entry.rank}', textAlign: TextAlign.center,
              style: TextStyle(color: c.textSecondary, fontSize: 16, fontWeight: FontWeight.w700))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(isMe ? '${entry.username} (Sen)' : entry.username,
            style: TextStyle(color: isMe ? c.accent : c.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
          if (entry.rank <= 10)
            Text(_getBadgeText(entry.rank), style: TextStyle(color: c.textMuted, fontSize: 10)),
        ])),
        Text('${entry.monthlyPoints}', style: TextStyle(color: c.accent, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(width: 4),
        Text('puan', style: TextStyle(color: c.textMuted, fontSize: 10)),
      ]));
  }

  String _getBadgeText(int rank) {
    if (rank == 1) return '🥇 1.lik Rozeti';
    if (rank == 2) return '🥈 2.lik Rozeti';
    if (rank == 3) return '🥉 3.lük Rozeti';
    return '🏅 Top 10 Rozeti';
  }

  String? _getRankIcon(int rank) {
    switch (rank) { case 1: return '🥇'; case 2: return '🥈'; case 3: return '🥉'; default: return null; }
  }

  Widget _buildPremiumGate(AppColors c) {
    return Center(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('🔒', style: TextStyle(fontSize: 48)), const SizedBox(height: 16),
        Text('Sıralama Tablosu', style: TextStyle(color: c.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Aylık sıralamaya katılmak ve\nrakiplerini görmek için Premium al!',
          textAlign: TextAlign.center, style: TextStyle(color: c.textSecondary, fontSize: 14)),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen())); if (mounted) setState(() {}); },
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF818CF8), Color(0xFF6366F1)]),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: const Color(0xFF818CF8).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 4))]),
            child: const Text('💎  Premium Al', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)))),
      ])));
  }
}