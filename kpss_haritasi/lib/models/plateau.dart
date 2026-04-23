import 'dart:ui';
import '../data/geo_parser.dart';

class PlateauInfo {
  final String id;
  final String name;
  final double lon;
  final double lat;
  final double scaleX; // elips genişlik çarpanı (1.0 = normal)
  final double scaleY; // elips yükseklik çarpanı (1.0 = normal)
  final String description;

  const PlateauInfo({
    required this.id,
    required this.name,
    required this.lon,
    required this.lat,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.description = '',
  });

  /// Ekran koordinatlarında merkez noktası
  Offset centerOnScreen(Size size) {
    return GeoJsonParser.geoToScreen(lon, lat, size);
  }

  /// Ekran koordinatlarında elips boyutu (harita genişliğine orantılı)
  Size ellipseSize(Size mapSize) {
    // Harita genişliğinin %4'ü baz yarıçap
    final baseR = mapSize.width * 0.035;
    return Size(baseR * 2 * scaleX, baseR * 2 * scaleY);
  }

  /// Dokunma testi (elips içinde mi?)
  bool containsPoint(Offset point, Size mapSize) {
    final center = centerOnScreen(mapSize);
    final eSize = ellipseSize(mapSize);
    final rx = eSize.width / 2;
    final ry = eSize.height / 2;
    if (rx == 0 || ry == 0) return false;

    final dx = point.dx - center.dx;
    final dy = point.dy - center.dy;
    return (dx * dx) / (rx * rx) + (dy * dy) / (ry * ry) <= 1.0;
  }
}

/// KPSS'de sıkça sorulan Türkiye platoları
class PlateauData {
  static const List<PlateauInfo> plateaus = [
    // İÇ ANADOLU PLATOLARI
    PlateauInfo(
      id: 'haymana',
      name: 'Haymana Platosu',
      lon: 32.5,
      lat: 39.43,
      scaleX: 1.2,
      description: 'Ankara güneyinde, İç Anadolu\'nun önemli tahıl üretim alanı',
    ),
    PlateauInfo(
      id: 'cihanbeyli',
      name: 'Cihanbeyli Platosu',
      lon: 32.9,
      lat: 38.65,
      scaleX: 1.2,
      description: 'Konya kuzeyinde, Tuz Gölü\'nün güneyinde',
    ),
    PlateauInfo(
      id: 'obruk',
      name: 'Obruk Platosu',
      lon: 33.7,
      lat: 38.2,
      scaleX: 1.1,
      description: 'Konya doğusunda, obruk oluşumlarıyla ünlü',
    ),
    PlateauInfo(
      id: 'bozok',
      name: 'Bozok Platosu',
      lon: 35.8,
      lat: 39.7,
      scaleX: 1.3,
      scaleY: 1.1,
      description: 'Yozgat çevresinde, İç Anadolu\'nun kuzeydoğusu',
    ),
    PlateauInfo(
      id: 'uzunyayla',
      name: 'Uzunyayla Platosu',
      lon: 36.6,
      lat: 38.9,
      scaleX: 1.3,
      scaleY: 1.1,
      description: 'Sivas güneyi, Türkiye\'nin en yüksek platolarından',
    ),

    // DOĞU ANADOLU PLATOLARI
    PlateauInfo(
      id: 'erzurum_kars',
      name: 'Erzurum-Kars Platosu',
      lon: 42.2,
      lat: 39.9,
      scaleX: 1.5,
      scaleY: 1.2,
      description: 'Türkiye\'nin en yüksek ve en geniş platosu',
    ),
    PlateauInfo(
      id: 'ardahan',
      name: 'Ardahan Platosu',
      lon: 42.7,
      lat: 41.1,
      description: 'Türkiye\'nin en soğuk bölgelerinden, hayvancılık önemli',
    ),

    // GÜNEYDOĞU ANADOLU PLATOLARI
    PlateauInfo(
      id: 'gaziantep',
      name: 'Gaziantep Platosu',
      lon: 37.4,
      lat: 37.15,
      scaleX: 1.2,
      description: 'Güneydoğu Anadolu\'nun batısında, fıstık üretimiyle ünlü',
    ),
    PlateauInfo(
      id: 'sanliurfa',
      name: 'Şanlıurfa Platosu',
      lon: 38.8,
      lat: 37.25,
      scaleX: 1.2,
      description: 'GAP bölgesinde, pamuk ve tahıl üretimi',
    ),
    PlateauInfo(
      id: 'diyarbakir',
      name: 'Diyarbakır Platosu',
      lon: 40.2,
      lat: 37.95,
      scaleX: 1.1,
      description: 'Dicle Nehri çevresinde, verimli tarım alanı',
    ),
    PlateauInfo(
      id: 'mardin',
      name: 'Mardin Eşiği',
      lon: 40.7,
      lat: 37.3,
      description: 'Mezopotamya ile Anadolu arasında geçiş bölgesi',
    ),

    // KARADENİZ PLATOLARI
    PlateauInfo(
      id: 'persenbe',
      name: 'Perşembe Platosu',
      lon: 37.6,
      lat: 40.95,
      description: 'Ordu\'nun yüksek kesimlerinde, yayla turizmi',
    ),

    // TRAKYA
    PlateauInfo(
      id: 'trakya',
      name: 'Ergene (Trakya) Platosu',
      lon: 26.8,
      lat: 41.4,
      scaleX: 1.3,
      description: 'Trakya\'nın ortasında, ayçiçeği ve buğday üretimi',
    ),

    // AKDENİZ
    PlateauInfo(
      id: 'taseli',
      name: 'Taşeli Platosu',
      lon: 33.0,
      lat: 36.8,
      scaleX: 1.2,
      description: 'İç Anadolu ile Akdeniz arasında karstik plato',
    ),
  ];

  /// Quiz için basit bilgi listesi
  static List<PlateauQuizItem> getQuizItems() {
    return plateaus
        .map((p) => PlateauQuizItem(id: p.id, name: p.name))
        .toList();
  }
}

class PlateauQuizItem {
  final String id;
  final String name;

  const PlateauQuizItem({required this.id, required this.name});
}
