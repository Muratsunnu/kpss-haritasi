import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/auth_service.dart';
import '../models/theme_notifier.dart';
import 'username_screen.dart';
import 'login_screen.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  Timer? _timer;
  bool _canResend = false;
  int _resendCooldown = 60;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _startPolling();
    _startCooldown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  /// Her 3 saniyede mail doğrulandı mı kontrol et
  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) { timer.cancel(); return; }

      await user.reload();
      final refreshed = FirebaseAuth.instance.currentUser;

      if (refreshed != null && refreshed.emailVerified) {
        timer.cancel();
        if (!mounted) return;
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const UsernameScreen()));
      }
    });
  }

  void _startCooldown() {
    _canResend = false;
    _resendCooldown = 60;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      setState(() {
        _resendCooldown--;
        if (_resendCooldown <= 0) {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _resendEmail() async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      _startCooldown();
    } catch (_) {}
  }

  Future<void> _cancel() async {
    // Hesabı sil ve login'e dön
    try {
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (_) {}
    await AuthService().signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final c = ThemeScope.colorsOf(context);
    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: c.scaffoldBg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mail ikonu
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      color: c.accent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.mark_email_unread_rounded, color: c.accent, size: 36),
                  ),
                  const SizedBox(height: 24),

                  Text('E-postanı Doğrula',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: c.textPrimary)),
                  const SizedBox(height: 12),

                  Text('Doğrulama linki gönderildi:',
                    style: TextStyle(color: c.textSecondary, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(email,
                    style: TextStyle(color: c.accent, fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 20),

                  // Bekleme animasyonu
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: c.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: c.border),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: c.accent)),
                        const SizedBox(width: 12),
                        Expanded(child: Text('Mailinizi doğrulamanız bekleniyor...',
                          style: TextStyle(color: c.textSecondary, fontSize: 13))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tekrar gönder
                  GestureDetector(
                    onTap: _canResend ? _resendEmail : null,
                    child: Text(
                      _canResend
                        ? 'Tekrar Gönder'
                        : 'Tekrar gönder (${_resendCooldown}s)',
                      style: TextStyle(
                        color: _canResend ? c.accent : c.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // İptal
                  GestureDetector(
                    onTap: _cancel,
                    child: Text('İptal Et',
                      style: TextStyle(color: c.wrong, fontSize: 13, fontWeight: FontWeight.w500)),
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