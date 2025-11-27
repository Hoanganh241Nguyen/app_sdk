/// SDK Configuration
/// Contains AdMob App IDs and Ad Unit IDs
class SdkConfig {
  SdkConfig._();

  // AdMob App IDs
  static const String androidAdMobAppId = 'ca-app-pub-3940256099942544~3347511713'; // Test ID
  static const String iosAdMobAppId = 'ca-app-pub-3940256099942544~1458002511'; // Test ID

  // Ad Unit IDs - Replace with your actual ad unit IDs
  // Banner Ads
  static const String androidBannerAdUnitId = 'ca-app-pub-7111629496407310/5401361879'; // Production ID
  static const String iosBannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716'; // Test ID

  // Interstitial Ads
  static const String androidInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712'; // Test ID
  static const String iosInterstitialAdUnitId = 'ca-app-pub-3940256099942544/4411468910'; // Test ID

  // Rewarded Ads
  static const String androidRewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917'; // Test ID
  static const String iosRewardedAdUnitId = 'ca-app-pub-3940256099942544/1712485313'; // Test ID

  // App Open Ads
  static const String androidAppOpenAdUnitId = 'ca-app-pub-3940256099942544/3419835294'; // Test ID
  static const String iosAppOpenAdUnitId = 'ca-app-pub-3940256099942544/5662855259'; // Test ID

  /// Get AdMob App ID based on platform
  static String getAdMobAppId({required bool isAndroid}) {
    return isAndroid ? androidAdMobAppId : iosAdMobAppId;
  }

  /// Get Banner Ad Unit ID based on platform
  static String getBannerAdUnitId({required bool isAndroid}) {
    return isAndroid ? androidBannerAdUnitId : iosBannerAdUnitId;
  }

  /// Get Interstitial Ad Unit ID based on platform
  static String getInterstitialAdUnitId({required bool isAndroid}) {
    return isAndroid ? androidInterstitialAdUnitId : iosInterstitialAdUnitId;
  }

  /// Get Rewarded Ad Unit ID based on platform
  static String getRewardedAdUnitId({required bool isAndroid}) {
    return isAndroid ? androidRewardedAdUnitId : iosRewardedAdUnitId;
  }

  /// Get App Open Ad Unit ID based on platform
  static String getAppOpenAdUnitId({required bool isAndroid}) {
    return isAndroid ? androidAppOpenAdUnitId : iosAppOpenAdUnitId;
  }
}

