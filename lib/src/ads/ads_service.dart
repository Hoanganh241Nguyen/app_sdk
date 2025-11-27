import 'dart:ui';

import 'package:app_sdk/src/ads/banner/banner_ad_manager.dart';
import 'package:app_sdk/src/ads/interstitial/interstitial_ad_manager.dart';
import 'package:app_sdk/src/ads/rewarded/rewarded_ad_manager.dart';
import 'package:app_sdk/src/ads/app_open/app_open_ad_manager.dart';

/// Ads Service
/// Centralized service to manage all ad types
/// Can be integrated with Remote Config to enable/disable ads
class AdsService {
  static AdsService? _instance;
  static AdsService get instance => _instance ??= AdsService._internal();
  
  AdsService._internal();

  final BannerAdManager _bannerManager = BannerAdManager();
  final InterstitialAdManager _interstitialManager = InterstitialAdManager();
  final RewardedAdManager _rewardedManager = RewardedAdManager();
  final AppOpenAdManager _appOpenManager = AppOpenAdManager();

  // Remote Config integration callbacks
  bool Function()? _shouldShowBannerHome;
  bool Function()? _shouldShowBannerSplash;
  bool Function()? _shouldShowInterSplash;

  /// Set Remote Config callbacks
  void setRemoteConfigCallbacks({
    required bool Function() shouldShowBannerHome,
    required bool Function() shouldShowBannerSplash,
    required bool Function() shouldShowInterSplash,
  }) {
    _shouldShowBannerHome = shouldShowBannerHome;
    _shouldShowBannerSplash = shouldShowBannerSplash;
    _shouldShowInterSplash = shouldShowInterSplash;
  }

  /// Get Banner Ad Manager
  BannerAdManager get bannerManager => _bannerManager;

  /// Get Interstitial Ad Manager
  InterstitialAdManager get interstitialManager => _interstitialManager;

  /// Get Rewarded Ad Manager
  RewardedAdManager get rewardedManager => _rewardedManager;

  /// Get App Open Ad Manager
  AppOpenAdManager get appOpenManager => _appOpenManager;

  /// Load banner ad for home screen
  /// Checks Remote Config before loading
  Future<void> loadBannerHome({
    VoidCallback? onAdLoaded,
    VoidCallback? onAdFailedToLoad,
  }) async {
    if (_shouldShowBannerHome != null && !_shouldShowBannerHome!()) {
      return;
    }
    await _bannerManager.loadAd(
      onAdLoaded: onAdLoaded,
      onAdFailedToLoad: onAdFailedToLoad,
    );
  }

  /// Load banner ad for splash screen
  /// Checks Remote Config before loading
  Future<void> loadBannerSplash({
    VoidCallback? onAdLoaded,
    VoidCallback? onAdFailedToLoad,
  }) async {
    if (_shouldShowBannerSplash != null && !_shouldShowBannerSplash!()) {
      return;
    }
    await _bannerManager.loadAd(
      onAdLoaded: onAdLoaded,
      onAdFailedToLoad: onAdFailedToLoad,
    );
  }

  /// Load interstitial ad for splash screen
  /// Checks Remote Config before loading
  Future<void> loadInterSplash({
    VoidCallback? onAdLoaded,
    VoidCallback? onAdFailedToLoad,
    VoidCallback? onAdDismissed,
  }) async {
    if (_shouldShowInterSplash != null && !_shouldShowInterSplash!()) {
      return;
    }
    await _interstitialManager.loadAd(
      onAdLoaded: onAdLoaded,
      onAdFailedToLoad: onAdFailedToLoad,
      onAdDismissed: onAdDismissed,
    );
  }

  /// Show interstitial ad for splash screen
  /// Checks Remote Config before showing
  bool showInterSplash() {
    if (_shouldShowInterSplash != null && !_shouldShowInterSplash!()) {
      return false;
    }
    return _interstitialManager.showAd();
  }

  /// Dispose all ads
  void disposeAll() {
    _bannerManager.dispose();
    _interstitialManager.dispose();
    _rewardedManager.dispose();
    _appOpenManager.dispose();
  }
}

