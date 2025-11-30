import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../config/sdk_config.dart';
import '../ads_manager.dart';

/// Native Ad Manager
/// Manages native ad loading and display
class NativeAdManager {
  NativeAd? _nativeAd;
  bool _isLoading = false;
  bool _isLoaded = false;

  String? _adUnitId;
  AdRequest? _adRequest;
  NativeAdOptions? _nativeAdOptions;

  /// Load native ad
  Future<void> loadAd({
    String? adUnitId,
    AdRequest? adRequest,
    NativeAdOptions? nativeAdOptions,
    VoidCallback? onAdLoaded,
    VoidCallback? onAdFailedToLoad,
  }) async {
    if (_isLoading || _isLoaded) {
      debugPrint('⚠️ Native ad is already loading or loaded');
      return;
    }

    // Ensure AdsManager is initialized
    if (!AdsManager.instance.isInitialized) {
      await AdsManager.instance.initialize();
    }

    _isLoading = true;

    try {
      _adUnitId = adUnitId ?? SdkConfig.getNativeAdUnitId(
        isAndroid: Platform.isAndroid,
      );
      _adRequest = adRequest ?? const AdRequest();
      _nativeAdOptions = nativeAdOptions ?? NativeAdOptions();

      // Native Template Style for displaying native ads
      final nativeTemplateStyle = NativeTemplateStyle(
        templateType: TemplateType.medium,
        mainBackgroundColor: const Color(0xFFF5F5F5),
        cornerRadius: 10.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: Colors.blue,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.grey,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 14.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.grey,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 12.0,
        ),
      );

      _nativeAd = NativeAd(
        adUnitId: _adUnitId!,
        request: _adRequest!,
        nativeAdOptions: _nativeAdOptions!,
        nativeTemplateStyle: nativeTemplateStyle,
        listener: NativeAdListener(
          onAdLoaded: (_) {
            _isLoading = false;
            _isLoaded = true;
            debugPrint('✅ Native ad loaded successfully');
            onAdLoaded?.call();
          },
          onAdFailedToLoad: (ad, error) {
            _isLoading = false;
            _isLoaded = false;
            debugPrint('❌ Native ad failed to load: ${error.message}');
            ad.dispose();
            _nativeAd = null;
            onAdFailedToLoad?.call();
          },
          onAdOpened: (_) {
            debugPrint('📱 Native ad opened');
          },
          onAdClosed: (_) {
            debugPrint('📱 Native ad closed');
          },
          onAdImpression: (_) {
            debugPrint('👁️ Native ad impression recorded');
          },
          onAdClicked: (_) {
            debugPrint('👆 Native ad clicked');
          },
        ),
      );

      await _nativeAd!.load();
    } catch (e) {
      _isLoading = false;
      _isLoaded = false;
      debugPrint('❌ Error loading native ad: $e');
      onAdFailedToLoad?.call();
    }
  }

  /// Get native ad instance
  /// Returns null if ad is not loaded
  NativeAd? get nativeAd => _isLoaded ? _nativeAd : null;

  /// Check if ad is loaded
  bool get isLoaded => _isLoaded && _nativeAd != null;

  /// Check if ad is loading
  bool get isLoading => _isLoading;

  /// Get current ad unit ID
  String? get adUnitId => _adUnitId;

  /// Dispose native ad
  void dispose() {
    _nativeAd?.dispose();
    _nativeAd = null;
    _isLoaded = false;
    _isLoading = false;
    debugPrint('🗑️ Native ad disposed');
  }

  /// Reload native ad
  Future<void> reload({
    VoidCallback? onAdLoaded,
    VoidCallback? onAdFailedToLoad,
  }) async {
    dispose();
    await loadAd(
      adUnitId: _adUnitId,
      adRequest: _adRequest,
      nativeAdOptions: _nativeAdOptions,
      onAdLoaded: onAdLoaded,
      onAdFailedToLoad: onAdFailedToLoad,
    );
  }
}

