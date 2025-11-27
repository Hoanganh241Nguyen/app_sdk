import 'package:flutter/foundation.dart';
import 'ads/ads_manager.dart';
import 'analytics/analytics_manager.dart';
import 'config/locale_manager.dart';

/// App SDK Initializer
/// Provides a single entry point to initialize all SDK components
class AppSdk {
  AppSdk._();

  static bool _isInitialized = false;

  /// Initialize all SDK components
  /// Call this once at app startup
  /// 
  /// Example:
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await AppSdk.initialize();
  ///   runApp(const MyApp());
  /// }
  /// ```
  static Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('✅ AppSdk already initialized');
      return;
    }

    try {
      // Initialize Locale Manager (loads saved locale)
      final localeId = await LocaleManager.instance.initialize();
      debugPrint('✅ Locale loaded: $localeId');

      // Initialize AdMob SDK
      await AdsManager.instance.initialize();
      debugPrint('✅ AdMob initialized');

      // Note: AnalyticsManager requires appToken, initialize separately if needed
      // await AnalyticsManager.instance.initialize(
      //   appToken: 'YOUR_TOKEN',
      //   environment: AdjustEnvironment.production,
      // );

      _isInitialized = true;
      debugPrint('✅ AppSdk initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing AppSdk: $e');
      rethrow;
    }
  }

  /// Check if AppSdk is initialized
  static bool get isInitialized => _isInitialized;
}

