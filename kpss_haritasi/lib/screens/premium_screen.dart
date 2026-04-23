import 'dart:async';
import 'package:flutter/material.dart';
import '../data/premium_manager.dart';
import '../models/app_colors.dart';
import '../models/theme_notifier.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});
  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _purchase() async {
    setState(() { _loading = true; _error = null; });
    try {
      final success = await PremiumManager().buyPremium();
      if (success && mounted) {
        _startPurchaseCheck();
      } else if (!success && mounted) {
        setState(() => _error = 'Satın alma başlatılamadı');
      }
    } catch (e) {
      if (mounted) setState(() => _error = 'Bir hata oluştu');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Timer? _purchaseCheckTimer;

  void _startPurchaseCheck() {
    _purchaseCheckTimer?.cancel();
    _purchaseCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (PremiumManager().isPremium) {
        timer.cancel();
        if (mounted) _showRestartDialog();
      }
    });
    // 30 saniye sonra timer'ı durdur (timeout)
    Future.delayed(const Duration(seconds: 30), () {
      _purchaseCheckTimer?.cancel();
    });
  }

  @override
  void dispose() {
    _purchaseCheckTimer?.cancel();
    super.dispose();
  }

  void _showRestartDialog() {
    showDialog(context: context, barrierDismissible: false, builder: (ctx) {
      final sc = ThemeScope.colorsOf(ctx);
      return Dialog(
        backgroundColor: sc.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('🎉', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('Satın Alım Tamamlandı!', style: TextStyle(color: sc.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Text('Premium\'u aktifleştirmek için uygulamayı kapatıp tekrar açın.',
            style: TextStyle(color: sc.textSecondary, fontSize: 14), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () { Navigator.pop(ctx); Navigator.pop(context); },
            child: Container(
              width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF818CF8), Color(0xFF6366F1)]),
                borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: const Text('Tamam', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ])),
      );
    });
  }

  Future<void> _restore() async {
    setState(() { _loading = true; _error = null; });
    await PremiumManager().restorePurchases();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      if (PremiumManager().isPremium) {
        Navigator.pop(context, true);
      } else {
        setState(() { _error = 'Satın alma bulunamadı'; _loading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = ThemeScope.colorsOf(context);

    if (PremiumManager().isPremium) {
      return Scaffold(backgroundColor: c.scaffoldBg, body: SafeArea(
        child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('💎', style: TextStyle(fontSize: 56)), const SizedBox(height: 16),
          Text('Premium Aktif!', style: TextStyle(color: c.textPrimary, fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Tüm premium özellikler açık', style: TextStyle(color: c.textSecondary, fontSize: 14)),
          const SizedBox(height: 32),
          GestureDetector(onTap: () => Navigator.pop(context),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: c.border)),
              child: Text('Geri Dön', style: TextStyle(color: c.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)))),
        ])),
      ));
    }

    return Scaffold(backgroundColor: c.scaffoldBg, body: SafeArea(
      child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24),
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 400), child: Column(children: [
          Align(alignment: Alignment.centerLeft, child: GestureDetector(onTap: () => Navigator.pop(context),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(border: Border.all(color: c.border), borderRadius: BorderRadius.circular(8)),
              child: Text('← Geri', style: TextStyle(color: c.textSecondary, fontSize: 12))))),
          const SizedBox(height: 24),
          Container(width: 80, height: 80,
            decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF818CF8), Color(0xFF6366F1)]), shape: BoxShape.circle),
            child: const Center(child: Text('💎', style: TextStyle(fontSize: 40)))),
          const SizedBox(height: 16),
          Text('KPSS Haritası', style: TextStyle(color: c.textMuted, fontSize: 12, letterSpacing: 3)),
          const SizedBox(height: 4),
          Text('Premium', style: TextStyle(color: c.textPrimary, fontSize: 32, fontWeight: FontWeight.w800)),
          const SizedBox(height: 24),
          _buildFeature('🔓', 'Tüm Kategoriler', 'Dağlar, Göller, Madenler, Nehirler, Körfezler', c),
          _buildFeature('🏆', 'Sıralama Tablosu', 'Aylık sıralamaya katıl, rakiplerini geç', c),
          _buildFeature('❤️', 'Sınırsız Can', 'Bekleme yok, istediğin kadar oyna', c),
          _buildFeature('🚫', 'Reklamsız Deneyim', 'Tüm reklamlar kaldırılır', c),
          _buildFeature('💎', 'Ömür Boyu Erişim', 'Tek seferlik ödeme, süresiz premium', c),
          const SizedBox(height: 24),
          if (_error != null) Padding(padding: const EdgeInsets.only(bottom: 12),
            child: Text(_error!, style: TextStyle(color: c.wrong, fontSize: 13), textAlign: TextAlign.center)),
          GestureDetector(onTap: _loading ? null : _purchase,
            child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF818CF8), Color(0xFF6366F1)]),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: const Color(0xFF818CF8).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 4))]),
              alignment: Alignment.center,
              child: _loading
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('💎  Premium Al — 59,90 ₺', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)))),
          const SizedBox(height: 12),
          GestureDetector(onTap: _loading ? null : _restore,
            child: Text('Satın almayı geri yükle', style: TextStyle(color: c.textMuted, fontSize: 12, decoration: TextDecoration.underline))),
        ])))),
    ));
  }

  Widget _buildFeature(String emoji, String title, String desc, AppColors c) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: c.cardBg, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 24)), const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(color: c.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
          Text(desc, style: TextStyle(color: c.textSecondary, fontSize: 12)),
        ])),
      ]),
    ));
  }
}