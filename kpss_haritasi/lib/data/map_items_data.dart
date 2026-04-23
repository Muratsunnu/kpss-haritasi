import '../models/map_item.dart';

/// Tüm coğrafi öğelerin verileri
class MapItemsData {
  // ════════════════════════════════════════
  // PLATOLAR
  // ════════════════════════════════════════
  static const List<MapItem> plateaus = [
    // Karstik Platolar
    MapItem(id: 'teke', name: 'Teke Platosu', lon: 30.3, lat: 37.2, scaleX: 1.2, category: 'plateau', subCategory: 'karst', description: 'Antalya batısı, karstik yapı'),
    MapItem(id: 'taseli', name: 'Taşeli Platosu', lon: 33.0, lat: 36.8, scaleX: 1.2, category: 'plateau', subCategory: 'karst', description: 'Mersin kuzeyi, karstik plato'),
    // Volkanik Platolar
    MapItem(id: 'erzurum_kars', name: 'Erzurum-Kars Platosu', lon: 42.2, lat: 39.9, scaleX: 1.5, scaleY: 1.2, category: 'plateau', subCategory: 'volcanic', description: 'Türkiye\'nin en yüksek ve geniş platosu, lav örtüsü'),
    MapItem(id: 'ardahan', name: 'Ardahan Platosu', lon: 42.7, lat: 41.1, category: 'plateau', subCategory: 'volcanic', description: 'Kuzeydoğu Anadolu, volkanik plato'),
    MapItem(id: 'kapadokya', name: 'Kapadokya Platosu', lon: 34.8, lat: 38.6, scaleX: 1.2, category: 'plateau', subCategory: 'volcanic', description: 'Nevşehir çevresi, peri bacaları, volkanik tüf'),
    MapItem(id: 'kirsehir', name: 'Kırşehir Platosu', lon: 34.2, lat: 39.15, scaleX: 1.1, category: 'plateau', subCategory: 'volcanic', description: 'Kırşehir çevresi, volkanik plato'),
    // Aşınım Düzlüğü Platoları
    MapItem(id: 'catalca_kocaeli', name: 'Çatalca-Kocaeli Platosu', lon: 29.5, lat: 41.1, scaleX: 1.4, category: 'plateau', subCategory: 'erosion', description: 'İstanbul çevresi, aşınım düzlüğü'),
    MapItem(id: 'persenbe', name: 'Perşembe Platosu', lon: 37.6, lat: 40.95, category: 'plateau', subCategory: 'erosion', description: 'Ordu, aşınım düzlüğü platosu'),
    // Tabaka Düzlüğü Platoları
    MapItem(id: 'bozok', name: 'Bozok Platosu', lon: 35.8, lat: 39.7, scaleX: 1.3, scaleY: 1.1, category: 'plateau', subCategory: 'layer', description: 'Yozgat çevresi, tabaka düzlüğü'),
    MapItem(id: 'haymana', name: 'Haymana Platosu', lon: 32.5, lat: 39.43, scaleX: 1.2, category: 'plateau', subCategory: 'layer', description: 'Ankara güneyinde, tahıl üretim alanı'),
    MapItem(id: 'cihanbeyli', name: 'Cihanbeyli Platosu', lon: 32.9, lat: 38.65, scaleX: 1.2, category: 'plateau', subCategory: 'layer', description: 'Konya kuzeyi, Tuz Gölü güneyi'),
    MapItem(id: 'obruk', name: 'Obruk Platosu', lon: 33.7, lat: 38.2, scaleX: 1.1, category: 'plateau', subCategory: 'layer', description: 'Konya doğusu, obruk oluşumları'),
    MapItem(id: 'uzunyayla', name: 'Uzunyayla Platosu', lon: 36.6, lat: 38.9, scaleX: 1.3, scaleY: 1.1, category: 'plateau', subCategory: 'layer', description: 'Sivas güneyi, yüksek plato'),
    MapItem(id: 'yazlikaya', name: 'Yazılıkaya Platosu', lon: 28.5, lat: 38.8, scaleX: 1.1, category: 'plateau', subCategory: 'layer', description: 'Manisa çevresi, tabaka düzlüğü'),
    MapItem(id: 'gaziantep', name: 'Gaziantep Platosu', lon: 37.4, lat: 37.15, scaleX: 1.2, category: 'plateau', subCategory: 'layer', description: 'Fıstık üretimiyle ünlü, tabaka düzlüğü'),
    MapItem(id: 'sanliurfa', name: 'Şanlıurfa Platosu', lon: 38.8, lat: 37.25, scaleX: 1.2, category: 'plateau', subCategory: 'layer', description: 'GAP bölgesi, tabaka düzlüğü'),
  ];
  static int get plateauCount => plateaus.length;

  // ════════════════════════════════════════
  // DAĞLAR
  // ════════════════════════════════════════
  static const List<MapItem> mountains = [
    // ── VOLKANİK DAĞLAR ──
    MapItem(id: 'agri', name: 'Ağrı Dağı', lon: 44.3, lat: 39.7, category: 'mountain', subCategory: 'volcanic', description: 'Türkiye\'nin en yüksek dağı (5137 m), tabakalı volkan'),
    MapItem(id: 'tendurek', name: 'Tendürek Dağı', lon: 43.87, lat: 39.37, category: 'mountain', subCategory: 'volcanic', description: 'Ağrı-Van arası, tabakalı volkan'),
    MapItem(id: 'suphan', name: 'Süphan Dağı', lon: 42.83, lat: 38.93, category: 'mountain', subCategory: 'volcanic', description: 'Bitlis, Van Gölü kuzeyi (4058 m), tabakalı volkan'),
    MapItem(id: 'nemrut_volkan', name: 'Nemrut Dağı (Bitlis)', lon: 42.23, lat: 38.65, category: 'mountain', subCategory: 'volcanic', description: 'Krater gölüyle ünlü, tabakalı volkan'),
    MapItem(id: 'erciyes', name: 'Erciyes Dağı', lon: 35.45, lat: 38.53, category: 'mountain', subCategory: 'volcanic', description: 'Kayseri (3917 m), tabakalı volkan'),
    MapItem(id: 'hasan', name: 'Hasan Dağı', lon: 34.17, lat: 38.13, category: 'mountain', subCategory: 'volcanic', description: 'Aksaray (3268 m), tabakalı volkan'),
    MapItem(id: 'melendiz', name: 'Melendiz Dağı', lon: 34.5, lat: 38.25, category: 'mountain', subCategory: 'volcanic', description: 'Niğde, İç Anadolu volkanik kuşağı'),
    MapItem(id: 'karacadag_ic', name: 'Karacadağ (İç Anadolu)', lon: 33.5, lat: 37.6, category: 'mountain', subCategory: 'volcanic', description: 'Karaman güneyi, tabakalı volkan'),
    MapItem(id: 'karadag', name: 'Karadağ', lon: 33.1, lat: 37.45, category: 'mountain', subCategory: 'volcanic', description: 'Karaman, tabakalı volkan'),
    MapItem(id: 'karacadag_gda', name: 'Karacadağ (Güneydoğu)', lon: 39.83, lat: 37.73, category: 'mountain', subCategory: 'volcanic', description: 'Şanlıurfa-Diyarbakır, kalkan volkan, bazalt örtüsü'),
    MapItem(id: 'kula', name: 'Kula Volkanı', lon: 28.65, lat: 38.55, category: 'mountain', subCategory: 'volcanic', description: 'Manisa, Türkiye\'nin en genç volkanı, kalkan volkan'),
    // ── KIRIK (HORST) DAĞLARI ──
    MapItem(id: 'kaz', name: 'Kaz Dağları (İda)', lon: 26.87, lat: 39.7, category: 'mountain', subCategory: 'horst', description: 'Balıkesir-Çanakkale, mitolojik önemi'),
    MapItem(id: 'madra', name: 'Madra Dağı', lon: 27.1, lat: 39.35, category: 'mountain', subCategory: 'horst', description: 'Balıkesir, Ege kırık dağı'),
    MapItem(id: 'yunt', name: 'Yunt Dağı', lon: 27.7, lat: 38.97, category: 'mountain', subCategory: 'horst', description: 'Manisa, horst dağı'),
    MapItem(id: 'boz', name: 'Bozdağlar', lon: 28.2, lat: 38.37, category: 'mountain', subCategory: 'horst', description: 'İzmir-Manisa arası'),
    MapItem(id: 'aydin', name: 'Aydın Dağları', lon: 27.8, lat: 37.7, category: 'mountain', subCategory: 'horst', description: 'Aydın kuzeyi, Büyük Menderes vadisi'),
    MapItem(id: 'mentese', name: 'Menteşe Dağları', lon: 28.3, lat: 37.2, category: 'mountain', subCategory: 'horst', description: 'Muğla yöresi'),
    MapItem(id: 'amanos', name: 'Nur (Amanos) Dağları', lon: 36.3, lat: 36.8, category: 'mountain', subCategory: 'horst', description: 'Hatay, kırık dağ, Belen Geçidi'),
    // ── KIVRIM DAĞLARI ──
    // Kuzey Anadolu sırası
    MapItem(id: 'yildiz_istranca', name: 'Yıldız (Istranca) Dağları', lon: 27.6, lat: 41.8, category: 'mountain', subCategory: 'fold', description: 'Kırklareli, Trakya\'nın en yüksek dağları'),
    MapItem(id: 'samanli', name: 'Samanlı Dağları', lon: 29.8, lat: 40.55, category: 'mountain', subCategory: 'fold', description: 'Kocaeli-Sakarya, Marmara güneyi'),
    MapItem(id: 'uludag', name: 'Uludağ', lon: 29.12, lat: 40.07, category: 'mountain', subCategory: 'fold', description: 'Bursa, kayak merkezi (2543 m)'),
    MapItem(id: 'sundiken', name: 'Sündiken Dağları', lon: 30.3, lat: 39.95, category: 'mountain', subCategory: 'fold', description: 'Eskişehir kuzeyi'),
    MapItem(id: 'bolu', name: 'Bolu Dağları', lon: 31.5, lat: 40.7, category: 'mountain', subCategory: 'fold', description: 'Bolu, Kuzey Anadolu sırası'),
    MapItem(id: 'koroglu', name: 'Köroğlu Dağları', lon: 32.0, lat: 40.6, category: 'mountain', subCategory: 'fold', description: 'Bolu-Çankırı, Kuzey Anadolu'),
    MapItem(id: 'ilgaz', name: 'Ilgaz Dağları', lon: 33.73, lat: 41.07, category: 'mountain', subCategory: 'fold', description: 'Kastamonu-Çankırı arası'),
    MapItem(id: 'kure', name: 'Küre Dağları', lon: 33.13, lat: 41.73, category: 'mountain', subCategory: 'fold', description: 'Kastamonu-Bartın, milli park'),
    MapItem(id: 'canik', name: 'Canik Dağları', lon: 36.5, lat: 41.1, category: 'mountain', subCategory: 'fold', description: 'Samsun güneyi, Karadeniz kıyı dağları'),
    MapItem(id: 'giresun', name: 'Giresun Dağları', lon: 38.5, lat: 40.6, category: 'mountain', subCategory: 'fold', description: 'Giresun, Karadeniz kıyı sırası'),
    MapItem(id: 'dogu_karadeniz', name: 'Doğu Karadeniz Dağları', lon: 40.0, lat: 40.7, category: 'mountain', subCategory: 'fold', description: 'Gümüşhane-Trabzon, yüksek kıyı dağları'),
    MapItem(id: 'mescit', name: 'Mescit Dağları', lon: 40.0, lat: 40.4, category: 'mountain', subCategory: 'fold', description: 'Gümüşhane, Kuzey Anadolu silsilesi'),
    MapItem(id: 'kackar', name: 'Kaçkar Dağları', lon: 41.17, lat: 40.83, category: 'mountain', subCategory: 'fold', description: 'Rize-Artvin, Karadeniz\'in en yükseği (3932 m)'),
    MapItem(id: 'karcal', name: 'Karçal Dağları', lon: 41.7, lat: 41.3, category: 'mountain', subCategory: 'fold', description: 'Artvin, Kuzeydoğu Anadolu'),
    MapItem(id: 'yalnizcam', name: 'Yalnızçam Dağları', lon: 42.5, lat: 40.8, category: 'mountain', subCategory: 'fold', description: 'Artvin-Ardahan, Kuzeydoğu sırası'),
    MapItem(id: 'allahuekber', name: 'Allahuekber Dağları', lon: 42.8, lat: 40.3, category: 'mountain', subCategory: 'fold', description: 'Kars-Erzurum, I. Dünya Savaşı muharebeleri'),
    MapItem(id: 'karasu_aras', name: 'Karasu-Aras Dağları', lon: 42.0, lat: 39.7, category: 'mountain', subCategory: 'fold', description: 'Erzurum güneyi, Karasu-Aras ayrımı'),
    MapItem(id: 'palandoken', name: 'Palandöken Dağları', lon: 41.2, lat: 39.85, category: 'mountain', subCategory: 'fold', description: 'Erzurum, kayak merkezi'),
    // Batı-İç Toroslar sırası
    MapItem(id: 'akdaglar_bati', name: 'Akdağlar', lon: 29.7, lat: 37.3, category: 'mountain', subCategory: 'fold', description: 'Muğla-Denizli, Batı Toroslar'),
    MapItem(id: 'bey', name: 'Bey Dağları', lon: 30.4, lat: 36.8, category: 'mountain', subCategory: 'fold', description: 'Antalya batısı, Olimpos'),
    MapItem(id: 'sultan', name: 'Sultan Dağları', lon: 31.2, lat: 38.1, category: 'mountain', subCategory: 'fold', description: 'Isparta-Afyon, İç Batı Anadolu'),
    MapItem(id: 'dedegol', name: 'Dedegöl Dağları', lon: 31.3, lat: 37.65, category: 'mountain', subCategory: 'fold', description: 'Isparta, Göller Bölgesi'),
    MapItem(id: 'geyik', name: 'Geyik Dağları', lon: 31.7, lat: 37.1, category: 'mountain', subCategory: 'fold', description: 'Antalya-Konya, Batı Toroslar'),
    MapItem(id: 'tahtali', name: 'Tahtalı Dağları', lon: 33.5, lat: 37.5, category: 'mountain', subCategory: 'fold', description: 'Niğde-Mersin, Orta Toroslar'),
    MapItem(id: 'bolkar', name: 'Bolkar Dağları', lon: 34.57, lat: 37.47, category: 'mountain', subCategory: 'fold', description: 'Niğde-Mersin arası (3524 m)'),
    MapItem(id: 'aladaglar', name: 'Aladağlar', lon: 35.17, lat: 37.77, category: 'mountain', subCategory: 'fold', description: 'Kayseri-Adana-Niğde, Orta Torosların en yükseği'),
    MapItem(id: 'akdaglar_ic', name: 'Akdağlar (İç)', lon: 35.0, lat: 39.0, category: 'mountain', subCategory: 'fold', description: 'Tokat-Amasya, İç Anadolu kuzeyi'),
    MapItem(id: 'tecer', name: 'Tecer Dağları', lon: 36.8, lat: 39.4, category: 'mountain', subCategory: 'fold', description: 'Sivas, İç Anadolu-Karadeniz geçişi'),
    MapItem(id: 'nurhak', name: 'Nurhak Dağı', lon: 37.2, lat: 37.9, category: 'mountain', subCategory: 'fold', description: 'Kahramanmaraş, Güneydoğu Toroslar başlangıcı'),
    MapItem(id: 'mercan', name: 'Mercan Dağları', lon: 39.5, lat: 39.3, category: 'mountain', subCategory: 'fold', description: 'Tunceli-Erzincan, Munzur silsilesi'),
    MapItem(id: 'guneydogu_toros', name: 'Güneydoğu Toroslar', lon: 40.5, lat: 38.5, category: 'mountain', subCategory: 'fold', description: 'Bingöl-Bitlis hattı, geniş kıvrım kuşağı'),
    MapItem(id: 'ihtiyarsahap', name: 'İhtiyarşahap Dağları', lon: 43.5, lat: 38.2, category: 'mountain', subCategory: 'fold', description: 'Van güneyi, İran sınırı'),
    MapItem(id: 'hakkari', name: 'Hakkari Dağları', lon: 43.8, lat: 37.5, category: 'mountain', subCategory: 'fold', description: 'Hakkari, Cilo-Sat zirveleri, Güneydoğu Toroslar'),
  ];
  static int get mountainCount => mountains.length;

  // ════════════════════════════════════════
  // OVALAR
  // ════════════════════════════════════════
  static const List<MapItem> plains = [
    // Delta Ovaları
    MapItem(id: 'bafra', name: 'Bafra Ovası', lon: 36.0, lat: 41.6, category: 'plain', subCategory: 'delta', description: 'Kızılırmak deltası, Samsun'),
    MapItem(id: 'carsamba', name: 'Çarşamba Ovası', lon: 36.73, lat: 41.2, category: 'plain', subCategory: 'delta', description: 'Yeşilırmak deltası, Samsun'),
    MapItem(id: 'cukurova', name: 'Çukurova', lon: 35.5, lat: 37.0, scaleX: 1.5, category: 'plain', subCategory: 'delta', description: 'Seyhan-Ceyhan deltaları, en verimli ova'),
    MapItem(id: 'silifke', name: 'Silifke Ovası', lon: 33.93, lat: 36.4, category: 'plain', subCategory: 'delta', description: 'Göksu deltası, Mersin'),
    // Tektonik Ovalar
    MapItem(id: 'ergene', name: 'Ergene Ovası', lon: 26.8, lat: 41.2, scaleX: 1.3, category: 'plain', subCategory: 'tectonic', description: 'Trakya, ayçiçeği ve buğday'),
    MapItem(id: 'adapazari', name: 'Adapazarı Ovası', lon: 30.4, lat: 40.7, category: 'plain', subCategory: 'tectonic', description: 'Sakarya, verimli tarım ovası'),
    MapItem(id: 'duzce', name: 'Düzce Ovası', lon: 31.17, lat: 40.84, category: 'plain', subCategory: 'tectonic', description: 'Düzce, tektonik çöküntü ovası'),
    MapItem(id: 'yenisehir', name: 'Yenişehir Ovası', lon: 29.6, lat: 40.27, category: 'plain', subCategory: 'tectonic', description: 'Bursa, İnegöl-Yenişehir arası'),
    MapItem(id: 'eskisehir', name: 'Eskişehir Ovası', lon: 30.5, lat: 39.78, category: 'plain', subCategory: 'tectonic', description: 'Eskişehir, Porsuk çayı vadisi'),
    MapItem(id: 'cubuk', name: 'Çubuk Ovası', lon: 33.0, lat: 40.2, category: 'plain', subCategory: 'tectonic', description: 'Ankara kuzeyi'),
    MapItem(id: 'murted', name: 'Mürted Ovası', lon: 32.5, lat: 40.1, category: 'plain', subCategory: 'tectonic', description: 'Ankara kuzeybatısı'),
    MapItem(id: 'karacabey', name: 'Karacabey Ovası', lon: 28.4, lat: 40.2, category: 'plain', subCategory: 'tectonic', description: 'Bursa, Marmara güneyi'),
    MapItem(id: 'yukari_sakarya', name: 'Yukarı Sakarya Ovası', lon: 30.8, lat: 39.9, category: 'plain', subCategory: 'tectonic', description: 'Eskişehir-Bilecik arası'),
    MapItem(id: 'bakircay', name: 'Bakırçay Ovası', lon: 27.2, lat: 39.1, category: 'plain', subCategory: 'tectonic', description: 'İzmir-Bergama, graben ovası'),
    MapItem(id: 'akhisar', name: 'Akhisar Ovası', lon: 27.8, lat: 38.9, category: 'plain', subCategory: 'tectonic', description: 'Manisa, zeytin ve tütün'),
    MapItem(id: 'alasehir', name: 'Alaşehir Ovası', lon: 28.5, lat: 38.35, category: 'plain', subCategory: 'tectonic', description: 'Manisa, Gediz grabeni kolu'),
    MapItem(id: 'gediz', name: 'Gediz Ovası', lon: 28.0, lat: 38.6, scaleX: 1.2, category: 'plain', subCategory: 'tectonic', description: 'Manisa, Gediz grabeni'),
    MapItem(id: 'k_menderes', name: 'K. Menderes Ovası', lon: 27.8, lat: 38.2, scaleX: 1.1, category: 'plain', subCategory: 'tectonic', description: 'İzmir güneyi, graben'),
    MapItem(id: 'b_menderes', name: 'B. Menderes Ovası', lon: 28.0, lat: 37.85, scaleX: 1.3, category: 'plain', subCategory: 'tectonic', description: 'Aydın-Denizli, graben ova'),
    MapItem(id: 'selcuk', name: 'Selçuk Ovası', lon: 27.37, lat: 37.95, category: 'plain', subCategory: 'tectonic', description: 'İzmir, Efes yakını'),
    MapItem(id: 'dikili', name: 'Dikili Ovası', lon: 26.9, lat: 39.07, category: 'plain', subCategory: 'tectonic', description: 'İzmir, Ege kıyısı'),
    MapItem(id: 'menemen', name: 'Menemen Ovası', lon: 27.07, lat: 38.6, category: 'plain', subCategory: 'tectonic', description: 'İzmir, Gediz deltası yakını'),
    MapItem(id: 'balat', name: 'Balat Ovası', lon: 27.25, lat: 37.55, category: 'plain', subCategory: 'tectonic', description: 'Aydın, B. Menderes ağzı'),
    MapItem(id: 'aksaray', name: 'Aksaray Ovası', lon: 34.0, lat: 38.37, category: 'plain', subCategory: 'tectonic', description: 'Aksaray, İç Anadolu'),
    MapItem(id: 'konya', name: 'Konya Ovası', lon: 32.5, lat: 37.85, scaleX: 1.5, scaleY: 1.2, category: 'plain', subCategory: 'tectonic', description: 'Türkiye\'nin en büyük ovası, tahıl'),
    MapItem(id: 'erbaa', name: 'Erbaa Ovası', lon: 36.57, lat: 40.67, category: 'plain', subCategory: 'tectonic', description: 'Tokat, Kelkit vadisi'),
    MapItem(id: 'niksar', name: 'Niksar Ovası', lon: 36.95, lat: 40.6, category: 'plain', subCategory: 'tectonic', description: 'Tokat, Kelkit vadisi'),
    MapItem(id: 'amasya', name: 'Amasya Ovası', lon: 35.85, lat: 40.65, category: 'plain', subCategory: 'tectonic', description: 'Amasya, Yeşilırmak vadisi'),
    MapItem(id: 'erzincan', name: 'Erzincan Ovası', lon: 39.5, lat: 39.75, category: 'plain', subCategory: 'tectonic', description: 'Erzincan, tektonik çöküntü'),
    MapItem(id: 'tercan', name: 'Tercan Ovası', lon: 40.4, lat: 39.78, category: 'plain', subCategory: 'tectonic', description: 'Erzincan doğusu'),
    MapItem(id: 'pasinler', name: 'Pasinler Ovası', lon: 41.7, lat: 39.97, category: 'plain', subCategory: 'tectonic', description: 'Erzurum, yüksek ova'),
    MapItem(id: 'eleskirt', name: 'Eleşkirt Ovası', lon: 42.7, lat: 39.8, category: 'plain', subCategory: 'tectonic', description: 'Ağrı, Doğu Anadolu'),
    MapItem(id: 'caldiran', name: 'Çaldıran Ovası', lon: 43.9, lat: 39.15, category: 'plain', subCategory: 'tectonic', description: 'Van, tarihi savaş alanı'),
    MapItem(id: 'igdir', name: 'Iğdır Ovası', lon: 44.0, lat: 39.9, category: 'plain', subCategory: 'tectonic', description: 'Aras vadisi, pamuk üretimi'),
    MapItem(id: 'bulanik', name: 'Bulanık Ovası', lon: 42.3, lat: 39.1, category: 'plain', subCategory: 'tectonic', description: 'Muş, Doğu Anadolu'),
    MapItem(id: 'mus', name: 'Muş Ovası', lon: 41.5, lat: 38.75, scaleX: 1.2, category: 'plain', subCategory: 'tectonic', description: 'Doğu Anadolu\'nun en büyük ovası'),
    MapItem(id: 'bingol', name: 'Bingöl Ovası', lon: 40.5, lat: 38.88, category: 'plain', subCategory: 'tectonic', description: 'Bingöl, tektonik ova'),
    MapItem(id: 'elazig', name: 'Elazığ Ovası', lon: 39.2, lat: 38.65, category: 'plain', subCategory: 'tectonic', description: 'Elazığ, Fırat vadisi'),
    MapItem(id: 'malatya', name: 'Malatya Ovası', lon: 38.3, lat: 38.35, category: 'plain', subCategory: 'tectonic', description: 'Malatya, kayısı üretimi'),
    MapItem(id: 'elbistan', name: 'Elbistan Ovası', lon: 37.2, lat: 38.2, category: 'plain', subCategory: 'tectonic', description: 'Kahramanmaraş, linyit'),
    MapItem(id: 'yuksekova', name: 'Yüksekova Ovası', lon: 44.3, lat: 37.57, category: 'plain', subCategory: 'tectonic', description: 'Hakkari, yüksek rakımlı ova'),
    // Karstik Ovalar
    MapItem(id: 'tefenni', name: 'Tefenni Ovası', lon: 29.8, lat: 37.32, category: 'plain', subCategory: 'karst', description: 'Burdur, karstik polye ovası'),
    MapItem(id: 'acipayam', name: 'Acıpayam Ovası', lon: 29.35, lat: 37.42, category: 'plain', subCategory: 'karst', description: 'Denizli, karstik polye'),
    MapItem(id: 'elmali', name: 'Elmalı Ovası', lon: 29.9, lat: 36.74, category: 'plain', subCategory: 'karst', description: 'Antalya, karstik polye'),
    MapItem(id: 'mugla_ova', name: 'Muğla Ovası', lon: 28.37, lat: 37.22, category: 'plain', subCategory: 'karst', description: 'Muğla, karstik polye'),
    // Diğer
    MapItem(id: 'harran', name: 'Harran Ovası', lon: 39.0, lat: 36.9, scaleX: 1.2, category: 'plain', subCategory: 'other', description: 'Şanlıurfa, GAP sulama'),
    MapItem(id: 'suruc', name: 'Suruç Ovası', lon: 38.4, lat: 37.0, category: 'plain', subCategory: 'other', description: 'Şanlıurfa, Suriye sınırı'),
    MapItem(id: 'maras', name: 'Maraş Ovası', lon: 36.9, lat: 37.55, category: 'plain', subCategory: 'other', description: 'Kahramanmaraş'),
    MapItem(id: 'amik', name: 'Amik Ovası', lon: 36.35, lat: 36.4, category: 'plain', subCategory: 'other', description: 'Hatay, Asi nehri, verimli tarım'),
    MapItem(id: 'antalya_ova', name: 'Antalya Ovası', lon: 30.7, lat: 36.95, scaleX: 1.2, category: 'plain', subCategory: 'other', description: 'Seracılık ve turizm'),
  ];
  static int get plainCount => plains.length;

  // ════════════════════════════════════════
  // GÖLLER
  // ════════════════════════════════════════
  static const List<MapItem> lakes = [
    // Tektonik Göller
    MapItem(id: 'van', name: 'Van Gölü', lon: 43.3, lat: 38.63, scaleX: 1.5, scaleY: 1.3, category: 'lake', subCategory: 'tectonic', description: 'Türkiye\'nin en büyük gölü, sodalı'),
    MapItem(id: 'tuz', name: 'Tuz Gölü', lon: 33.35, lat: 38.73, scaleX: 1.3, scaleY: 1.1, category: 'lake', subCategory: 'tectonic', description: 'İç Anadolu, tuz üretimi'),
    MapItem(id: 'beysehir', name: 'Beyşehir Gölü', lon: 31.73, lat: 37.73, category: 'lake', subCategory: 'tectonic', description: 'Türkiye\'nin en büyük tatlı su gölü'),
    MapItem(id: 'egirdir', name: 'Eğirdir Gölü', lon: 30.87, lat: 38.0, category: 'lake', subCategory: 'tectonic', description: 'Isparta, tatlı su'),
    MapItem(id: 'burdur', name: 'Burdur Gölü', lon: 30.3, lat: 37.72, category: 'lake', subCategory: 'tectonic', description: 'Burdur, acı su, kuş cenneti'),
    MapItem(id: 'aksehir', name: 'Akşehir Gölü', lon: 31.4, lat: 38.35, category: 'lake', subCategory: 'tectonic', description: 'Konya-Afyon, tatlı su, kuruyor'),
    MapItem(id: 'eber', name: 'Eber Gölü', lon: 30.85, lat: 38.55, category: 'lake', subCategory: 'tectonic', description: 'Afyon, Akşehir Gölü ile bağlantılı'),
    MapItem(id: 'sapanca', name: 'Sapanca Gölü', lon: 30.27, lat: 40.7, category: 'lake', subCategory: 'tectonic', description: 'Sakarya, fay hattı üzerinde'),
    MapItem(id: 'iznik', name: 'İznik Gölü', lon: 29.53, lat: 40.43, category: 'lake', subCategory: 'tectonic', description: 'Bursa, tarihi göl'),
    MapItem(id: 'ulubat', name: 'Ulubat Gölü', lon: 28.6, lat: 40.17, category: 'lake', subCategory: 'tectonic', description: 'Bursa, tatlı su, kuş cenneti'),
    MapItem(id: 'kus', name: 'Kuş (Manyas) Gölü', lon: 28.0, lat: 40.18, category: 'lake', subCategory: 'tectonic', description: 'Balıkesir, kuş cenneti milli park'),
    MapItem(id: 'marmara_gol', name: 'Marmara Gölü', lon: 28.2, lat: 38.62, category: 'lake', subCategory: 'tectonic', description: 'Manisa, İç Ege\'nin en büyük gölü'),
    MapItem(id: 'hazar', name: 'Hazar Gölü', lon: 39.43, lat: 38.47, category: 'lake', subCategory: 'tectonic', description: 'Elazığ, Doğu Anadolu fay hattı'),
    MapItem(id: 'seyfe', name: 'Seyfe Gölü', lon: 34.4, lat: 39.2, category: 'lake', subCategory: 'tectonic', description: 'Kırşehir, sığ tuzlu göl'),
    // Volkanik Set Gölleri
    MapItem(id: 'cildir', name: 'Çıldır Gölü', lon: 43.27, lat: 41.03, category: 'lake', subCategory: 'volcanic_dam', description: 'Kars, kışın donan göl'),
    MapItem(id: 'nazik', name: 'Nazik Gölü', lon: 42.47, lat: 38.93, category: 'lake', subCategory: 'volcanic_dam', description: 'Bitlis, lav seti'),
    MapItem(id: 'hacli', name: 'Haçlı Gölü', lon: 43.35, lat: 39.1, category: 'lake', subCategory: 'volcanic_dam', description: 'Van kuzeyi, volkanik set'),
    MapItem(id: 'ercek', name: 'Erçek Gölü', lon: 43.6, lat: 38.95, category: 'lake', subCategory: 'volcanic_dam', description: 'Van, tuzlu-sodalı'),
    MapItem(id: 'balik', name: 'Balık Gölü', lon: 42.6, lat: 39.6, category: 'lake', subCategory: 'volcanic_dam', description: 'Ağrı, yüksek rakımlı volkanik set'),
    MapItem(id: 'aktas', name: 'Aktaş Gölü', lon: 43.6, lat: 41.15, category: 'lake', subCategory: 'volcanic_dam', description: 'Kars-Gürcistan sınırı'),
    // Volkanik (Krater) Göller
    MapItem(id: 'nemrut_gol', name: 'Nemrut Krater Gölü', lon: 42.23, lat: 38.63, category: 'lake', subCategory: 'volcanic', description: 'Bitlis, krater içinde'),
    MapItem(id: 'acigol', name: 'Acıgöl', lon: 34.55, lat: 38.55, category: 'lake', subCategory: 'volcanic', description: 'Nevşehir, volkanik krater gölü'),
    // Heyelan Set Gölleri
    MapItem(id: 'tortum', name: 'Tortum Gölü', lon: 41.53, lat: 40.3, category: 'lake', subCategory: 'landslide', description: 'Erzurum, heyelan seti'),
    MapItem(id: 'zinav', name: 'Zinav Gölü', lon: 37.7, lat: 40.1, category: 'lake', subCategory: 'landslide', description: 'Tokat, heyelan set gölü'),
    MapItem(id: 'borabay', name: 'Borabay Gölü', lon: 36.1, lat: 40.6, category: 'lake', subCategory: 'landslide', description: 'Amasya, heyelan seti'),
    MapItem(id: 'sera', name: 'Sera Gölü', lon: 39.7, lat: 40.95, category: 'lake', subCategory: 'landslide', description: 'Trabzon, heyelan set gölü'),
    MapItem(id: 'abant', name: 'Abant Gölü', lon: 31.28, lat: 40.6, category: 'lake', subCategory: 'landslide', description: 'Bolu, heyelan seti, doğal güzellik'),
    MapItem(id: 'yedigoller', name: 'Yedigöller', lon: 31.75, lat: 40.85, category: 'lake', subCategory: 'landslide', description: 'Bolu, heyelan set gölleri, milli park'),
    // Alüvyal Set Gölleri
    MapItem(id: 'mogan', name: 'Mogan Gölü', lon: 32.8, lat: 39.78, category: 'lake', subCategory: 'alluvial', description: 'Ankara, alüvyal set gölü'),
    MapItem(id: 'eymir', name: 'Eymir Gölü', lon: 32.82, lat: 39.82, category: 'lake', subCategory: 'alluvial', description: 'Ankara, alüvyal set'),
    // Kıyı Set Gölleri
    MapItem(id: 'buyukcekmece', name: 'Büyük Çekmece Gölü', lon: 28.58, lat: 41.02, category: 'lake', subCategory: 'coastal', description: 'İstanbul, lagün kökenli kıyı set gölü'),
    MapItem(id: 'kucukcekmece', name: 'Küçük Çekmece Gölü', lon: 28.75, lat: 41.0, category: 'lake', subCategory: 'coastal', description: 'İstanbul, kıyı set gölü'),
    MapItem(id: 'terkos', name: 'Terkos (Durusu) Gölü', lon: 28.6, lat: 41.28, category: 'lake', subCategory: 'coastal', description: 'İstanbul, tatlı su, kıyı set gölü'),
    // Karstik Göller
    MapItem(id: 'sugla', name: 'Suğla Gölü', lon: 32.03, lat: 37.5, category: 'lake', subCategory: 'karst', description: 'Konya, karstik, mevsimlik'),
    MapItem(id: 'salda', name: 'Salda Gölü', lon: 29.67, lat: 37.53, category: 'lake', subCategory: 'karst', description: 'Burdur, "Türkiye\'nin Maldivleri"'),
    MapItem(id: 'bafa', name: 'Bafa Gölü', lon: 27.45, lat: 37.5, category: 'lake', subCategory: 'karst', description: 'Muğla-Aydın, denizden kopmuş'),
    MapItem(id: 'koycegiz', name: 'Köyceğiz Gölü', lon: 28.68, lat: 36.95, category: 'lake', subCategory: 'karst', description: 'Muğla, Dalyan kanalıyla denize bağlı'),
    MapItem(id: 'avlan', name: 'Avlan Gölü', lon: 29.95, lat: 37.1, category: 'lake', subCategory: 'karst', description: 'Antalya-Burdur, karstik göl'),
    // Diğer
    MapItem(id: 'gala', name: 'Gala Gölü', lon: 26.2, lat: 40.77, category: 'lake', subCategory: 'other', description: 'Edirne, Meriç deltası, sulak alan'),
  ];
  static int get lakeCount => lakes.length;

  // ════════════════════════════════════════
  // MADENLER
  // ════════════════════════════════════════
  static const List<MapItem> mines = [
    MapItem(id: 'bor', name: 'Bor', lon: 29.5, lat: 39.6, category: 'mine', description: 'Balıkesir-Eskişehir-Kütahya, dünya bor rezervinin %73\'ü'),
    MapItem(id: 'mermer_marmara', name: 'Mermer', lon: 29.0, lat: 40.0, category: 'mine', description: 'Marmara bölgesi, Bilecik-Bursa'),
    MapItem(id: 'mermer_ege', name: 'Mermer', lon: 28.5, lat: 37.8, category: 'mine', description: 'Ege bölgesi, Muğla-Afyon'),
    MapItem(id: 'manganez', name: 'Manganez', lon: 32.0, lat: 41.5, category: 'mine', description: 'Zonguldak-Bartın, Karadeniz'),
    MapItem(id: 'bakir', name: 'Bakır', lon: 34.0, lat: 41.7, category: 'mine', description: 'Kastamonu-Artvin, Karadeniz kuşağı'),
    MapItem(id: 'trona', name: 'Trona', lon: 32.0, lat: 40.0, category: 'mine', description: 'Ankara batısı, Beypazarı'),
    MapItem(id: 'tuz', name: 'Tuz', lon: 33.5, lat: 40.5, category: 'mine', description: 'Çankırı, kaya tuzu'),
    MapItem(id: 'asbest', name: 'Asbest', lon: 30.2, lat: 39.5, category: 'mine', description: 'Eskişehir'),
    MapItem(id: 'lule_tasi', name: 'Lüle Taşı', lon: 30.4, lat: 39.55, category: 'mine', description: 'Eskişehir, dünyada nadir bulunan'),
    MapItem(id: 'toryum', name: 'Toryum', lon: 30.3, lat: 39.4, category: 'mine', description: 'Eskişehir, nükleer enerji hammaddesi'),
    MapItem(id: 'uranyum_eskisehir', name: 'Uranyum', lon: 31.0, lat: 39.6, category: 'mine', description: 'Eskişehir-Kütahya, nükleer hammadde'),
    MapItem(id: 'uranyum_yozgat', name: 'Uranyum', lon: 35.5, lat: 39.0, category: 'mine', description: 'Yozgat-Sivas, nükleer hammadde'),
    MapItem(id: 'demir', name: 'Demir', lon: 38.12, lat: 39.37, category: 'mine', description: 'Divriği (Sivas), Türkiye\'nin en büyük demir madeni'),
    MapItem(id: 'oltu_tasi', name: 'Oltu Taşı', lon: 42.0, lat: 40.5, category: 'mine', description: 'Erzurum-Oltu, süs taşı'),
    MapItem(id: 'altin_civa', name: 'Altın ve Cıva', lon: 28.5, lat: 38.6, category: 'mine', description: 'Ege bölgesi, İzmir-Uşak'),
    MapItem(id: 'zimpara_tasi', name: 'Zımpara Taşı', lon: 28.0, lat: 37.5, category: 'mine', description: 'Muğla-Denizli, Ege bölgesi'),
    MapItem(id: 'krom_ege', name: 'Krom', lon: 29.0, lat: 36.8, category: 'mine', description: 'Muğla-Fethiye, Ege bölgesi'),
    MapItem(id: 'krom_dogu', name: 'Krom', lon: 39.87, lat: 38.77, category: 'mine', description: 'Guleman (Elazığ), Doğu Anadolu'),
    MapItem(id: 'kukurt', name: 'Kükürt', lon: 30.5, lat: 37.7, category: 'mine', description: 'Isparta-Burdur, İç Batı Anadolu'),
    MapItem(id: 'boksit', name: 'Boksit', lon: 31.85, lat: 37.43, category: 'mine', description: 'Seydişehir (Konya), alüminyum fabrikası'),
    MapItem(id: 'barit', name: 'Barit', lon: 30.7, lat: 36.5, category: 'mine', description: 'Antalya, Akdeniz bölgesi'),
    MapItem(id: 'fosfat', name: 'Fosfat', lon: 40.7, lat: 37.3, category: 'mine', description: 'Mardin, Güneydoğu Anadolu'),
  ];
  static int get mineCount => mines.length;

  // ════════════════════════════════════════
  // NEHİRLER (PREMIUM)
  // ════════════════════════════════════════
  static const List<MapItem> rivers = [
    // Karadeniz'e dökülenler
    MapItem(id: 'kizilirmak', name: 'Kızılırmak', lon: 34.5, lat: 40.5, category: 'river', description: 'Türkiye\'nin en uzun nehri (1355 km)'),
    MapItem(id: 'yesilirmak', name: 'Yeşilırmak', lon: 36.5, lat: 40.8, category: 'river', description: 'Çarşamba Ovası deltası'),
    MapItem(id: 'sakarya', name: 'Sakarya', lon: 30.4, lat: 40.7, category: 'river', description: 'Karadeniz\'e dökülür (824 km)'),
    MapItem(id: 'coruh', name: 'Çoruh', lon: 41.5, lat: 41.1, category: 'river', description: 'Türkiye\'nin en hızlı akan nehri'),
    MapItem(id: 'bartin', name: 'Bartın Çayı', lon: 32.35, lat: 41.65, category: 'river', description: 'Bartın, kısa Karadeniz akarsuyu'),
    MapItem(id: 'gokirmak', name: 'Gökırmak', lon: 34.0, lat: 41.5, category: 'river', description: 'Kastamonu-Sinop, Kızılırmak kolu'),
    MapItem(id: 'filyos', name: 'Filyos (Yenice)', lon: 32.0, lat: 41.55, category: 'river', description: 'Zonguldak, Batı Karadeniz'),
    MapItem(id: 'devrez', name: 'Devrez Çayı', lon: 33.5, lat: 40.8, category: 'river', description: 'Çankırı, Kızılırmak kolu'),
    MapItem(id: 'kelkit', name: 'Kelkit Çayı', lon: 38.0, lat: 40.3, category: 'river', description: 'Tokat-Sivas, Yeşilırmak kolu'),
    // Ege'ye dökülenler
    MapItem(id: 'meric', name: 'Meriç', lon: 26.5, lat: 41.7, category: 'river', description: 'Türkiye-Yunanistan sınırı'),
    MapItem(id: 'ergene', name: 'Ergene', lon: 27.0, lat: 41.3, category: 'river', description: 'Trakya, Meriç kolu'),
    MapItem(id: 'susurluk', name: 'Susurluk', lon: 28.6, lat: 40.2, category: 'river', description: 'Marmara Denizi\'ne dökülür'),
    MapItem(id: 'bakircay_nehir', name: 'Bakırçay', lon: 27.1, lat: 39.0, category: 'river', description: 'İzmir-Bergama, Ege\'ye dökülür'),
    MapItem(id: 'gediz_nehir', name: 'Gediz', lon: 27.2, lat: 38.6, category: 'river', description: 'İzmir Körfezi\'ne dökülür'),
    MapItem(id: 'k_menderes_nehir', name: 'K. Menderes', lon: 27.3, lat: 38.1, category: 'river', description: 'İzmir güneyi, Ege\'ye dökülür'),
    MapItem(id: 'b_menderes_nehir', name: 'B. Menderes', lon: 27.5, lat: 37.5, category: 'river', description: 'Menderesler yapar, Ege\'ye dökülür'),
    // Akdeniz'e dökülenler
    MapItem(id: 'dalaman', name: 'Dalaman Çayı', lon: 28.8, lat: 36.85, category: 'river', description: 'Muğla, rafting rotası'),
    MapItem(id: 'aksu', name: 'Aksu Çayı', lon: 30.8, lat: 37.1, category: 'river', description: 'Antalya, Akdeniz\'e dökülür'),
    MapItem(id: 'koprucay', name: 'Köprüçay', lon: 31.1, lat: 37.15, category: 'river', description: 'Antalya, Köprülü Kanyon'),
    MapItem(id: 'manavgat', name: 'Manavgat Çayı', lon: 31.4, lat: 36.8, category: 'river', description: 'Antalya, Manavgat Şelalesi'),
    MapItem(id: 'goksu', name: 'Göksu', lon: 33.5, lat: 36.7, category: 'river', description: 'Silifke deltası, Akdeniz\'e dökülür'),
    MapItem(id: 'seyhan', name: 'Seyhan', lon: 35.3, lat: 37.3, category: 'river', description: 'Çukurova deltası'),
    MapItem(id: 'ceyhan', name: 'Ceyhan', lon: 35.8, lat: 37.1, category: 'river', description: 'Çukurova deltası'),
    MapItem(id: 'asi', name: 'Asi (Orontes)', lon: 36.15, lat: 36.2, category: 'river', description: 'Hatay, Türkiye\'ye dışarıdan giren nehir'),
    // Basra Körfezi'ne dökülenler
    MapItem(id: 'firat', name: 'Fırat', lon: 38.5, lat: 38.5, category: 'river', description: 'En fazla enerji üreten akarsu'),
    MapItem(id: 'murat', name: 'Murat Nehri', lon: 41.5, lat: 39.0, category: 'river', description: 'Fırat\'ın en büyük kolu'),
    MapItem(id: 'karasu', name: 'Karasu', lon: 39.5, lat: 39.5, category: 'river', description: 'Fırat\'ın kolu, Erzincan'),
    MapItem(id: 'dicle', name: 'Dicle', lon: 40.5, lat: 38.0, category: 'river', description: 'Fırat ile birleşerek Şattülarap\'ı oluşturur'),
    MapItem(id: 'zap', name: 'Zap Suyu', lon: 44.0, lat: 37.5, category: 'river', description: 'Hakkari, Dicle kolu'),
    MapItem(id: 'ulucay', name: 'Uluçay', lon: 43.5, lat: 37.8, category: 'river', description: 'Şırnak-Siirt, Dicle kolu'),
    // Hazar Denizi'ne dökülenler
    MapItem(id: 'aras', name: 'Aras', lon: 43.5, lat: 40.0, category: 'river', description: 'Sınır nehri, Hazar Denizi\'ne dökülür'),
    MapItem(id: 'kura', name: 'Kura', lon: 43.8, lat: 41.1, category: 'river', description: 'Kars, Aras ile birleşir'),
    // İç Anadolu (kapalı havza)
    MapItem(id: 'ankara_cayi', name: 'Ankara Çayı', lon: 32.8, lat: 39.9, category: 'river', description: 'Ankara, Sakarya kolu'),
    MapItem(id: 'porsuk', name: 'Porsuk Çayı', lon: 30.5, lat: 39.8, category: 'river', description: 'Eskişehir, Sakarya kolu'),
    MapItem(id: 'delice', name: 'Delice Irmağı', lon: 34.5, lat: 39.7, category: 'river', description: 'Kırıkkale, Kızılırmak kolu'),
  ];
  static int get riverCount => rivers.length;

  // ════════════════════════════════════════
  // GEÇİTLER (PREMIUM)
  // ════════════════════════════════════════
  static const List<MapItem> passes = [
    MapItem(id: 'zigana_gecidi', name: 'Zigana (Kalkanlı) Geçidi', lon: 39.4, lat: 40.63, category: 'pass', description: 'Trabzon-Gümüşhane arası, Karadeniz-İç Anadolu bağlantısı'),
    MapItem(id: 'kop_gecidi', name: 'Kop (Çimen) Geçidi', lon: 40.43, lat: 40.03, category: 'pass', description: 'Bayburt-Erzurum arası'),
    MapItem(id: 'ecevit_gecidi', name: 'Ecevit Geçidi', lon: 33.75, lat: 41.55, category: 'pass', description: 'Kastamonu-İnebolu arası, Küre Dağları'),
    MapItem(id: 'ilgaz_gecidi', name: 'Ilgaz Geçidi', lon: 33.73, lat: 41.0, category: 'pass', description: 'Kastamonu-Çankırı arası, Ilgaz Dağları'),
    MapItem(id: 'bolu_gecidi', name: 'Bolu Dağı Geçidi', lon: 30.5, lat: 40.65, category: 'pass', description: 'Bolu-Adapazarı arası, İstanbul-Ankara yolu'),
    MapItem(id: 'seyve', name: 'Seyve Boğazı', lon: 30.0, lat: 40.3, category: 'pass', description: 'Bilecik-Adapazarı arası, Sakarya vadisi'),
    MapItem(id: 'gulek', name: 'Gülek Boğazı', lon: 34.8, lat: 37.28, category: 'pass', description: 'Niğde-Adana arası, Toros Dağları tarihi geçit'),
    MapItem(id: 'sertavul', name: 'Sertavul Geçidi', lon: 33.35, lat: 37.0, category: 'pass', description: 'Konya/Burdur-Mersin arası, Orta Toroslar'),
    MapItem(id: 'cubuk_gecidi', name: 'Çubuk Geçidi', lon: 30.6, lat: 37.15, category: 'pass', description: 'Burdur-Antalya arası, Batı Toroslar'),
    MapItem(id: 'belen', name: 'Belen Geçidi', lon: 36.2, lat: 36.5, category: 'pass', description: 'Hatay, Amanos (Nur) Dağları geçidi'),
  ];
  static int get passCount => passes.length;

  // ════════════════════════════════════════
  // KIYI TİPLERİ
  // ════════════════════════════════════════
  static const List<MapItem> coastalTypes = [
    MapItem(id: 'ria_bati_karadeniz', name: 'Ria Tipi Kıyı', lon: 32.5, lat: 42.0, category: 'coastal', subCategory: 'ria', description: 'Batı Karadeniz, dağlar kıyıya dik, boğulmuş vadi kıyısı'),
    MapItem(id: 'ria_dogu_karadeniz', name: 'Ria Tipi Kıyı', lon: 40.5, lat: 41.3, category: 'coastal', subCategory: 'ria', description: 'Doğu Karadeniz, Rize-Artvin, derin vadiler'),
    MapItem(id: 'dalmacya_mugla', name: 'Dalmaçya Tipi Kıyı', lon: 28.5, lat: 36.8, category: 'coastal', subCategory: 'dalmatian', description: 'Muğla-Fethiye, dağlar kıyıya paralel, ada ve yarımadalar'),
    MapItem(id: 'dalmacya_antalya', name: 'Dalmaçya Tipi Kıyı', lon: 30.5, lat: 36.5, category: 'coastal', subCategory: 'dalmatian', description: 'Antalya güneyi, Toroslar kıyıya paralel'),
    MapItem(id: 'halic_istanbul', name: 'Haliçli Kıyı', lon: 28.97, lat: 41.05, category: 'coastal', subCategory: 'estuary', description: 'İstanbul Haliç, boğulmuş akarsu vadisi'),
    MapItem(id: 'halic_izmir', name: 'Haliçli Kıyı', lon: 27.1, lat: 38.45, category: 'coastal', subCategory: 'estuary', description: 'İzmir Körfezi, doğal liman'),
    MapItem(id: 'enine_ege', name: 'Enine Kıyı', lon: 26.8, lat: 39.2, category: 'coastal', subCategory: 'transverse', description: 'Ege kıyısı, dağlar kıyıya dik, koy ve körfezler'),
    MapItem(id: 'boyuna_karadeniz', name: 'Boyuna Kıyı', lon: 36.0, lat: 41.8, category: 'coastal', subCategory: 'longitudinal', description: 'Orta Karadeniz, dağlar kıyıya paralel, düz kıyı şeridi'),
    MapItem(id: 'lagun_bafa', name: 'Lagün Kıyısı', lon: 27.5, lat: 37.5, category: 'coastal', subCategory: 'lagoon', description: 'Bafa Gölü (Muğla), denizden kopmuş lagün'),
    MapItem(id: 'lagun_kcekmece', name: 'Lagün Kıyısı', lon: 28.75, lat: 41.0, category: 'coastal', subCategory: 'lagoon', description: 'Küçükçekmece Gölü (İstanbul), kıyı lagünü'),
    MapItem(id: 'tombolo_sinop', name: 'Tombolo', lon: 35.15, lat: 42.03, category: 'coastal', subCategory: 'tombolo', description: 'Sinop yarımadası, Boztepe tombolosu'),
    MapItem(id: 'delta_cukurova', name: 'Delta Kıyısı', lon: 35.5, lat: 36.7, category: 'coastal', subCategory: 'delta', description: 'Çukurova deltası, Seyhan-Ceyhan biriktirmesi'),
    MapItem(id: 'delta_bafra', name: 'Delta Kıyısı', lon: 36.1, lat: 41.7, category: 'coastal', subCategory: 'delta', description: 'Bafra deltası, Kızılırmak ağzı'),
  ];
  static int get coastalTypeCount => coastalTypes.length;

  // ════════════════════════════════════════
  // TOPRAK ÇEŞİTLERİ (PREMIUM)
  // ════════════════════════════════════════
  static const List<MapItem> soilTypes = [
    MapItem(id: 'terra_rossa_antalya', name: 'Terra Rossa', lon: 30.7, lat: 37.1, category: 'soil', subCategory: 'terra_rossa', description: 'Antalya, Akdeniz ikliminde kırmızı toprak'),
    MapItem(id: 'terra_rossa_mugla', name: 'Terra Rossa', lon: 28.4, lat: 37.0, category: 'soil', subCategory: 'terra_rossa', description: 'Muğla, kalkerli arazide oluşur'),
    MapItem(id: 'kahverengi_orman_trabzon', name: 'Kahverengi Orman', lon: 39.7, lat: 41.0, category: 'soil', subCategory: 'brown_forest', description: 'Trabzon, nemli iklim orman toprakları'),
    MapItem(id: 'kahverengi_orman_kastamonu', name: 'Kahverengi Orman', lon: 33.8, lat: 41.4, category: 'soil', subCategory: 'brown_forest', description: 'Kastamonu, Karadeniz orman kuşağı'),
    MapItem(id: 'kahverengi_bozkir_konya', name: 'Kahverengi Bozkır', lon: 32.5, lat: 38.0, category: 'soil', subCategory: 'brown_steppe', description: 'Konya, İç Anadolu step iklimi'),
    MapItem(id: 'kahverengi_bozkir_ankara', name: 'Kahverengi Bozkır', lon: 32.8, lat: 39.5, category: 'soil', subCategory: 'brown_steppe', description: 'Ankara, yarı kurak bozkır alanları'),
    MapItem(id: 'cernozyom_erzurum', name: 'Çernozyom', lon: 41.5, lat: 39.9, category: 'soil', subCategory: 'chernozem', description: 'Erzurum-Kars, çayır altında verimli kara toprak'),
    MapItem(id: 'cernozyom_ardahan', name: 'Çernozyom', lon: 42.7, lat: 41.0, category: 'soil', subCategory: 'chernozem', description: 'Ardahan, yüksek platolarda kara toprak'),
    MapItem(id: 'kurak_kirecli', name: 'Kurak Bölge Kireçli', lon: 33.4, lat: 38.7, category: 'soil', subCategory: 'arid_calcareous', description: 'Tuz Gölü çevresi, kurak iklimde kireçli toprak'),
    MapItem(id: 'engebeli_tasli', name: 'Engebeli Arazi Sığ Taşlı', lon: 36.5, lat: 40.0, category: 'soil', subCategory: 'shallow_rocky', description: 'Dağlık alanlar, sığ ve taşlı toprak'),
    MapItem(id: 'vertisoller_trakya', name: 'Vertisoller', lon: 26.5, lat: 41.3, category: 'soil', subCategory: 'vertisol', description: 'Trakya, killi toprak, kuru-ıslak döngüsünde çatlar'),
    MapItem(id: 'volkanik_tasli', name: 'Volkanik Taşlı', lon: 43.0, lat: 39.5, category: 'soil', subCategory: 'volcanic_rocky', description: 'Doğu Anadolu, volkanik arazi toprakları'),
    MapItem(id: 'aluvyal_cukurova', name: 'Alüvyaller', lon: 35.3, lat: 37.0, category: 'soil', subCategory: 'alluvial', description: 'Çukurova, nehir biriktirmesi, en verimli topraklar'),
    MapItem(id: 'aluvyal_gediz', name: 'Alüvyaller', lon: 28.0, lat: 38.5, category: 'soil', subCategory: 'alluvial', description: 'Gediz ovası, nehir taşkın toprakları'),
    MapItem(id: 'rendzina', name: 'Rendzinalar', lon: 31.5, lat: 37.3, category: 'soil', subCategory: 'rendzina', description: 'Toroslar etekleri, kireçtaşı üzerinde ince toprak'),
  ];
  static int get soilTypeCount => soilTypes.length;

  // ════════════════════════════════════════
  // BİTKİ ÖRTÜSÜ / ORMAN TİPLERİ (PREMIUM)
  // ════════════════════════════════════════
  static const List<MapItem> vegetationTypes = [
    MapItem(id: 'maki_mugla', name: 'Maki', lon: 28.4, lat: 37.2, category: 'vegetation', subCategory: 'maquis', description: 'Muğla, Akdeniz ikliminde sert yapraklı çalı topluluğu'),
    MapItem(id: 'maki_izmir', name: 'Maki', lon: 27.0, lat: 38.4, category: 'vegetation', subCategory: 'maquis', description: 'İzmir kıyıları, zeytin-defne-mersin ağacı'),
    MapItem(id: 'maki_antalya', name: 'Maki', lon: 30.7, lat: 36.9, category: 'vegetation', subCategory: 'maquis', description: 'Antalya kıyısı, 0-800m arası'),
    MapItem(id: 'garig_ege', name: 'Garig (Frigana)', lon: 26.5, lat: 38.8, category: 'vegetation', subCategory: 'garrigue', description: 'Ege kıyısı, makinin tahrip edilmiş hali, kekik-adaçayı'),
    MapItem(id: 'psodomaki_marmara', name: 'Psödomaki', lon: 29.0, lat: 40.5, category: 'vegetation', subCategory: 'pseudomaquis', description: 'Marmara, Karadeniz iklim geçişi, defne-kocayemiş'),
    MapItem(id: 'karisik_bolu', name: 'Karışık Orman', lon: 31.6, lat: 40.7, category: 'vegetation', subCategory: 'mixed', description: 'Bolu, geniş-iğne yapraklı karışık orman'),
    MapItem(id: 'igne_artvin', name: 'İğne Yapraklı Orman', lon: 41.8, lat: 41.2, category: 'vegetation', subCategory: 'coniferous', description: 'Artvin, ladin-köknar ormanları, yüksek dağ kuşağı'),
    MapItem(id: 'genis_kastamonu', name: 'Geniş Yapraklı Orman', lon: 33.8, lat: 41.4, category: 'vegetation', subCategory: 'deciduous', description: 'Kastamonu, kayın-meşe ormanları, Karadeniz iklimi'),
    MapItem(id: 'step_konya', name: 'Step (Bozkır)', lon: 32.5, lat: 38.5, category: 'vegetation', subCategory: 'steppe', description: 'Konya, İç Anadolu kurak step bitki örtüsü'),
    MapItem(id: 'step_sivas', name: 'Step (Bozkır)', lon: 37.0, lat: 39.7, category: 'vegetation', subCategory: 'steppe', description: 'Sivas, yarı kurak bozkır, otlak alanlar'),
    MapItem(id: 'alpin_kackar', name: 'Alpin Çayır', lon: 41.0, lat: 40.8, category: 'vegetation', subCategory: 'alpine', description: 'Kaçkar Dağları, orman üst sınırı üzeri, yüksek dağ çayırı'),
    MapItem(id: 'alpin_erciyes', name: 'Alpin Çayır', lon: 35.5, lat: 38.5, category: 'vegetation', subCategory: 'alpine', description: 'Erciyes çevresi, yüksek kesimlerde ağaçsız çayır'),
    MapItem(id: 'longoz_igneada', name: 'Longoz Ormanı', lon: 27.97, lat: 41.87, category: 'vegetation', subCategory: 'longoz', description: 'İğneada, subasar orman, nadir ekosistem, UNESCO adayı'),
  ];
  static int get vegetationTypeCount => vegetationTypes.length;

  // ════════════════════════════════════════
  // TARIM ÜRÜNLERİ (PREMIUM)
  // ════════════════════════════════════════
  static const List<MapItem> agriculture = [
    MapItem(id: 'findik_giresun', name: 'Fındık', lon: 38.4, lat: 40.9, category: 'agriculture', description: 'Giresun, Türkiye dünya fındık üretiminde 1. sıra'),
    MapItem(id: 'findik_ordu', name: 'Fındık', lon: 37.9, lat: 41.0, category: 'agriculture', description: 'Ordu, Doğu Karadeniz fındık kuşağı'),
    MapItem(id: 'cay_rize', name: 'Çay', lon: 40.5, lat: 41.0, category: 'agriculture', description: 'Rize, Türkiye çay üretiminin merkezi'),
    MapItem(id: 'pamuk_adana', name: 'Pamuk', lon: 35.3, lat: 37.0, category: 'agriculture', description: 'Adana-Çukurova, pamuk tarımının başkenti'),
    MapItem(id: 'pamuk_aydin', name: 'Pamuk', lon: 27.8, lat: 37.8, category: 'agriculture', description: 'Aydın, Büyük Menderes ovası pamuk üretimi'),
    MapItem(id: 'pamuk_sanliurfa', name: 'Pamuk', lon: 38.8, lat: 37.2, category: 'agriculture', description: 'Şanlıurfa, GAP ile sulama sonrası artan üretim'),
    MapItem(id: 'zeytin_ayvalik', name: 'Zeytin', lon: 26.7, lat: 39.3, category: 'agriculture', description: 'Ayvalık (Balıkesir), zeytinyağı üretim merkezi'),
    MapItem(id: 'zeytin_gemlik', name: 'Zeytin', lon: 29.2, lat: 40.4, category: 'agriculture', description: 'Gemlik (Bursa), sofralık zeytin'),
    MapItem(id: 'uzum_manisa', name: 'Üzüm', lon: 27.4, lat: 38.6, category: 'agriculture', description: 'Manisa, çekirdeksiz üzüm, kuru üzüm ihracatı'),
    MapItem(id: 'incir_aydin', name: 'İncir', lon: 27.9, lat: 37.8, category: 'agriculture', description: 'Aydın, kuru incir üretiminde dünya lideri'),
    MapItem(id: 'fistik_gaziantep', name: 'Antep Fıstığı', lon: 37.4, lat: 37.1, category: 'agriculture', description: 'Gaziantep, Antep fıstığı üretim merkezi'),
    MapItem(id: 'bugday_konya', name: 'Buğday', lon: 32.5, lat: 37.9, category: 'agriculture', description: 'Konya, Türkiye\'nin tahıl ambarı'),
    MapItem(id: 'aycicegi_trakya', name: 'Ayçiçeği', lon: 26.7, lat: 41.4, category: 'agriculture', description: 'Trakya, ayçiçeği yağı üretim bölgesi'),
    MapItem(id: 'seker_pancar_eskisehir', name: 'Şeker Pancarı', lon: 30.5, lat: 39.8, category: 'agriculture', description: 'Eskişehir, şeker fabrikası ve pancar üretimi'),
    MapItem(id: 'turunçgil_mersin', name: 'Turunçgil', lon: 34.6, lat: 36.8, category: 'agriculture', description: 'Mersin, portakal-limon-mandalina'),
    MapItem(id: 'turunçgil_hatay', name: 'Turunçgil', lon: 36.2, lat: 36.4, category: 'agriculture', description: 'Hatay, Akdeniz turunçgil kuşağı'),
    MapItem(id: 'muz_anamur', name: 'Muz', lon: 32.8, lat: 36.1, category: 'agriculture', description: 'Anamur (Mersin), Türkiye\'nin muz üretim merkezi'),
    MapItem(id: 'kayisi_malatya', name: 'Kayısı', lon: 38.3, lat: 38.35, category: 'agriculture', description: 'Malatya, dünya kuru kayısı üretiminin %85\'i'),
  ];
  static int get agricultureCount => agriculture.length;

  // ════════════════════════════════════════
  // BÜYÜKŞEHİR İLLER (ÜCRETSİZ)
  // ════════════════════════════════════════
  static const List<MapItem> metropolitanCities = [
    MapItem(id: 'metro_istanbul', name: 'İstanbul', lon: 29.0, lat: 41.0, category: 'metropolitan', description: 'Türkiye\'nin en kalabalık şehri, 2012 büyükşehir'),
    MapItem(id: 'metro_ankara', name: 'Ankara', lon: 32.85, lat: 39.92, category: 'metropolitan', description: 'Başkent, 2012 büyükşehir'),
    MapItem(id: 'metro_izmir', name: 'İzmir', lon: 27.14, lat: 38.42, category: 'metropolitan', description: 'Ege\'nin incisi, 2012 büyükşehir'),
    MapItem(id: 'metro_bursa', name: 'Bursa', lon: 29.06, lat: 40.19, category: 'metropolitan', description: 'Osmanlı\'nın ilk başkenti, 2012 büyükşehir'),
    MapItem(id: 'metro_adana', name: 'Adana', lon: 35.33, lat: 37.0, category: 'metropolitan', description: 'Çukurova\'nın merkezi, 2012 büyükşehir'),
    MapItem(id: 'metro_antalya', name: 'Antalya', lon: 30.71, lat: 36.9, category: 'metropolitan', description: 'Turizm başkenti, 2012 büyükşehir'),
    MapItem(id: 'metro_konya', name: 'Konya', lon: 32.49, lat: 37.87, category: 'metropolitan', description: 'Yüzölçümü en büyük il, 2012 büyükşehir'),
    MapItem(id: 'metro_gaziantep', name: 'Gaziantep', lon: 37.38, lat: 37.06, category: 'metropolitan', description: 'Gastronomi şehri, 2012 büyükşehir'),
    MapItem(id: 'metro_mersin', name: 'Mersin', lon: 34.63, lat: 36.8, category: 'metropolitan', description: 'Liman şehri, 2012 büyükşehir'),
    MapItem(id: 'metro_kocaeli', name: 'Kocaeli', lon: 29.92, lat: 40.77, category: 'metropolitan', description: 'Sanayi kenti, 2012 büyükşehir'),
    MapItem(id: 'metro_diyarbakir', name: 'Diyarbakır', lon: 40.24, lat: 37.91, category: 'metropolitan', description: 'Surlarıyla ünlü, 2012 büyükşehir'),
    MapItem(id: 'metro_samsun', name: 'Samsun', lon: 36.33, lat: 41.29, category: 'metropolitan', description: '19 Mayıs şehri, 2012 büyükşehir'),
    MapItem(id: 'metro_hatay', name: 'Hatay', lon: 36.17, lat: 36.2, category: 'metropolitan', description: 'Medeniyetler beşiği, 2012 büyükşehir'),
    MapItem(id: 'metro_manisa', name: 'Manisa', lon: 27.43, lat: 38.62, category: 'metropolitan', description: 'Mesir macunu şehri, 2012 büyükşehir'),
    MapItem(id: 'metro_kayseri', name: 'Kayseri', lon: 35.48, lat: 38.73, category: 'metropolitan', description: 'Erciyes\'in şehri, 2012 büyükşehir'),
    MapItem(id: 'metro_balikesir', name: 'Balıkesir', lon: 27.88, lat: 39.65, category: 'metropolitan', description: 'Marmara-Ege geçişi, 2012 büyükşehir'),
    MapItem(id: 'metro_kahramanmaras', name: 'Kahramanmaraş', lon: 36.94, lat: 37.58, category: 'metropolitan', description: 'Dondurma şehri, 2012 büyükşehir'),
    MapItem(id: 'metro_van', name: 'Van', lon: 43.38, lat: 38.49, category: 'metropolitan', description: 'Van kedisi ve kahvaltısı, 2012 büyükşehir'),
    MapItem(id: 'metro_erzurum', name: 'Erzurum', lon: 41.28, lat: 39.9, category: 'metropolitan', description: 'Dadaş şehri, 2012 büyükşehir'),
    MapItem(id: 'metro_sakarya', name: 'Sakarya', lon: 30.4, lat: 40.69, category: 'metropolitan', description: 'Sapanca\'nın şehri, 2012 büyükşehir'),
    MapItem(id: 'metro_denizli', name: 'Denizli', lon: 29.09, lat: 37.77, category: 'metropolitan', description: 'Pamukkale\'nin şehri, 2012 büyükşehir'),
    MapItem(id: 'metro_sanliurfa', name: 'Şanlıurfa', lon: 38.79, lat: 37.16, category: 'metropolitan', description: 'Peygamberler şehri, 2012 büyükşehir'),
    MapItem(id: 'metro_malatya', name: 'Malatya', lon: 38.32, lat: 38.35, category: 'metropolitan', description: 'Kayısı başkenti, 2012 büyükşehir'),
    MapItem(id: 'metro_trabzon', name: 'Trabzon', lon: 39.72, lat: 41.0, category: 'metropolitan', description: 'Karadeniz\'in incisi, 2012 büyükşehir'),
    MapItem(id: 'metro_elazig', name: 'Elazığ', lon: 39.22, lat: 38.67, category: 'metropolitan', description: 'Hazar Gölü kıyısı, 2012 büyükşehir'),
    MapItem(id: 'metro_agri', name: 'Ağrı', lon: 43.05, lat: 39.72, category: 'metropolitan', description: 'Ararat\'ın şehri, 2012 büyükşehir'),
    MapItem(id: 'metro_eskisehir', name: 'Eskişehir', lon: 30.52, lat: 39.78, category: 'metropolitan', description: 'Üniversite şehri, 1993 büyükşehir'),
    MapItem(id: 'metro_tekirdag', name: 'Tekirdağ', lon: 27.51, lat: 41.0, category: 'metropolitan', description: 'Trakya\'nın merkezi, 2012 büyükşehir'),
    MapItem(id: 'metro_ordu', name: 'Ordu', lon: 37.88, lat: 41.0, category: 'metropolitan', description: 'Fındık diyarı, 2012 büyükşehir'),
    MapItem(id: 'metro_mugla', name: 'Muğla', lon: 28.37, lat: 37.22, category: 'metropolitan', description: 'Bodrum-Fethiye, turizm, 2012 büyükşehir'),
  ];
  static int get metropolitanCityCount => metropolitanCities.length;

  // ════════════════════════════════════════
  // KÖRFEZLER (PREMIUM)
  // ════════════════════════════════════════
  static const List<MapItem> gulfs = [
    // Marmara Denizi
    MapItem(id: 'erdek', name: 'Erdek Körfezi', lon: 27.8, lat: 40.6, category: 'gulf', subCategory: 'marmara', description: 'Marmara Denizi, Balıkesir-Kapıdağ Yarımadası güneyi'),
    MapItem(id: 'bandirma', name: 'Bandırma Körfezi', lon: 27.97, lat: 40.35, category: 'gulf', subCategory: 'marmara', description: 'Marmara Denizi, Balıkesir'),
    MapItem(id: 'gemlik', name: 'Gemlik Körfezi', lon: 29.1, lat: 40.45, category: 'gulf', subCategory: 'marmara', description: 'Marmara Denizi, Bursa, zeytin'),
    MapItem(id: 'izmit', name: 'İzmit Körfezi', lon: 29.8, lat: 40.72, category: 'gulf', subCategory: 'marmara', description: 'Marmara Denizi, Kocaeli, sanayi'),
    // Ege Denizi
    MapItem(id: 'saros', name: 'Saros Körfezi', lon: 26.6, lat: 40.5, category: 'gulf', subCategory: 'aegean', description: 'Ege Denizi, Çanakkale-Edirne, temiz deniz'),
    MapItem(id: 'edremit', name: 'Edremit Körfezi', lon: 26.9, lat: 39.5, category: 'gulf', subCategory: 'aegean', description: 'Ege Denizi, Balıkesir, zeytinlik kıyı'),
    MapItem(id: 'candarli', name: 'Çandarlı Körfezi', lon: 26.9, lat: 38.9, category: 'gulf', subCategory: 'aegean', description: 'Ege Denizi, İzmir kuzeyi'),
    MapItem(id: 'izmir_korfezi', name: 'İzmir Körfezi', lon: 26.9, lat: 38.5, category: 'gulf', subCategory: 'aegean', description: 'Ege Denizi, doğal liman, Türkiye\'nin en büyük körfezi'),
    MapItem(id: 'kusadasi', name: 'Kuşadası Körfezi', lon: 27.15, lat: 37.85, category: 'gulf', subCategory: 'aegean', description: 'Ege Denizi, Aydın, turizm ve kruvaziyer'),
    MapItem(id: 'gulluk', name: 'Güllük Körfezi', lon: 27.6, lat: 37.25, category: 'gulf', subCategory: 'aegean', description: 'Ege Denizi, Muğla, Bodrum kuzeyi'),
    MapItem(id: 'gokova', name: 'Gökova Körfezi', lon: 28.0, lat: 37.0, category: 'gulf', subCategory: 'aegean', description: 'Ege Denizi, Muğla, mavi yolculuk rotası'),
    MapItem(id: 'hisaronu', name: 'Hisarönü Körfezi', lon: 28.2, lat: 36.75, category: 'gulf', subCategory: 'aegean', description: 'Ege Denizi, Muğla-Marmaris, Datça Yarımadası'),
    MapItem(id: 'fethiye', name: 'Fethiye Körfezi', lon: 29.1, lat: 36.6, category: 'gulf', subCategory: 'aegean', description: 'Ege Denizi, Muğla, Ölüdeniz'),
    // Akdeniz
    MapItem(id: 'antalya_korfezi', name: 'Antalya Körfezi', lon: 30.6, lat: 36.6, category: 'gulf', subCategory: 'mediterranean', description: 'Akdeniz, Türkiye\'nin en büyük Akdeniz körfezi'),
    MapItem(id: 'iskenderun', name: 'İskenderun Körfezi', lon: 36.2, lat: 36.6, category: 'gulf', subCategory: 'mediterranean', description: 'Akdeniz, Hatay, liman ve sanayi'),
  ];
  static int get gulfCount => gulfs.length;
}