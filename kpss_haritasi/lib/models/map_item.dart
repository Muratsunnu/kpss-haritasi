import 'dart:ui';
import '../data/geo_parser.dart';

/// Harita üzerindeki tüm coğrafi öğeler için ortak model
class MapItem {
  final String id;
  final String name;
  final double lon;
  final double lat;
  final double scaleX;
  final double scaleY;
  final String category;    // 'plateau', 'mountain', 'plain', 'lake', 'mine', 'river'
  final String subCategory; // 'volcanic', 'tectonic', 'delta', 'fold' vs.
  final String description;

  const MapItem({
    required this.id,
    required this.name,
    required this.lon,
    required this.lat,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.category = '',
    this.subCategory = '',
    this.description = '',
  });

  /// Ekran koordinatlarında merkez noktası
  Offset centerOnScreen(Size mapSize) {
    return GeoJsonParser.geoToScreen(lon, lat, mapSize);
  }

  /// Dokunma testi (dot etrafında geniş alan)
  bool containsPoint(Offset point, Size mapSize) {
    final center = centerOnScreen(mapSize);
    // Dot yarıçapının 2.5 katı dokunma alanı (küçük dot'a kolay tıklama)
    final tapRadius = mapSize.width * 0.015 * 2.5;

    final dx = point.dx - center.dx;
    final dy = point.dy - center.dy;
    return (dx * dx + dy * dy) <= (tapRadius * tapRadius);
  }
}