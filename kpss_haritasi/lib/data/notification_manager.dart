import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._();
  factory NotificationManager() => _instance;
  NotificationManager._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static const String _enabledKey = 'notifications_enabled';
  static const int _dailyNotifId = 1001;

  static const List<String> _facts = [
    '🏔️ Türkiye\'nin en yüksek dağı Ağrı Dağı\'dır (5137 m).',
    '💧 Van Gölü, Türkiye\'nin en büyük gölüdür ve dünyanın en büyük sodalı gölüdür.',
    '🌊 Türkiye\'nin en uzun nehri Kızılırmak\'tır (1355 km).',
    '🌾 Çukurova, Türkiye\'nin en verimli delta ovasıdır.',
    '⚒️ Türkiye dünya bor rezervinin %73\'üne sahiptir.',
    '🏔️ Erzurum-Kars Platosu, Türkiye\'nin en yüksek ve en geniş platosudur.',
    '⛰️ Kaçkar Dağları, Karadeniz Bölgesi\'nin en yüksek noktasıdır (3932 m).',
    '💧 Beyşehir Gölü Türkiye\'nin en büyük tatlı su gölüdür.',
    '🌾 Konya Ovası, Türkiye\'nin en büyük ovasıdır.',
    '🌋 Nemrut Dağı (Bitlis) volkanik bir dağdır ve krater gölüyle ünlüdür.',
    '⛰️ Erciyes Dağı, İç Anadolu\'nun en yüksek noktasıdır (3917 m).',
    '🌊 Fırat, üzerindeki barajlarla Türkiye\'nin en fazla enerji üreten akarsuyudur.',
    '💧 Tuz Gölü, Türkiye\'nin tuz ihtiyacının büyük kısmını karşılar.',
    '⛰️ Kaz Dağları (İda) Ege Bölgesi\'ndeki kırık (horst) dağlardandır.',
    '💧 Tortum Gölü heyelan sonucu oluşmuş doğal bir set gölüdür.',
    '⚒️ Divriği (Sivas) Türkiye\'nin en büyük demir madeni yatağıdır.',
    '🏔️ Taşeli ve Teke platoları karstik yapıdadır.',
    '💧 Çıldır Gölü kışın tamamen donar, üzerinde atlı kızak yapılır.',
    '🌾 Harran Ovası GAP ile sulanan önemli tarım alanıdır.',
    '⛰️ Uludağ, Marmara Bölgesi\'nin en yüksek dağıdır (2543 m).',
    '💧 Sapanca Gölü Kuzey Anadolu Fay Hattı üzerindedir.',
    '⚒️ Seydişehir (Konya) Türkiye\'nin en önemli boksit yatağıdır.',
    '🌊 Asi Nehri, Türkiye\'ye dışarıdan giren tek nehirdir.',
    '🏔️ Kapadokya Platosu volkanik tüflerden oluşan peri bacalarıyla ünlüdür.',
    '💧 Köyceğiz Gölü Dalyan kanalıyla denize bağlıdır.',
    '🌊 Çoruh Nehri Türkiye\'nin en hızlı akan nehridir.',
    '🌾 Malatya dünya kuru kayısı üretiminde liderdir.',
    '⛰️ Nur (Amanos) Dağları Hatay\'daki kırık dağlardandır.',
    '💧 Salda Gölü karstik oluşumlu ve Türkiye\'nin Maldivleri olarak bilinir.',
    '🌾 Rize, Türkiye\'nin çay üretim merkezidir.',
  ];

  Future<void> init() async {
    tz_data.initializeTimeZones();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings));
  }

  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) { final granted = await android.requestNotificationsPermission(); return granted ?? false; }
    return true;
  }

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? true;
  }

  Future<void> toggle() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getBool(_enabledKey) ?? true;
    final newValue = !current;
    await prefs.setBool(_enabledKey, newValue);
    if (newValue) { await scheduleDailyNotification(); } else { await cancelAll(); }
  }

  Future<void> scheduleDailyNotification() async {
    final enabled = await isEnabled();
    if (!enabled) return;

    await _plugin.cancel(id: _dailyNotifId);

    final random = Random();
    final fact = _facts[random.nextInt(_facts.length)];

    final location = tz.getLocation('Europe/Istanbul');
    final now = tz.TZDateTime.now(location);
    var scheduled = tz.TZDateTime(location, now.year, now.month, now.day, 20, 0);
    if (scheduled.isBefore(now)) scheduled = scheduled.add(const Duration(days: 1));

    await _plugin.zonedSchedule(
      id: _dailyNotifId,
      title: '📚 Günlük Coğrafya Bilgisi',
      body: fact,
      scheduledDate: scheduled,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('daily_fact', 'Günlük Bilgi',
          channelDescription: 'Günlük coğrafya bilgisi', importance: Importance.high, priority: Priority.defaultPriority),
        iOS: DarwinNotificationDetails()),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyReminder() async { await _plugin.cancel(id: _dailyNotifId); }
  Future<void> cancelAll() async { await _plugin.cancelAll(); }
}