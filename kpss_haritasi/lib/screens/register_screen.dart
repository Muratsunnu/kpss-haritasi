import 'package:flutter/material.dart';
import '../data/auth_service.dart';
import '../models/app_colors.dart';
import '../models/theme_notifier.dart';
import 'email_verify_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Tüm alanları doldur');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'Şifre en az 6 karakter olmalı');
      return;
    }

    setState(() { _loading = true; _error = null; });
    try {
      final credential = await _auth.registerWithEmail(email, password);
      // Doğrulama maili gönder
      await credential.user?.sendEmailVerification();
      if (!mounted) return;
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const EmailVerifyScreen()));
    } on Exception catch (e) {
      setState(() => _error = _parseError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _parseError(Exception e) {
    final msg = e.toString();
    if (msg.contains('email-already-in-use')) return 'Bu e-posta zaten kayıtlı';
    if (msg.contains('weak-password')) return 'Şifre çok zayıf';
    if (msg.contains('invalid-email')) return 'Geçersiz e-posta';
    if (msg.contains('network')) return 'İnternet bağlantısını kontrol et';
    return 'Kayıt başarısız';
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
                  Text('Hesap Oluştur',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: c.textPrimary)),
                  const SizedBox(height: 8),
                  Text('Sıralamaya katıl, rakiplerini geç!',
                    style: TextStyle(fontSize: 14, color: c.textSecondary)),
                  const SizedBox(height: 32),

                  _buildField(_emailController, 'E-posta', Icons.email_outlined, c,
                    keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12),

                  _buildField(_passwordController, 'Şifre (min 6 karakter)', Icons.lock_outline, c,
                    obscure: true),

                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(_error!,
                        style: TextStyle(color: c.wrong, fontSize: 13),
                        textAlign: TextAlign.center)),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: _loading ? null : _register,
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
                        : Text('Kayıt Ol',
                            style: TextStyle(color: c.onGradientDark, fontSize: 15, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(text: 'Zaten hesabın var mı? ', style: TextStyle(color: c.textSecondary, fontSize: 13)),
                        TextSpan(text: 'Giriş Yap', style: TextStyle(color: c.accent, fontSize: 13, fontWeight: FontWeight.w700)),
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

  Widget _buildField(TextEditingController controller, String hint, IconData icon, AppColors c,
      {bool obscure = false, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(color: c.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: c.textMuted, fontSize: 14),
        prefixIcon: Icon(icon, color: c.textMuted, size: 20),
        filled: true, fillColor: c.cardBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.accent, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}