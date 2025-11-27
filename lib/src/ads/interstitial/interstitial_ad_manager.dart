import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../config/sdk_config.dart';
import '../ads_manager.dart';

/// Interstitial Ad Manager
/// Manages interstitial ad loading and display
class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  bool _isLoading = false;
  bool _isLoaded = false;

  String? _adUnitId;
  AdRequest? _adRequest;

  /// Load interstitial ad
  Future<void> loadAd({
    String? adUnitId,
    AdRequest? adRequest,
    VoidCallback? onAdLoaded,
    VoidCallback? onAdFailedToLoad,
    VoidCallback? onAdDismissed,
  }) async {
    if (_isLoading || _isLoaded) {
      debugPrint('⚠️ Interstitial ad is already loading or loaded');
      return;
    }

    // Ensure AdsManager is initialized
    if (!AdsManager.instance.isInitialized) {
      await AdsManager.instance.initialize();
    }

    _isLoading = true;

    try {
      _adUnitId = adUnitId ?? SdkConfig.getInterstitialAdUnitId(
        isAndroid: Platform.isAndroid,
      );
      _adRequest = adRequest ?? const AdRequest();

      await InterstitialAd.load(
        adUnitId: _adUnitId!,
        request: _adRequest!,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isLoading = false;
            _isLoaded = true;
            debugPrint('✅ Interstitial ad loaded successfully');

            // Set full screen content callbacks
            _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                debugPrint('📱 Interstitial ad dismissed');
                ad.dispose();
                _interstitialAd = null;
                _isLoaded = false;
                onAdDismissed?.call();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                debugPrint('❌ Interstitial ad failed to show: ${error.message}');
                ad.dispose();
                _interstitialAd = null;
                _isLoaded = false;
              },
              onAdShowedFullScreenContent: (_) {
                debugPrint('📱 Interstitial ad showed');
              },
            );

            onAdLoaded?.call();
          },
          onAdFailedToLoad: (error) {
            _isLoading = false;
            _isLoaded = false;
            debugPrint('❌ Interstitial ad failed to load: ${error.message}');
            onAdFailedToLoad?.call();
          },
        ),
      );
    } catch (e) {
      _isLoading = false;
      _isLoaded = false;
      debugPrint('❌ Error loading interstitial ad: $e');
      onAdFailedToLoad?.call();
    }
  }

  /// Show interstitial ad
  /// Returns true if ad was shown, false if ad is not loaded
  bool showAd() {
    if (_interstitialAd != null && _isLoaded) {
      _interstitialAd!.show();
      return true;
    }
    debugPrint('⚠️ Interstitial ad is not loaded');
    return false;
  }

  /// Check if ad is loaded
  bool get isLoaded => _isLoaded && _interstitialAd != null;

  /// Check if ad is loading
  bool get isLoading => _isLoading;

  /// Dispose interstitial ad
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isLoaded = false;
    _isLoading = false;
    debugPrint('🗑️ Interstitial ad disposed');
  }

  /// Preload next interstitial ad
  Future<void> preload({
    VoidCallback? onAdLoaded,
    VoidCallback? onAdFailedToLoad,
    VoidCallback? onAdDismissed,
  }) async {
    dispose();
    await loadAd(
      adUnitId: _adUnitId,
      adRequest: _adRequest,
      onAdLoaded: onAdLoaded,
      onAdFailedToLoad: onAdFailedToLoad,
      onAdDismissed: onAdDismissed,
    );
  }
}

