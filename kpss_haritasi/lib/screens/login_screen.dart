import 'package:flutter/material.dart';
import '../data/auth_service.dart';
import '../models/app_colors.dart';
import '../models/theme_notifier.dart';
import 'register_screen.dart';
import 'email_verify_screen.dart';
import 'menu_screen.dart';
import 'username_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'E-posta ve şifre gerekli');
      return;
    }

    setState(() { _loading = true; _error = null; });
    try {
      final credential = await _auth.loginWithEmail(email, password);
      if (!mounted) return;

      // Doğrulanmamış mail — doğrulama ekranına
      final user = credential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        if (!mounted) return;
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const EmailVerifyScreen()));
        return;
      }

      _goToApp();
    } on Exception catch (e) {
      setState(() => _error = _parseError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await _auth.signInWithGoogle();
      if (result == null) {
        setState(() => _loading = false);
        return; // İptal edildi
      }
      if (!mounted) return;

      // Google ile ilk giriş — kullanıcı adı seçmesi lazım
      final hasProfile = await _auth.hasProfile();
      if (!mounted) return;

      if (hasProfile) {
        _goToApp();
      } else {
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const UsernameScreen()));
      }
    } on Exception catch (e) {
      setState(() => _error = _parseError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goToApp() {
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (_) => const MenuScreen()),
      (route) => false);
  }

  String _parseError(Exception e) {
    final msg = e.toString();
    if (msg.contains('user-not-found')) return 'Hesap bulunamadı';
    if (msg.contains('wrong-password') || msg.contains('invalid-credential')) return 'Şifre hatalı';
    if (msg.contains('invalid-email')) return 'Geçersiz e-posta';
    if (msg.contains('too-many-requests')) return 'Çok fazla deneme, biraz bekle';
    if (msg.contains('network')) return 'İnternet bağlantısını kontrol et';
    return 'Giriş başarısız';
  }

  @override
  Widget build(BuildContext context) {
    final c = ThemeScope.colorsOf(context);

    return Scaffold(
      backgroundColor: c.scaffoldBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Text('KPSS HARİTASI',
                    style: TextStyle(fontSize: 13, letterSpacing: 6, color: c.accent, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Coğrafya Quiz',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: c.textPrimary, letterSpacing: -1)),
                  const SizedBox(height: 40),

                  // E-posta
                  _InputField(
                    controller: _emailController,
                    hint: 'E-posta',
                    icon: Icons.email_outlined,
                    colors: c,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),

                  // Şifre
                  _InputField(
                    controller: _passwordController,
                    hint: 'Şifre',
                    icon: Icons.lock_outline,
                    colors: c,
                    obscure: true,
                  ),
                  const SizedBox(height: 8),

                  // Hata
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(_error!,
                        style: TextStyle(color: c.wrong, fontSize: 13),
                        textAlign: TextAlign.center),
                    ),

                  const SizedBox(height: 8),

                  // Giriş butonu
                  GestureDetector(
                    onTap: _loading ? null : _loginWithEmail,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [c.accent, c.accentDark]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: _loading
                        ? SizedBox(width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: c.onGradientDark))
                        : Text('Giriş Yap',
                            style: TextStyle(color: c.onGradientDark, fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Ayırıcı
                  Row(children: [
                    Expanded(child: Container(height: 1, color: c.border)),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('veya', style: TextStyle(color: c.textMuted, fontSize: 12))),
                    Expanded(child: Container(height: 1, color: c.border)),
                  ]),
                  const SizedBox(height: 16),

                  // Google ile giriş
                  GestureDetector(
                    onTap: _loading ? null : _loginWithGoogle,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: c.cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: c.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('G', style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700,
                            color: c.textPrimary)),
                          const SizedBox(width: 10),
                          Text('Google ile Giriş Yap',
                            style: TextStyle(color: c.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Kayıt ol linki
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(text: 'Hesabın yok mu? ', style: TextStyle(color: c.textSecondary, fontSize: 13)),
                        TextSpan(text: 'Kayıt Ol', style: TextStyle(color: c.accent, fontSize: 13, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final AppColors colors;
  final bool obscure;
  final TextInputType? keyboardType;

  const _InputField({
    required this.controller, required this.hint, required this.icon,
    required this.colors, this.obscure = false, this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(color: colors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: colors.textMuted, fontSize: 14),
        prefixIcon: Icon(icon, color: colors.textMuted, size: 20),
        filled: true,
        fillColor: colors.cardBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.accent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}