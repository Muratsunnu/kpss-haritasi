import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'premium_manager.dart';

class AdManager {
  static final AdManager _instance = AdManager._();
  factory AdManager() => _instance;
  AdManager._();

  // ─── Gerçek ID'ler ───
  static const String _bannerId = 'ca-app-pub-5996122310007444/4406124455';
  static const String _interstitialId = 'ca-app-pub-5996122310007444/4022981074';
  static const String _rewardedId = 'ca-app-pub-5996122310007444/7850545445';

  // ─── Test ID'leri (geliştirme sırasında bunları kullan) ───
  static const bool _useTestAds = false; // Yayınlamadan önce false yap!

  static String get bannerAdUnitId {
    if (_useTestAds) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
    return _bannerId;
  }

  static String get interstitialAdUnitId {
    if (_useTestAds) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910';
    }
    return _interstitialId;
  }

  static String get rewardedAdUnitId {
    if (_useTestAds) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313';
    }
    return _rewardedId;
  }

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _interstitialReady = false;
  bool _rewardedReady = false;
  int _quizCount = 0; // Kaç quizde bir geçiş reklamı gösterilecek

  Future<void> init() async {
    await MobileAds.instance.initialize();
    _loadInterstitial();
    _loadRewarded();
  }

  // ════════ BANNER ════════

  /// Banner reklam oluştur — premium değilse göster
  BannerAd? createBanner() {
    if (PremiumManager().isPremium) return null;

    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  // ════════ INTERSTITIAL (GEÇİŞ) ════════

  void _loadInterstitial() {
    if (PremiumManager().isPremium) return;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialReady = true;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialReady = false;
              _loadInterstitial(); // Yeni reklam yükle
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialReady = false;
              _loadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _interstitialReady = false;
        },
      ),
    );
  }

  /// Quiz tamamlandığında çağır — her 3 quizde bir geçiş reklamı gösterir
  void showInterstitialIfReady() {
    if (PremiumManager().isPremium) return;

    _quizCount++;
    if (_quizCount % 3 == 0 && _interstitialReady && _interstitialAd != null) {
      _interstitialAd!.show();
    }
  }

  // ════════ REWARDED (ÖDÜLLÜ) ════════

  void _loadRewarded() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedReady = true;
        },
        onAdFailedToLoad: (error) {
          _rewardedReady = false;
        },
      ),
    );
  }

  bool get isRewardedReady => _rewardedReady;

  /// Ödüllü reklam göster — callback ile ödül ver
  void showRewarded({required Function() onReward}) {
    if (!_rewardedReady || _rewardedAd == null) return;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedReady = false;
        _loadRewarded();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedReady = false;
        _loadRewarded();
      },
    );

    _rewardedAd!.show(onUserEarnedReward: (ad, reward) {
      onReward();
    });
  }

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}