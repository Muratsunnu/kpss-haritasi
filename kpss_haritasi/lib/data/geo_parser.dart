import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart' show rootBundle;
import '../models/province.dart';

class GeoJsonParser {
  // Türkiye'nin coğrafi sınırları
  static const double minLon = 25.5;
  static const double maxLon = 44.9;
  static const double minLat = 35.5;
  static const double maxLat = 42.5;

  /// GeoJSON dosyasını assets'ten oku ve parse et
  static Future<List<Province>> loadFromAsset(
    String assetPath,
    Size size,
  ) async {
    final String jsonStr = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> geoJson = json.decode(jsonStr);
    return _parseFeatureCollection(geoJson, size);
  }

  /// FeatureCollection'ı parse et
  static List<Province> _parseFeatureCollection(
    Map<String, dynamic> geoJson,
    Size size,
  ) {
    final List<Province> provinces = [];
    final features = geoJson['features'] as List;

    for (final feature in features) {
      final properties = feature['properties'] as Map<String, dynamic>;
      final geometry = feature['geometry'] as Map<String, dynamic>;

      final String name = properties['name'] ?? '';
      final String id =
          (properties['number'] ?? 0).toString().padLeft(2, '0');
      final String type = geometry['type'] ?? '';
      final coordinates = geometry['coordinates'];

      final Path path = Path();
      final List<Offset> allPoints = [];

      if (type == 'Polygon') {
        _parsePolygon(coordinates, path, allPoints, size);
      } else if (type == 'MultiPolygon') {
        _parseMultiPolygon(coordinates, path, allPoints, size);
      }

      if (allPoints.isNotEmpty) {
        // Merkez noktayı hesapla (ağırlık merkezi)
        double cx = 0, cy = 0;
        for (final p in allPoints) {
          cx += p.dx;
          cy += p.dy;
        }
        final center = Offset(cx / allPoints.length, cy / allPoints.length);

        provinces.add(Province(
          id: id,
          name: name,
          path: path,
          center: center,
        ));
      }
    }

    return provinces;
  }

  static void _parsePolygon(
    List<dynamic> coordinates,
    Path path,
    List<Offset> allPoints,
    Size size,
  ) {
    for (final ring in coordinates) {
      _parseRing(ring as List<dynamic>, path, allPoints, size);
    }
  }

  static void _parseMultiPolygon(
    List<dynamic> coordinates,
    Path path,
    List<Offset> allPoints,
    Size size,
  ) {
    for (final polygon in coordinates) {
      for (final ring in polygon) {
        _parseRing(ring as List<dynamic>, path, allPoints, size);
      }
    }
  }

  static void _parseRing(
    List<dynamic> ring,
    Path path,
    List<Offset> allPoints,
    Size size,
  ) {
    for (int i = 0; i < ring.length; i++) {
      final coord = ring[i] as List<dynamic>;
      final double lon = (coord[0] as num).toDouble();
      final double lat = (coord[1] as num).toDouble();
      final point = geoToScreen(lon, lat, size);

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
      allPoints.add(point);
    }
    path.close();
  }

  /// Coğrafi koordinat → ekran pikseli
  static Offset geoToScreen(double lon, double lat, Size size) {
    final double x = (lon - minLon) / (maxLon - minLon) * size.width;
    final double y = (1 - (lat - minLat) / (maxLat - minLat)) * size.height;
    return Offset(x, y);
  }
}
