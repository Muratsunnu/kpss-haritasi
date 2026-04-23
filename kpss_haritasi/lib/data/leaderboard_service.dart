import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardEntry {
  final String uid;
  final String username;
  final int monthlyPoints;
  final int rank;
  LeaderboardEntry({required this.uid, required this.username, required this.monthlyPoints, required this.rank});
}

class LeaderboardService {
  static final LeaderboardService _instance = LeaderboardService._();
  factory LeaderboardService() => _instance;
  LeaderboardService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _currentMonthKey {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  String _docId(String uid) => '${_currentMonthKey}_$uid';

  Future<void> addDailyPoints(int points) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final docRef = _db.collection('leaderboard').doc(_docId(user.uid));
    final doc = await docRef.get();
    if (doc.exists) {
      await docRef.update({'monthlyPoints': FieldValue.increment(points), 'updatedAt': FieldValue.serverTimestamp()});
    } else {
      final userDoc = await _db.collection('users').doc(user.uid).get();
      final username = userDoc.data()?['username'] ?? 'Anonim';
      await docRef.set({'uid': user.uid, 'username': username, 'month': _currentMonthKey, 'monthlyPoints': points, 'updatedAt': FieldValue.serverTimestamp()});
    }
  }

  Future<({List<LeaderboardEntry> top, LeaderboardEntry? me})> getLeaderboard() async {
    final user = _auth.currentUser;
    final query = await _db.collection('leaderboard').where('month', isEqualTo: _currentMonthKey).get();
    final allDocs = query.docs.map((doc) {
      final data = doc.data();
      return _TempEntry(uid: data['uid'] ?? '', username: data['username'] ?? 'Anonim', monthlyPoints: data['monthlyPoints'] ?? 0);
    }).toList();
    allDocs.sort((a, b) => b.monthlyPoints.compareTo(a.monthlyPoints));

    final top = <LeaderboardEntry>[];
    for (int i = 0; i < allDocs.length && i < 10; i++) {
      top.add(LeaderboardEntry(uid: allDocs[i].uid, username: allDocs[i].username, monthlyPoints: allDocs[i].monthlyPoints, rank: i + 1));
    }

    LeaderboardEntry? me;
    if (user != null) {
      for (int i = 0; i < allDocs.length; i++) {
        if (allDocs[i].uid == user.uid) {
          me = LeaderboardEntry(uid: allDocs[i].uid, username: allDocs[i].username, monthlyPoints: allDocs[i].monthlyPoints, rank: i + 1);
          break;
        }
      }
    }
    return (top: top, me: me);
  }

  Future<int> getMyMonthlyPoints() async {
    final user = _auth.currentUser;
    if (user == null) return 0;
    final doc = await _db.collection('leaderboard').doc(_docId(user.uid)).get();
    if (!doc.exists) return 0;
    return doc.data()?['monthlyPoints'] ?? 0;
  }

  /// Geçen ayda kullanıcının sıralamasını döndürür (0 = listede yok)
  Future<int> getPreviousMonthRank() async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    final now = DateTime.now();
    final prevMonth = DateTime(now.year, now.month - 1, 1);
    final prevKey = '${prevMonth.year}-${prevMonth.month.toString().padLeft(2, '0')}';

    final query = await _db.collection('leaderboard').where('month', isEqualTo: prevKey).get();
    final allDocs = query.docs.map((doc) {
      final data = doc.data();
      return _TempEntry(uid: data['uid'] ?? '', username: data['username'] ?? '', monthlyPoints: data['monthlyPoints'] ?? 0);
    }).toList();
    allDocs.sort((a, b) => b.monthlyPoints.compareTo(a.monthlyPoints));

    for (int i = 0; i < allDocs.length; i++) {
      if (allDocs[i].uid == user.uid) return i + 1;
    }
    return 0;
  }
}

class _TempEntry {
  final String uid;
  final String username;
  final int monthlyPoints;
  _TempEntry({required this.uid, required this.username, required this.monthlyPoints});
}