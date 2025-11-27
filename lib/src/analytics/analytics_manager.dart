import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:adjust_sdk/adjust_event_success.dart';
import 'package:adjust_sdk/adjust_event_failure.dart';
import 'package:adjust_sdk/adjust_session_success.dart';
import 'package:adjust_sdk/adjust_session_failure.dart';
import 'package:flutter/foundation.dart';
import 'adjust_wrapper.dart';

/// Analytics Manager
/// Handles Adjust SDK initialization and event tracking
class AnalyticsManager {
  static AnalyticsManager? _instance;
  static AnalyticsManager get instance => _instance ??= AnalyticsManager._internal();
  
  AnalyticsManager._internal();

  bool _isInitialized = false;
  AdjustEnvironment _environment = AdjustEnvironment.sandbox;

  Future<void> initialize({
    required String appToken,
    AdjustEnvironment environment = AdjustEnvironment.sandbox,
    bool? isProduction,
  }) async {
    if (_isInitialized) {
      debugPrint('✅ AnalyticsManager already initialized');
      return;
    }

    try {
      _environment = environment;

      if (isProduction != null) {
        _environment = isProduction 
            ? AdjustEnvironment.production 
            : AdjustEnvironment.sandbox;
      }

      final config = AdjustConfig(
        appToken,
        _environment,
      );
      
      if (kDebugMode) {
      }

      config.attributionCallback = (AdjustAttribution attribution) {
        debugPrint('📊 Adjust Attribution: ${attribution.toString()}');
      };

      config.eventSuccessCallback = (AdjustEventSuccess eventSuccess) {
        debugPrint('✅ Adjust Event Success: ${eventSuccess.toString()}');
      };

      config.eventFailureCallback = (AdjustEventFailure eventFailure) {
        debugPrint('❌ Adjust Event Failure: ${eventFailure.toString()}');
      };

      config.sessionSuccessCallback = (AdjustSessionSuccess sessionSuccess) {
        debugPrint('✅ Adjust Session Success: ${sessionSuccess.toString()}');
      };

      config.sessionFailureCallback = (AdjustSessionFailure sessionFailure) {
        debugPrint('❌ Adjust Session Failure: ${sessionFailure.toString()}');
      };

      AdjustWrapper.initSdk(config);
      _isInitialized = true;
      debugPrint('✅ AnalyticsManager initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing AnalyticsManager: $e');
      _isInitialized = false;
    }
  }

  void trackEvent(String eventToken, {Map<String, String>? callbackParameters, Map<String, String>? partnerParameters}) {
    if (!_isInitialized) {
      debugPrint('⚠️ AnalyticsManager not initialized');
      return;
    }

    try {
      final adjustEvent = AdjustEvent(eventToken);
      
      if (callbackParameters != null) {
        callbackParameters.forEach((key, value) {
          adjustEvent.addCallbackParameter(key, value);
        });
      }

      if (partnerParameters != null) {
        partnerParameters.forEach((key, value) {
          adjustEvent.addPartnerParameter(key, value);
        });
      }

      AdjustWrapper.trackEvent(adjustEvent);
      debugPrint('📊 Tracked event: $eventToken');
    } catch (e) {
      debugPrint('❌ Error tracking event: $e');
    }
  }

  void trackRevenue(String eventToken, double revenue, String currency, {Map<String, String>? callbackParameters}) {
    if (!_isInitialized) {
      debugPrint('⚠️ AnalyticsManager not initialized');
      return;
    }

    try {
      final adjustEvent = AdjustEvent(eventToken);
      adjustEvent.setRevenue(revenue, currency);
      
      if (callbackParameters != null) {
        callbackParameters.forEach((key, value) {
          adjustEvent.addCallbackParameter(key, value);
        });
      }

      AdjustWrapper.trackEvent(adjustEvent);
      debugPrint('💰 Tracked revenue: $revenue $currency');
    } catch (e) {
      debugPrint('❌ Error tracking revenue: $e');
    }
  }

  bool get isInitialized => _isInitialized;
}

