import 'package:flutter/material.dart';
import '../data/auth_service.dart';
import '../models/theme_notifier.dart';
import 'menu_screen.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final _controller = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;
  String? _error;
  bool? _available;
  bool _checking = false;

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  Future<void> _check() async {
    final name = _controller.text.trim();
    if (name.length < 3) { setState(() => _available = null); return; }
    setState(() => _checking = true);
    final ok = await _auth.isUsernameAvailable(name);
    if (mounted) setState(() { _available = ok; _checking = false; });
  }

  Future<void> _save() async {
    final name = _controller.text.trim();
    if (name.length < 3) { setState(() => _error = 'En az 3 karakter'); return; }
    final ok = await _auth.isUsernameAvailable(name);
    if (!ok) { setState(() => _error = 'Bu ad alınmış'); return; }

    setState(() { _loading = true; _error = null; });
    try {
      await _auth.saveUsername(name);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const MenuScreen()), (r) => false);
    } catch (e) {
      setState(() => _error = 'Bir hata oluştu');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = ThemeScope.colorsOf(context);

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
                  Text('Hoş Geldin!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: c.textPrimary)),
                  const SizedBox(height: 8),
                  Text('Sıralamada görünecek kullanıcı adını seç',
                    style: TextStyle(fontSize: 14, color: c.textSecondary),
                    textAlign: TextAlign.center),
                  const SizedBox(height: 32),

                  TextField(
                    controller: _controller,
                    onChanged: (_) => _check(),
                    style: TextStyle(color: c.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Kullanıcı adı',
                      hintStyle: TextStyle(color: c.textMuted),
                      prefixIcon: Icon(Icons.person_outline, color: c.textMuted, size: 20),
                      suffixIcon: _checking
                        ? const Padding(padding: EdgeInsets.all(12),
                            child: SizedBox(width: 16, height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2)))
                        : _available == null ? null
                          : Icon(_available! ? Icons.check_circle : Icons.cancel,
                              color: _available! ? c.correct : c.wrong, size: 20),
                      filled: true, fillColor: c.cardBg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.border)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: c.accent, width: 2)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),

                  if (_error != null)
                    Padding(padding: const EdgeInsets.only(top: 8),
                      child: Text(_error!, style: TextStyle(color: c.wrong, fontSize: 12))),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: _loading ? null : _save,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [c.accent, c.accentDark]),
                        borderRadius: BorderRadius.circular(12)),
                      alignment: Alignment.center,
                      child: _loading
                        ? SizedBox(width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: c.onGradientDark))
                        : Text('Devam Et',
                            style: TextStyle(color: c.onGradientDark, fontSize: 15, fontWeight: FontWeight.w700)),
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