import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../config/sdk_config.dart';
import '../ads_manager.dart';

/// Banner Ad Manager
/// Manages banner ad loading and display
class BannerAdManager {
  BannerAd? _bannerAd;
  bool _isLoading = false;
  bool _isLoaded = false;

  String? _adUnitId;
  AdSize? _adSize;
  AdRequest? _adRequest;

  /// Load banner ad
  Future<void> loadAd({
    String? adUnitId,
    AdSize? adSize,
    AdRequest? adRequest,
    VoidCallback? onAdLoaded,
    VoidCallback? onAdFailedToLoad,
  }) async {
    if (_isLoading || _isLoaded) {
      debugPrint('⚠️ Banner ad is already loading or loaded');
      return;
    }

    // Ensure AdsManager is initialized
    if (!AdsManager.instance.isInitialized) {
      await AdsManager.instance.initialize();
    }

    _isLoading = true;

    try {
      _adUnitId = adUnitId ?? SdkConfig.getBannerAdUnitId(
        isAndroid: Platform.isAndroid,
      );
      _adSize = adSize ?? AdSize.banner;
      _adRequest = adRequest ?? const AdRequest();

      _bannerAd = BannerAd(
        adUnitId: _adUnitId!,
        size: _adSize!,
        request: _adRequest!,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            _isLoading = false;
            _isLoaded = true;
            debugPrint('✅ Banner ad loaded successfully');
            onAdLoaded?.call();
          },
          onAdFailedToLoad: (ad, error) {
            _isLoading = false;
            _isLoaded = false;
            debugPrint('❌ Banner ad failed to load: ${error.message}');
            ad.dispose();
            _bannerAd = null;
            onAdFailedToLoad?.call();
          },
          onAdOpened: (_) {
            debugPrint('📱 Banner ad opened');
          },
          onAdClosed: (_) {
            debugPrint('📱 Banner ad closed');
          },
        ),
      );

      await _bannerAd!.load();
    } catch (e) {
      _isLoading = false;
      _isLoaded = false;
      debugPrint('❌ Error loading banner ad: $e');
      onAdFailedToLoad?.call();
    }
  }

  /// Get banner ad widget
  /// Returns null if ad is not loaded
  Widget? getAdWidget() {
    if (_bannerAd != null && _isLoaded) {
      return AdWidget(ad: _bannerAd!);
    }
    return null;
  }

  /// Check if ad is loaded
  bool get isLoaded => _isLoaded && _bannerAd != null;

  /// Check if ad is loading
  bool get isLoading => _isLoading;

  /// Dispose banner ad
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isLoaded = false;
    _isLoading = false;
    debugPrint('🗑️ Banner ad disposed');
  }

  /// Reload banner ad
  Future<void> reload({
    VoidCallback? onAdLoaded,
    VoidCallback? onAdFailedToLoad,
  }) async {
    dispose();
    await loadAd(
      adUnitId: _adUnitId,
      adSize: _adSize,
      adRequest: _adRequest,
      onAdLoaded: onAdLoaded,
      onAdFailedToLoad: onAdFailedToLoad,
    );
  }
}

