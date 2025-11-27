import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/sdk_config.dart';

/// Base Ads Manager
/// Handles initialization and common ad functionality
class AdsManager {
  static AdsManager? _instance;
  static AdsManager get instance => _instance ??= AdsManager._internal();
  
  AdsManager._internal();

  bool _isInitialized = false;
  bool _isInitializing = false;

  /// Initialize AdMob SDK
  /// Call this once at app startup
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('✅ AdsManager already initialized');
      return;
    }

    if (_isInitializing) {
      debugPrint('⏳ AdsManager initialization in progress...');
      return;
    }

    _isInitializing = true;

    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('✅ AdsManager initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing AdsManager: $e');
      _isInitialized = false;
    } finally {
      _isInitializing = false;
    }
  }

  /// Check if AdsManager is initialized
  bool get isInitialized => _isInitialized;

  /// Request Configuration for AdMob
  /// This can be used to set test device IDs, etc.
  Future<void> updateRequestConfiguration(RequestConfiguration config) async {
    if (!_isInitialized) {
      await initialize();
    }
    await MobileAds.instance.updateRequestConfiguration(config);
  }

  /// Set test device IDs for development
  Future<void> setTestDeviceIds(List<String> testDeviceIds) async {
    if (!_isInitialized) {
      await initialize();
    }
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: testDeviceIds),
    );
  }
}

