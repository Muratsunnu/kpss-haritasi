import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PremiumManager {
  static final PremiumManager _instance = PremiumManager._();
  factory PremiumManager() => _instance;
  PremiumManager._();

  static const String _productId = 'premium_lifetime';
  static const String _premiumKey = 'is_premium';

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _isPremium = false;

  bool get isPremium => _isPremium;

  Future<void> init() async {
    // Local cache'ten yükle
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool(_premiumKey) ?? false;

    // Firestore'dan kontrol et
    await checkCloudPremium();

    // Satın alma dinleyicisi başlat
    final available = await _iap.isAvailable();
    if (!available) return;

    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: (error) {},
    );

    // Bekleyen satın almaları tamamla
    await _iap.restorePurchases();
  }

  /// Firestore'dan premium durumu kontrol et
  Future<void> checkCloudPremium() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        final cloudPremium = doc.data()?['isPremium'] ?? false;
        if (cloudPremium && !_isPremium) {
          _isPremium = true;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(_premiumKey, true);
        }
      }
    } catch (_) {}
  }

  /// Satın alma güncelleme callback'i
  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.productID == _productId) {
        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          _grantPremium();
        }

        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      }
    }
  }

  /// Premium'u aktif et — local + Firestore
  Future<void> _grantPremium() async {
    _isPremium = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_premiumKey, true);

    // Firestore'a da kaydet
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'isPremium': true,
        });
      } catch (_) {}
    }
  }

  /// Satın alma başlat
  Future<bool> buyPremium() async {
    final available = await _iap.isAvailable();
    if (!available) return false;

    final response = await _iap.queryProductDetails({_productId});
    if (response.productDetails.isEmpty) return false;

    final product = response.productDetails.first;
    final purchaseParam = PurchaseParam(productDetails: product);
    return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Satın almayı geri yükle
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  /// Çıkış yapıldığında local cache temizle (cloud'da kalır)
  Future<void> clearLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_premiumKey);
    _isPremium = false;
  }

  void dispose() {
    _subscription?.cancel();
  }
}
