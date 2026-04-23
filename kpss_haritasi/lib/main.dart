import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'data/stats_manager.dart';
import 'data/sound_manager.dart';
import 'data/notification_manager.dart';
import 'data/ad_manager.dart';
import 'data/premium_manager.dart';
import 'data/life_manager.dart';
import 'data/auth_service.dart';
import 'models/theme_notifier.dart';
import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/username_screen.dart';
import 'screens/email_verify_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Sadece kritik init'ler — splash screen'i hızlı geç
  await StatsManager.init();

  // Ağır olmayan init'ler paralel çalışsın
  await Future.wait([
    SoundManager().init(),
    PremiumManager().init(),
    LifeManager().init(),
  ]);

  runApp(const KpssHaritasiApp());

  // Splash kapandıktan SONRA ağır init'ler (reklam yükleme, bildirim)
  _initLazy();
}

/// Splash sonrası arka planda yüklenen işler
void _initLazy() async {
  await AdManager().init();
  await NotificationManager().init();
  await NotificationManager().requestPermission();
  await NotificationManager().scheduleDailyNotification();
}

class KpssHaritasiApp extends StatefulWidget {
  const KpssHaritasiApp({super.key});

  @override
  State<KpssHaritasiApp> createState() => _KpssHaritasiAppState();
}

class _KpssHaritasiAppState extends State<KpssHaritasiApp> {
  final _themeNotifier = ThemeNotifier();

  @override
  void dispose() { _themeNotifier.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      notifier: _themeNotifier,
      child: AnimatedBuilder(
        animation: _themeNotifier,
        builder: (context, _) {
          final isDark = _themeNotifier.isDark;
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          ));
          return MaterialApp(
            title: 'KPSS Haritası',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: isDark ? Brightness.dark : Brightness.light,
              scaffoldBackgroundColor: _themeNotifier.colors.scaffoldBg,
            ),
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}

/// Giriş durumuna göre yönlendirme — hesap değişince bilgileri yeniden çeker
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  String? _lastUid;

  /// Hesap değiştiğinde veya ilk girişte kullanıcı bilgilerini yükle
  Future<bool> _initUser(User user) async {
    // Farklı hesaba geçildiyse eski cache'i temizle
    if (_lastUid != null && _lastUid != user.uid) {
      await StatsManager.clearOnLogout();
      await PremiumManager().clearLocal();
      await LifeManager().reset();
    }
    _lastUid = user.uid;

    final hasProfile = await AuthService().hasProfile();
    if (hasProfile) {
      await StatsManager.loadFromCloud();
      await PremiumManager().checkCloudPremium();
    }
    return hasProfile;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          final c = ThemeScope.colorsOf(context);
          return Scaffold(
            backgroundColor: c.scaffoldBg,
            body: Center(child: CircularProgressIndicator(color: c.accent)),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          // Çıkış yapıldıysa eski uid'yi sıfırla
          _lastUid = null;
          return const LoginScreen();
        }

        // Google ile giriş yapanlar zaten doğrulanmış sayılır
        final isEmailProvider = user.providerData.any((p) => p.providerId == 'password');
        if (isEmailProvider && !user.emailVerified) {
          return const EmailVerifyScreen();
        }

        // Giriş yapmış + doğrulanmış — profil kontrol + cloud sync
        return FutureBuilder<bool>(
          // Her auth değişiminde uid değişir → yeni Future oluşur → tekrar çekilir
          key: ValueKey(user.uid),
          future: _initUser(user),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              final c = ThemeScope.colorsOf(context);
              return Scaffold(
                backgroundColor: c.scaffoldBg,
                body: Center(child: CircularProgressIndicator(color: c.accent)),
              );
            }

            if (profileSnapshot.data == true) {
              return const MenuScreen();
            }

            return const UsernameScreen();
          },
        );
      },
    );
  }
}