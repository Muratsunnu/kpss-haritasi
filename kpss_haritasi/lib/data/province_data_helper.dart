import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

/// Quiz mantığı için il bilgileri (path verileri olmadan, sadece ad ve id)
class ProvinceInfo {
  final String id;
  final String name;

  const ProvinceInfo({required this.id, required this.name});
}

class ProvinceDataHelper {
  static List<ProvinceInfo>? _cachedProvinces;

  /// GeoJSON'dan il listesini yükle (sadece isim ve id)
  static Future<List<ProvinceInfo>> loadProvinceList() async {
    if (_cachedProvinces != null) return _cachedProvinces!;

    final String jsonStr =
        await rootBundle.loadString('assets/tr-cities.json');
    final Map<String, dynamic> geoJson = json.decode(jsonStr);
    final features = geoJson['features'] as List;

    _cachedProvinces = features.map((feature) {
      final props = feature['properties'] as Map<String, dynamic>;
      return ProvinceInfo(
        id: (props['number'] ?? 0).toString().padLeft(2, '0'),
        name: props['name'] ?? '',
      );
    }).toList();

    return _cachedProvinces!;
  }
}
