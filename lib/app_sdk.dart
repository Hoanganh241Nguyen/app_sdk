/// App SDK - Reusable package for ads, analytics, and integrations
/// 
/// This package provides:
/// - AdMob integration (Banner, Interstitial, Rewarded, App Open)
/// - Adjust analytics integration
/// - Remote Config integration
/// - Base managers and utilities
library app_sdk;

// Ads
export 'src/ads/ads_manager.dart';
export 'src/ads/ads_service.dart';
export 'src/ads/banner/banner_ad_manager.dart';
export 'src/ads/interstitial/interstitial_ad_manager.dart';
export 'src/ads/rewarded/rewarded_ad_manager.dart';
export 'src/ads/app_open/app_open_ad_manager.dart';

// Analytics
export 'src/analytics/analytics_manager.dart';

// Config
export 'src/config/sdk_config.dart';
export 'src/config/locale_manager.dart';

// SDK Initializer
export 'src/app_sdk_init.dart';

