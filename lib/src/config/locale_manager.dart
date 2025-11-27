import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';

/// Locale Manager
/// Manages app locale/language loading and storage
class LocaleManager {
  static LocaleManager? _instance;
  static LocaleManager get instance => _instance ??= LocaleManager._internal();
  
  LocaleManager._internal();

  static const String _storageKey = 'app_language';
  static const String _defaultLocale = 'en';

  bool _isInitialized = false;
  String? _currentLocale;

  /// Initialize locale manager
  /// Loads saved locale from storage
  /// Should be called early in app initialization
  Future<String> initialize() async {
    if (_isInitialized) {
      debugPrint('✅ LocaleManager already initialized');
      return _currentLocale ?? _defaultLocale;
    }

    try {
      // Ensure GetStorage is initialized
      final isInitialized = await GetStorage.init();
      if (!isInitialized) {
        await GetStorage.init();
      }

      final storage = GetStorage();
      _currentLocale = storage.read<String>(_storageKey) ?? _defaultLocale;
      _isInitialized = true;
      
      debugPrint('✅ LocaleManager initialized with locale: $_currentLocale');
      return _currentLocale!;
    } catch (e) {
      debugPrint('❌ Error initializing LocaleManager: $e');
      _currentLocale = _defaultLocale;
      _isInitialized = true;
      return _defaultLocale;
    }
  }

  /// Get current locale ID
  /// Returns saved locale or default locale
  String getLocaleId() {
    if (!_isInitialized) {
      debugPrint('⚠️ LocaleManager not initialized, using default locale');
      return _defaultLocale;
    }
    return _currentLocale ?? _defaultLocale;
  }

  /// Save locale ID to storage
  /// Updates current locale and persists to storage
  Future<void> saveLocaleId(String localeId) async {
    try {
      final storage = GetStorage();
      await storage.write(_storageKey, localeId);
      _currentLocale = localeId;
      debugPrint('✅ Locale saved: $localeId');
    } catch (e) {
      debugPrint('❌ Error saving locale: $e');
    }
  }

  /// Check if locale manager is initialized
  bool get isInitialized => _isInitialized;

  /// Get default locale
  String get defaultLocale => _defaultLocale;
}

