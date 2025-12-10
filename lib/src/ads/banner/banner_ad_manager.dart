import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../config/sdk_config.dart';
import '../ads_manager.dart';

/// Banner Ad Manager
/// Manages banner ad loading and display with adaptive banner support
class BannerAdManager {
  BannerAd? _bannerAd;
  bool _isLoading = false;
  bool _isLoaded = false;

  String? _adUnitId;
  AdSize? _adSize;
  AdRequest? _adRequest;

  /// Load banner ad with adaptive size
  /// If width is provided, uses adaptive banner size. Otherwise falls back to standard banner.
  Future<void> loadAd({
    String? adUnitId,
    AdSize? adSize,
    AdRequest? adRequest,
    int? width, // Screen width in pixels for adaptive banner
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
      
      // Use adaptive banner if width is provided, otherwise use provided adSize or default banner
      if (adSize != null) {
        _adSize = adSize;
      } else if (width != null) {
        // Use adaptive banner size based on current orientation
        try {
          final adaptiveSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
          if (adaptiveSize == null) {
            debugPrint('⚠️ Failed to get adaptive banner size, falling back to standard banner');
            _adSize = AdSize.banner;
          } else {
            _adSize = adaptiveSize;
            debugPrint('✅ Using adaptive banner size: ${adaptiveSize.width}x${adaptiveSize.height}');
          }
        } catch (e) {
          debugPrint('⚠️ Error getting adaptive banner size: $e, falling back to standard banner');
          _adSize = AdSize.banner;
        }
      } else {
        // Fallback to standard banner if no width provided
        _adSize = AdSize.banner;
        debugPrint('⚠️ No width provided, using standard banner size');
      }
      
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
            debugPrint('   Error code: ${error.code}');
            debugPrint('   Error domain: ${error.domain}');
            debugPrint('   Response info: ${error.responseInfo}');
            
            if (error.code == 3) {
              debugPrint('⚠️ Ad unit ID may not be approved yet or has no ads to serve');
              debugPrint('   Check AdMob console: https://apps.admob.com/');
              debugPrint('   Ad Unit ID: $_adUnitId');
            }
            
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

  /// Get current ad size (useful for getting adaptive banner height)
  AdSize? get adSize => _adSize;

  /// Get banner height (for adaptive banners, returns actual height; otherwise returns standard banner height)
  double get bannerHeight => _adSize?.height.toDouble() ?? 50.0;

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
    int? width,
    VoidCallback? onAdLoaded,
    VoidCallback? onAdFailedToLoad,
  }) async {
    dispose();
    await loadAd(
      adUnitId: _adUnitId,
      adSize: _adSize,
      adRequest: _adRequest,
      width: width,
      onAdLoaded: onAdLoaded,
      onAdFailedToLoad: onAdFailedToLoad,
    );
  }
}

