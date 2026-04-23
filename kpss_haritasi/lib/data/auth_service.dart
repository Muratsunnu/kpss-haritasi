import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;
  AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String? _cachedUsername;

  Future<String?> getUsername() async {
    if (_cachedUsername != null) return _cachedUsername;
    final user = currentUser;
    if (user == null) return null;
    final doc = await _db.collection('users').doc(user.uid).get();
    if (doc.exists) _cachedUsername = doc.data()?['username'] as String?;
    return _cachedUsername;
  }

  Future<bool> isUsernameAvailable(String username) async {
    final doc = await _db.collection('usernames').doc(username.toLowerCase()).get();
    return !doc.exists;
  }

  Future<void> saveUsername(String username) async {
    final user = currentUser;
    if (user == null) return;
    final batch = _db.batch();
    batch.set(_db.collection('users').doc(user.uid), {
      'username': username, 'createdAt': FieldValue.serverTimestamp(), 'badges': <String>[], 'isPremium': false,
    });
    batch.set(_db.collection('usernames').doc(username.toLowerCase()), {'uid': user.uid});
    await batch.commit();
    _cachedUsername = username;
  }

  Future<bool> hasProfile() async {
    final user = currentUser;
    if (user == null) return false;
    final doc = await _db.collection('users').doc(user.uid).get();
    return doc.exists && doc.data()?['username'] != null;
  }

  Future<UserCredential> registerWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> loginWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  final GoogleSignIn _google = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    final googleUser = await _google.signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    return await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    _cachedUsername = null;
    await _google.signOut();
    await _auth.signOut();
  }

  Future<List<String>> getBadges() async {
    final user = currentUser;
    if (user == null) return [];
    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) return [];
    return List<String>.from(doc.data()?['badges'] ?? []);
  }

  /// Rozet ekle (tekrar eklenmez)
  Future<void> addBadge(String badge) async {
    final user = currentUser;
    if (user == null) return;
    await _db.collection('users').doc(user.uid).update({
      'badges': FieldValue.arrayUnion([badge]),
    });
  }
}