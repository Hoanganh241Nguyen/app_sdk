import 'package:flutter/foundation.dart';

/// SDK Configuration
/// Contains AdMob App IDs and Ad Unit IDs
class SdkConfig {
  SdkConfig._();

  // AdMob App IDs (Test IDs from Google)
  static const String androidAdMobAppId = 'ca-app-pub-3940256099942544~3347511713'; // Test ID
  static const String iosAdMobAppId = 'ca-app-pub-3940256099942544~1458002511'; // Test ID

  // Test Ad Unit IDs (Google's default test IDs)
  static const String testBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String testInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712';
  static const String testRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  static const String testAppOpenAdUnitId = 'ca-app-pub-3940256099942544/3419835294';
  static const String testNativeAdUnitId = 'ca-app-pub-3940256099942544/2247696110';

  // Production Ad Unit IDs - Replace with your actual ad unit IDs
  // Banner Ads
  static const String androidBannerAdUnitId = 'ca-app-pub-7111629496407310/5401361879'; // Production ID (Splash)
  static const String iosBannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716'; // Test ID
  
  // Banner Home Ads
  static const String androidBannerHomeAdUnitId = 'ca-app-pub-7111629496407310/2385150449'; // Production ID (Home)
  static const String iosBannerHomeAdUnitId = 'ca-app-pub-3940256099942544/2934735716'; // Test ID

  // Interstitial Ads
  static const String androidInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712'; // Test ID
  static const String iosInterstitialAdUnitId = 'ca-app-pub-3940256099942544/4411468910'; // Test ID

  // Rewarded Ads
  static const String androidRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917'; // Test ID
  static const String iosRewardedAdUnitId = 'ca-app-pub-3940256099942544/1712485313'; // Test ID

  // App Open Ads
  static const String androidAppOpenAdUnitId = 'ca-app-pub-7111629496407310/5572397044'; // Production ID
  static const String iosAppOpenAdUnitId = 'ca-app-pub-3940256099942544/5662855259'; // Test ID

  // Native Ads
  static const String androidNativeAdUnitId = 'ca-app-pub-3940256099942544/2247696110'; // Test ID
  static const String iosNativeAdUnitId = 'ca-app-pub-3940256099942544/2934735716'; // Test ID
  
  // Native Phrasebook Ads (dedicated for phrasebook screen)
  static const String androidNativePhrasebookAdUnitId = 'ca-app-pub-3940256099942544/2247696110'; // Test ID (replace with production ID)
  static const String iosNativePhrasebookAdUnitId = 'ca-app-pub-3940256099942544/2934735716'; // Test ID (replace with production ID)

  /// Get AdMob App ID based on platform
  static String getAdMobAppId({required bool isAndroid}) {
    return isAndroid ? androidAdMobAppId : iosAdMobAppId;
  }

  /// Get Banner Ad Unit ID based on platform
  /// Returns test ID if in debug mode, otherwise returns production ID
  static String getBannerAdUnitId({required bool isAndroid}) {
    if (kDebugMode) return testBannerAdUnitId;
    return isAndroid ? androidBannerAdUnitId : iosBannerAdUnitId;
  }

  /// Get Banner Home Ad Unit ID based on platform
  /// Returns test ID if in debug mode, otherwise returns production ID
  static String getBannerHomeAdUnitId({required bool isAndroid}) {
    if (kDebugMode) return testBannerAdUnitId;
    return isAndroid ? androidBannerHomeAdUnitId : iosBannerHomeAdUnitId;
  }

  /// Get Interstitial Ad Unit ID based on platform
  /// Returns test ID if in debug mode, otherwise returns production ID
  static String getInterstitialAdUnitId({required bool isAndroid}) {
    if (kDebugMode) return testInterstitialAdUnitId;
    return isAndroid ? androidInterstitialAdUnitId : iosInterstitialAdUnitId;
  }

  /// Get Rewarded Ad Unit ID based on platform
  /// Returns test ID if in debug mode, otherwise returns production ID
  static String getRewardedAdUnitId({required bool isAndroid}) {
    if (kDebugMode) return testRewardedAdUnitId;
    return isAndroid ? androidRewardedAdUnitId : iosRewardedAdUnitId;
  }

  /// Get App Open Ad Unit ID based on platform
  /// Returns test ID if in debug mode, otherwise returns production ID
  static String getAppOpenAdUnitId({required bool isAndroid}) {
    if (kDebugMode) return testAppOpenAdUnitId;
    return isAndroid ? androidAppOpenAdUnitId : iosAppOpenAdUnitId;
  }

  /// Get Native Ad Unit ID based on platform
  /// Returns test ID if in debug mode, otherwise returns production ID
  static String getNativeAdUnitId({required bool isAndroid}) {
    if (kDebugMode) return testNativeAdUnitId;
    return isAndroid ? androidNativeAdUnitId : iosNativeAdUnitId;
  }

  /// Get Native Phrasebook Ad Unit ID based on platform
  /// Returns test ID if in debug mode, otherwise returns production ID
  /// Dedicated native ad unit for phrasebook screen
  static String getNativePhrasebookAdUnitId({required bool isAndroid}) {
    if (kDebugMode) return testNativeAdUnitId;
    return isAndroid ? androidNativePhrasebookAdUnitId : iosNativePhrasebookAdUnitId;
  }
}

