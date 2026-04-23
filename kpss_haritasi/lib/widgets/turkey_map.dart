import 'package:flutter/material.dart';
import '../models/province.dart';
import '../models/map_item.dart';
import '../models/theme_notifier.dart';
import '../data/geo_parser.dart';
import '../painters/map_painter.dart';

class TurkeyMap extends StatefulWidget {
  final String? highlightedProvinceId;
  final String? correctProvinceId;
  final bool showResult;
  final bool isCorrect;
  final String? selectedProvinceId;
  final Set<String> answeredCorrect;
  final Set<String> answeredWrong;
  final bool interactive;
  final Function(Province)? onProvinceTap;
  final bool showProvinceLabels;

  final bool itemMode;
  final List<MapItem> items;
  final String? selectedItemId;
  final String? correctItemId;
  final Set<String> itemAnsweredCorrect;
  final Set<String> itemAnsweredWrong;
  final Function(MapItem)? onItemTap;
  final Color itemColor;

  const TurkeyMap({
    super.key,
    this.highlightedProvinceId, this.correctProvinceId,
    this.showResult = false, this.isCorrect = false,
    this.selectedProvinceId, this.answeredCorrect = const {}, this.answeredWrong = const {},
    this.interactive = true, this.onProvinceTap,
    this.showProvinceLabels = false,
    this.itemMode = false, this.items = const [],
    this.selectedItemId, this.correctItemId,
    this.itemAnsweredCorrect = const {}, this.itemAnsweredWrong = const {},
    this.onItemTap, this.itemColor = const Color(0xFF3B82F6),
  });

  @override
  State<TurkeyMap> createState() => _TurkeyMapState();
}

class _TurkeyMapState extends State<TurkeyMap> {
  List<Province>? _provinces;
  bool _loading = true;
  Size? _loadedForSize;
  final TransformationController _transformController = TransformationController();

  @override
  void dispose() { _transformController.dispose(); super.dispose(); }

  Future<void> _loadProvinces(Size size) async {
    if (_loadedForSize == size && _provinces != null) return;
    setState(() => _loading = true);
    try {
      final provinces = await GeoJsonParser.loadFromAsset('assets/tr-cities.json', size);
      if (mounted) setState(() { _provinces = provinces; _loadedForSize = size; _loading = false; });
    } catch (e) {
      debugPrint('GeoJSON yükleme hatası: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  Province? _hitTestProvince(Offset pos) {
    if (_provinces == null) return null;
    for (int i = _provinces!.length - 1; i >= 0; i--) {
      final p = _provinces![i];
      // İller: sadece doğru bilinenler atlanır — yanlış bilinenler tekrar tıklanabilir
      if (widget.answeredCorrect.contains(p.id)) continue;
      if (p.contains(pos)) return p;
    }
    return null;
  }

  MapItem? _hitTestItem(Offset pos, Size mapSize) {
    for (final item in widget.items) {
      // Dot quizleri: hem doğru hem yanlış bilinenler tıklanamaz
      if (widget.itemAnsweredCorrect.contains(item.id) ||
          widget.itemAnsweredWrong.contains(item.id)) continue;
      if (item.containsPoint(pos, mapSize)) return item;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final c = ThemeScope.colorsOf(context);

    return LayoutBuilder(builder: (context, constraints) {
      final double width = constraints.maxWidth;
      final double height = width * 0.52;
      final Size mapSize = Size(width, height);

      if (_loadedForSize != mapSize) {
        WidgetsBinding.instance.addPostFrameCallback((_) { _loadProvinces(mapSize); });
      }

      return SizedBox(width: width, height: height,
        child: ClipRect(
          child: _loading || _provinces == null
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  CircularProgressIndicator(color: c.accent, strokeWidth: 2),
                  const SizedBox(height: 12),
                  Text('Harita yükleniyor...', style: TextStyle(color: c.textMuted, fontSize: 13)),
                ]))
              : GestureDetector(
                  onTapUp: widget.interactive ? (details) {
                    final inverse = Matrix4.inverted(_transformController.value);
                    final transformed = MatrixUtils.transformPoint(inverse, details.localPosition);
                    if (widget.itemMode) {
                      final item = _hitTestItem(transformed, mapSize);
                      if (item != null) widget.onItemTap?.call(item);
                    } else {
                      final province = _hitTestProvince(transformed);
                      if (province != null) widget.onProvinceTap?.call(province);
                    }
                  } : null,
                  child: InteractiveViewer(
                    transformationController: _transformController,
                    constrained: true, minScale: 1.0, maxScale: 5.0, panEnabled: true, scaleEnabled: true,
                    child: SizedBox(width: mapSize.width, height: mapSize.height,
                      child: CustomPaint(size: mapSize, painter: MapPainter(
                        provinces: _provinces!, mapSize: mapSize, colors: c,
                        selectedProvinceId: widget.selectedProvinceId, correctProvinceId: widget.correctProvinceId,
                        highlightedProvinceId: widget.highlightedProvinceId,
                        showResult: widget.showResult, isCorrect: widget.isCorrect,
                        answeredCorrect: widget.answeredCorrect, answeredWrong: widget.answeredWrong,
                        showProvinceLabels: widget.showProvinceLabels,
                        itemMode: widget.itemMode, items: widget.items,
                        selectedItemId: widget.selectedItemId, correctItemId: widget.correctItemId,
                        itemAnsweredCorrect: widget.itemAnsweredCorrect, itemAnsweredWrong: widget.itemAnsweredWrong,
                        itemColor: widget.itemColor,
                      )),
                    ),
                  ),
                ),
        ),
      );
    });
  }
}