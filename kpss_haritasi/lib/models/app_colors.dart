import 'package:flutter/material.dart';

/// Uygulama genelinde kullanılan renkler — dark ve light tema
class AppColors {
  final bool isDark;

  const AppColors._({required this.isDark});

  static const dark = AppColors._(isDark: true);
  static const light = AppColors._(isDark: false);

  // ─── Ana arka planlar ───
  Color get scaffoldBg => isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
  Color get cardBg => isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);
  Color get surfaceBg => isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

  // ─── Metin ───
  Color get textPrimary => isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
  Color get textSecondary => isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color get textMuted => isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

  // ─── Kenarlıklar ───
  Color get border => isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  Color get borderLight => isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);

  // ─── Accent ───
  Color get accent => const Color(0xFFF59E0B); // Amber — her iki temada aynı
  Color get accentDark => const Color(0xFFD97706);

  // ─── Harita ───
  Color get mapProvinceFill => isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
  Color get mapProvinceStroke => isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8);
  Color get mapBgFill => isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
  Color get mapBgStroke => isDark ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1);
  Color get mapHighlightedStroke => isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
  Color get mapHover => isDark
      ? const Color(0xFF3B82F6).withValues(alpha: 0.6)
      : const Color(0xFF3B82F6).withValues(alpha: 0.3);

  // ─── Doğru / Yanlış ───
  Color get correct => const Color(0xFF22C55E);
  Color get correctBg => isDark
      ? const Color(0xFF166534).withValues(alpha: 0.4)
      : const Color(0xFF22C55E).withValues(alpha: 0.15);
  Color get wrong => const Color(0xFFEF4444);
  Color get wrongBg => isDark
      ? const Color(0xFF991B1B).withValues(alpha: 0.3)
      : const Color(0xFFEF4444).withValues(alpha: 0.1);

  // ─── Dot renkleri (MapItem) ───
  Color get dotCorrect => const Color(0xFF39FF14); // Cırtlak yeşil
  Color get dotCorrectDark => const Color(0xFF2BD910);
  Color get dotRevealed => const Color(0xFFF59E0B); // Turuncu
  Color get dotRevealedDark => const Color(0xFFD97706);
  Color get dotRevealedLabel => const Color(0xFFFBBF24);

  // ─── Bottom sheet ───
  Color get sheetBg => isDark ? const Color(0xFF1E293B) : const Color(0xFFFFFFFF);
  Color get sheetItemBg => isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);

  // ─── Timer ───
  Color get timerBg => isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

  // ─── Feedback ───
  Color get correctFeedbackBg => isDark
      ? const Color(0xFF22C55E).withValues(alpha: 0.15)
      : const Color(0xFF22C55E).withValues(alpha: 0.1);
  Color get correctFeedbackBorder => isDark
      ? const Color(0xFF22C55E).withValues(alpha: 0.3)
      : const Color(0xFF22C55E).withValues(alpha: 0.3);
  Color get wrongFeedbackBg => isDark
      ? const Color(0xFFEF4444).withValues(alpha: 0.15)
      : const Color(0xFFEF4444).withValues(alpha: 0.1);
  Color get wrongFeedbackBorder => isDark
      ? const Color(0xFFEF4444).withValues(alpha: 0.3)
      : const Color(0xFFEF4444).withValues(alpha: 0.3);

  // ─── Gradient buton metin renkleri (dark buton üstü) ───
  Color get onGradientDark => const Color(0xFF0F172A);
  Color get onGradientLight => const Color(0xFFFFFFFF);

  // ─── Status bar ───
  Brightness get statusBarBrightness => isDark ? Brightness.light : Brightness.dark;
}