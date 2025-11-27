import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:flutter/services.dart';

/// Adjust Wrapper
/// Workaround for adjust_sdk 5.4.5 where adjust.dart is completely commented out
/// This provides the same functionality as the Adjust class
class AdjustWrapper {
  static const String _sdkPrefix = 'flutter5.4.5';
  static const MethodChannel _channel = MethodChannel('com.adjust.sdk/api');

  /// Initialize Adjust SDK
  static void initSdk(AdjustConfig config) {
    config.sdkPrefix = _sdkPrefix;
    _channel.invokeMethod('initSdk', config.toMap);
  }

  /// Track an event
  static void trackEvent(AdjustEvent event) {
    _channel.invokeMethod('trackEvent', event.toMap);
  }
}

