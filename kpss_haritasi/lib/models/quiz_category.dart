import 'package:flutter/material.dart';
import 'map_item.dart';
import '../data/map_items_data.dart';

enum SpeedMode {
  slow(label: 'Yavaş', icon: '🐢', secondsPerQuestion: 10, multiplier: 1),
  medium(label: 'Orta', icon: '🏃', secondsPerQuestion: 6, multiplier: 3),
  fast(label: 'Hızlı', icon: '⚡', secondsPerQuestion: 3, multiplier: 5),
  practice(label: 'Tümü', icon: '📚', secondsPerQuestion: 0, multiplier: 0);

  final String label;
  final String icon;
  final int secondsPerQuestion;
  final int multiplier;

  const SpeedMode({required this.label, required this.icon, required this.secondsPerQuestion, required this.multiplier});
}

class QuizCategory {
  final String id;
  final String name;
  final String subtitle;
  final String icon;
  final List<Color> gradient;
  final Color textColor;
  final String questionLabel;
  final List<MapItem> items;
  final int questionCount;
  final bool isPremium;

  const QuizCategory({
    required this.id, required this.name, required this.subtitle, required this.icon,
    required this.gradient, required this.textColor, required this.questionLabel,
    required this.items, required this.questionCount, this.isPremium = false,
  });
}

class QuizGroup {
  final String title;
  final List<QuizCategory> categories;
  const QuizGroup({required this.title, required this.categories});
}

class QuizCatalog {
  static final List<QuizGroup> groups = [
    QuizGroup(title: 'İLLER', categories: [
      QuizCategory(id: 'find_province', name: 'Haritada Bul', subtitle: 'İl adı verilir, haritada göster', icon: '🗺️',
        gradient: [const Color(0xFFF59E0B), const Color(0xFFD97706)], textColor: const Color(0xFF0F172A),
        questionLabel: 'Bu ili haritada bul:', items: [], questionCount: 10),
      QuizCategory(id: 'guess_province', name: 'İsmi Tahmin Et', subtitle: 'İl işaretlenir, adını bil', icon: '🤔',
        gradient: [const Color(0xFF3B82F6), const Color(0xFF2563EB)], textColor: const Color(0xFFFFFFFF),
        questionLabel: 'İşaretli ilin adı nedir?', items: [], questionCount: 10, isPremium: true),
      QuizCategory(id: 'metropolitan', name: 'Büyükşehirler', subtitle: '${MapItemsData.metropolitanCityCount} büyükşehir', icon: '🏙️',
        gradient: [const Color(0xFFEC4899), const Color(0xFFDB2777)], textColor: const Color(0xFFFFFFFF),
        questionLabel: 'Bu büyükşehri haritada bul:', items: MapItemsData.metropolitanCities, questionCount: 10),
    ]),
    QuizGroup(title: 'FİZİKİ COĞRAFYA', categories: [
      QuizCategory(id: 'plateau', name: 'Platolar', subtitle: '${MapItemsData.plateauCount} plato', icon: '🏔️',
        gradient: [const Color(0xFF10B981), const Color(0xFF059669)], textColor: const Color(0xFFFFFFFF),
        questionLabel: 'Bu platoyu haritada bul:', items: MapItemsData.plateaus, questionCount: 6),
      QuizCategory(id: 'mountain', name: 'Dağlar', subtitle: '${MapItemsData.mountainCount} dağ', icon: '⛰️',
        gradient: [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)], textColor: const Color(0xFFFFFFFF),
        questionLabel: 'Bu dağı haritada bul:', items: MapItemsData.mountains, questionCount: 7, isPremium: true),
      QuizCategory(id: 'plain', name: 'Ovalar', subtitle: '${MapItemsData.plainCount} ova', icon: '🌾',
        gradient: [const Color(0xFFF97316), const Color(0xFFEA580C)], textColor: const Color(0xFFFFFFFF),
        questionLabel: 'Bu ovayı haritada bul:', items: MapItemsData.plains, questionCount: 8),
      QuizCategory(id: 'pass', name: 'Geçitler', subtitle: '${MapItemsData.passCount} geçit', icon: '🛤️',
        gradient: [const Color(0xFF78716C), const Color(0xFF57534E)], textColor: const Color(0xFFFFFFFF),
        questionLabel: 'Bu geçidi haritada bul:', items: MapItemsData.passes, questionCount: 5, isPremium: true),
      QuizCategory(id: 'coastal', name: 'Kıyı Tipleri', subtitle: '${MapItemsData.coastalTypeCount} kıyı tipi', icon: '🏖️',
        gradient: [const Color(0xFF14B8A6), const Color(0xFF0D9488)], textColor: const Color(0xFFFFFFFF),
        questionLabel: 'Bu kıyı tipini haritada bul:', items: MapItemsData.coastalTypes, questionCount: 6),
      QuizCategory(id: 'soil', name: 'Toprak Çeşitleri', subtitle: '${MapItemsData.soilTypeCount} toprak tipi', icon: '🟤',
        gradient: [const Color(0xFF92400E), const Color(0xFF78350F)], textColor: const Color(0xFFFFFFFF),
        questionLabel: 'Bu toprak tipini haritada bul:', items: MapItemsData.soilTypes, questionCount: 6, isPremium: true),
      QuizCategory(id: 'vegetation', name: 'Bitki Örtüsü', subtitle: '${MapItemsData.vegetationTypeCount} bitki örtüsü', icon: '🌿',
        gradient: [const Color(0xFF16A34A), const Color(0xFF15803D)], textColor: const Color(0xFFFFFFFF),
        questionLabel: 'Bu bitki örtüsünü haritada bul:', items: MapItemsData.vegetationTypes, questionCount: 6, isPremium: true),
    ]),
    QuizGroup(title: 'SU VARLIĞI', categories: [
      QuizCategory(id: 'lake', name: 'Göller', subtitle: '${MapItemsData.lakeCount} göl', icon: '💧',
        gradient: [const Color(0xFF06B6D4), const Color(0xFF0891B2)], textColor: const Color(0xFFFFFFFF),
        questionLabel: 'Bu gölü haritada bul:', items: MapItemsData.lakes, questionCount: 8, isPremium: true),
      QuizCategory(id: 'river', name: 'Nehirler', subtitle: '${MapItemsData.riverCount} nehir', icon: '🌊',
        gradient: [const Color(0xFF0EA5E9), const Color(0xFF0284C7)], textColor: const Color(0xFFFFFFFF),
        questionLabel: 'Bu nehri haritada bul:', items: MapItemsData.rivers, questionCount: 8, isPremium: true),
      QuizCategory(id: 'gulf', name: 'Körfezler', subtitle: '${MapItemsData.gulfCount} körfez', icon: '🌅',
        gradient: [const Color(0xFF0369A1), const Color(0xFF075985)], textColor: const Color(0xFFFFFFFF),
        questionLabel: 'Bu körfezi haritada bul:', items: MapItemsData.gulfs, questionCount: 7, isPremium: true),
    ]),
    QuizGroup(title: 'EKONOMİ', categories: [
      QuizCategory(id: 'mine', name: 'Madenler', subtitle: '${MapItemsData.mineCount} maden', icon: '⚒️',
        gradient: [const Color(0xFFEF4444), const Color(0xFFDC2626)], textColor: const Color(0xFFFFFFFF),
        questionLabel: 'Bu madeni haritada bul:', items: MapItemsData.mines, questionCount: 7, isPremium: true),
      QuizCategory(id: 'agriculture', name: 'Tarım Ürünleri', subtitle: '${MapItemsData.agricultureCount} ürün', icon: '🌽',
        gradient: [const Color(0xFFCA8A04), const Color(0xFFA16207)], textColor: const Color(0xFFFFFFFF),
        questionLabel: 'Bu tarım ürününü haritada bul:', items: MapItemsData.agriculture, questionCount: 7, isPremium: true),
    ]),
  ];

  static bool isProvinceMode(String categoryId) {
    return categoryId == 'find_province' || categoryId == 'guess_province';
  }
}