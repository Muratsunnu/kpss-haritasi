import 'package:flutter/material.dart';
import '../models/province.dart';
import '../models/map_item.dart';
import '../models/app_colors.dart';

class MapPainter extends CustomPainter {
  final List<Province> provinces;
  final Size mapSize;
  final AppColors colors;

  final String? hoveredProvinceId;
  final String? selectedProvinceId;
  final String? correctProvinceId;
  final String? highlightedProvinceId;
  final bool showResult;
  final bool isCorrect;
  final Set<String> answeredCorrect;
  final Set<String> answeredWrong;
  final bool showProvinceLabels;

  final bool itemMode;
  final List<MapItem> items;
  final String? selectedItemId;
  final String? correctItemId;
  final Set<String> itemAnsweredCorrect;
  final Set<String> itemAnsweredWrong;
  final Color itemColor;

  MapPainter({
    required this.provinces,
    required this.mapSize,
    required this.colors,
    this.hoveredProvinceId, this.selectedProvinceId, this.correctProvinceId, this.highlightedProvinceId,
    this.showResult = false, this.isCorrect = false,
    this.answeredCorrect = const {}, this.answeredWrong = const {},
    this.showProvinceLabels = false,
    this.itemMode = false, this.items = const [],
    this.selectedItemId, this.correctItemId,
    this.itemAnsweredCorrect = const {}, this.itemAnsweredWrong = const {},
    this.itemColor = const Color(0xFF3B82F6),
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final province in provinces) {
      final fillPaint = Paint()..style = PaintingStyle.fill;
      final strokePaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.0;

      if (itemMode) {
        fillPaint.color = colors.mapBgFill;
        strokePaint.color = colors.mapBgStroke;
        strokePaint.strokeWidth = 0.5;
      } else {
        fillPaint.color = _getProvinceColor(province);
        strokePaint.color = _getStrokeColor(province);
        strokePaint.strokeWidth = _getStrokeWidth(province);
      }

      canvas.drawPath(province.path, fillPaint);
      canvas.drawPath(province.path, strokePaint);
    }

    // İl isimleri — doğru/yanlış bilinen illerin üzerine yaz
    if (showProvinceLabels && !itemMode) {
      for (final province in provinces) {
        if (answeredCorrect.contains(province.id)) {
          _drawProvinceLabel(canvas, province, colors.correct);
        } else if (answeredWrong.contains(province.id)) {
          _drawProvinceLabel(canvas, province, colors.wrong);
        }
      }
    }

    if (itemMode) {
      for (final item in items) _drawItem(canvas, item);
    }
  }

  void _drawProvinceLabel(Canvas canvas, Province province, Color color) {
    final bounds = province.path.getBounds();
    final center = bounds.center;
    final fontSize = (mapSize.width * 0.012).clamp(5.0, 9.0);

    final tp = TextPainter(
      text: TextSpan(
        text: province.name,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  void _drawItem(Canvas canvas, MapItem item) {
    final center = item.centerOnScreen(mapSize);
    final dotRadius = mapSize.width * 0.015;
    final fillPaint = Paint()..style = PaintingStyle.fill;
    final strokePaint = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5;

    bool showName = false;
    Color labelColor = colors.textSecondary;

    // ── 1. Kalıcı durumlar (önceki sorulardan) ──

    if (itemAnsweredCorrect.contains(item.id)) {
      fillPaint.color = colors.dotCorrect;
      strokePaint.color = colors.dotCorrectDark;
      showName = true;
      labelColor = colors.dotCorrect;
    } else if (itemAnsweredWrong.contains(item.id)) {
      fillPaint.color = colors.dotRevealed;
      strokePaint.color = colors.dotRevealedDark;
      showName = true;
      labelColor = colors.dotRevealedLabel;

    // ── 2. Anlık sonuç gösterimi (şu anki soru) ──

    } else if (showResult && item.id == selectedItemId) {
      if (isCorrect) {
        fillPaint.color = colors.dotCorrect;
        strokePaint.color = colors.textPrimary;
        strokePaint.strokeWidth = 2.5;
        showName = true;
        labelColor = colors.dotCorrect;
      } else {
        fillPaint.color = colors.wrong;
        strokePaint.color = colors.textPrimary;
        strokePaint.strokeWidth = 2.5;
      }
    } else if (showResult && !isCorrect && item.id == correctItemId) {
      fillPaint.color = colors.dotRevealed;
      strokePaint.color = colors.textPrimary;
      strokePaint.strokeWidth = 2.5;
      showName = true;
      labelColor = colors.dotRevealedLabel;

    // ── 3. Normal durum ──

    } else {
      fillPaint.color = itemColor.withValues(alpha: 0.7);
      strokePaint.color = itemColor.withValues(alpha: 0.3);
      strokePaint.strokeWidth = 1.0;
    }

    canvas.drawCircle(center, dotRadius, fillPaint);
    canvas.drawCircle(center, dotRadius, strokePaint);

    if (showName) {
      _drawLabel(canvas, Offset(center.dx, center.dy + dotRadius + 6), item.name, labelColor, 7);
    }
  }

  void _drawLabel(Canvas canvas, Offset center, String text, Color color, double fontSize) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.w600)),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  Color _getProvinceColor(Province province) {
    if (answeredCorrect.contains(province.id)) return colors.correctBg;
    if (answeredWrong.contains(province.id)) return colors.wrongBg;
    if (showResult) {
      if (province.id == correctProvinceId) return colors.correct;
      if (province.id == selectedProvinceId && !isCorrect) return colors.wrong;
    }
    if (province.id == highlightedProvinceId) return colors.accent;
    if (province.id == hoveredProvinceId) return colors.mapHover;
    return colors.mapProvinceFill;
  }

  Color _getStrokeColor(Province province) {
    if (province.id == highlightedProvinceId) return colors.mapHighlightedStroke;
    if (showResult && province.id == correctProvinceId) return const Color(0xFF16A34A);
    if (province.id == hoveredProvinceId) return const Color(0xFF60A5FA);
    return colors.mapProvinceStroke;
  }

  double _getStrokeWidth(Province province) {
    if (province.id == highlightedProvinceId) return 2.5;
    if (showResult && province.id == correctProvinceId) return 2.0;
    if (province.id == hoveredProvinceId) return 1.5;
    return 1.0;
  }

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) {
    return oldDelegate.hoveredProvinceId != hoveredProvinceId ||
        oldDelegate.selectedProvinceId != selectedProvinceId ||
        oldDelegate.correctProvinceId != correctProvinceId ||
        oldDelegate.highlightedProvinceId != highlightedProvinceId ||
        oldDelegate.showResult != showResult || oldDelegate.isCorrect != isCorrect ||
        oldDelegate.showProvinceLabels != showProvinceLabels ||
        oldDelegate.itemMode != itemMode || oldDelegate.selectedItemId != selectedItemId ||
        oldDelegate.correctItemId != correctItemId || oldDelegate.colors.isDark != colors.isDark;
  }
}