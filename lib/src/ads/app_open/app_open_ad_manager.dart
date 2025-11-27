import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../config/sdk_config.dart';
import '../ads_manager.dart';

/// App Open Ad Manager
/// Manages app open ad loading and display
class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isLoading = false;
  bool _isLoaded = false;
  bool _isShowing = false;

  String? _adUnitId;
  AdRequest? _adRequest;

  /// Load app open ad
  Future<void> loadAd({
    String? adUnitId,
    AdRequest? adRequest,
    VoidCallback? onAdLoaded,
    VoidCallback? onAdFailedToLoad,
    VoidCallback? onAdDismissed,
  }) async {
    if (_isLoading || _isLoaded) {
      debugPrint('⚠️ App Open ad is already loading or loaded');
      return;
    }

    // Ensure AdsManager is initialized
    if (!AdsManager.instance.isInitialized) {
      await AdsManager.instance.initialize();
    }

    _isLoading = true;

    try {
      _adUnitId = adUnitId ?? SdkConfig.getAppOpenAdUnitId(
        isAndroid: Platform.isAndroid,
      );
      _adRequest = adRequest ?? const AdRequest();

      await AppOpenAd.load(
        adUnitId: _adUnitId!,
        request: _adRequest!,
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _appOpenAd = ad;
            _isLoading = false;
            _isLoaded = true;
            debugPrint('✅ App Open ad loaded successfully');

            // Set full screen content callbacks
            _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                debugPrint('📱 App Open ad dismissed');
                ad.dispose();
                _appOpenAd = null;
                _isLoaded = false;
                _isShowing = false;
                onAdDismissed?.call();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                debugPrint('❌ App Open ad failed to show: ${error.message}');
                ad.dispose();
                _appOpenAd = null;
                _isLoaded = false;
                _isShowing = false;
              },
              onAdShowedFullScreenContent: (_) {
                debugPrint('📱 App Open ad showed');
                _isShowing = true;
              },
            );

            onAdLoaded?.call();
          },
          onAdFailedToLoad: (error) {
            _isLoading = false;
            _isLoaded = false;
            debugPrint('❌ App Open ad failed to load: ${error.message}');
            onAdFailedToLoad?.call();
          },
        ),
      );
    } catch (e) {
      _isLoading = false;
      _isLoaded = false;
      debugPrint('❌ Error loading app open ad: $e');
      onAdFailedToLoad?.call();
    }
  }

  /// Show app open ad
  /// Returns true if ad was shown, false if ad is not loaded
  bool showAd() {
    if (_appOpenAd != null && _isLoaded && !_isShowing) {
      _appOpenAd!.show();
      return true;
    }
    debugPrint('⚠️ App Open ad is not loaded or already showing');
    return false;
  }

  /// Check if ad is loaded
  bool get isLoaded => _isLoaded && _appOpenAd != null;

  /// Check if ad is loading
  bool get isLoading => _isLoading;

  /// Check if ad is showing
  bool get isShowing => _isShowing;

  /// Dispose app open ad
  void dispose() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _isLoaded = false;
    _isLoading = false;
    _isShowing = false;
    debugPrint('🗑️ App Open ad disposed');
  }

  /// Preload next app open ad
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

