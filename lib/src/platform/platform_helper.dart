import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Platform Helper
/// Provides access to native platform functionality
class PlatformHelper {
  static const MethodChannel _channel = MethodChannel('app_sdk/methods');

  /// Get Android Device ID (Android ID)
  /// Returns a unique identifier for the device
  /// 
  /// Note: This ID may change if the device is factory reset
  static Future<String?> getDeviceId() async {
    try {
      final String? deviceId = await _channel.invokeMethod('getDeviceId');
      return deviceId;
    } on PlatformException catch (e) {
      debugPrint('❌ Error getting device ID: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('❌ Unexpected error getting device ID: $e');
      return null;
    }
  }

  /// Get device model name
  /// Returns manufacturer and model (e.g., "Samsung Galaxy S21")
  static Future<String?> getDeviceModel() async {
    try {
      final String? model = await _channel.invokeMethod('getDeviceModel');
      return model;
    } on PlatformException catch (e) {
      debugPrint('❌ Error getting device model: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('❌ Unexpected error getting device model: $e');
      return null;
    }
  }

  /// Get OS version
  /// Returns OS version string (e.g., "Android 13 (SDK 33)")
  static Future<String?> getOSVersion() async {
    try {
      final String? version = await _channel.invokeMethod('getOSVersion');
      return version;
    } on PlatformException catch (e) {
      debugPrint('❌ Error getting OS version: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('❌ Unexpected error getting OS version: $e');
      return null;
    }
  }

  /// Get app package name
  /// Returns the package name of the app (e.g., "com.ha.translator")
  static Future<String?> getPackageName() async {
    try {
      final String? packageName = await _channel.invokeMethod('getPackageName');
      return packageName;
    } on PlatformException catch (e) {
      debugPrint('❌ Error getting package name: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('❌ Unexpected error getting package name: $e');
      return null;
    }
  }

  /// Get all device information
  /// Returns a map with all device information
  static Future<Map<String, String?>> getDeviceInfo() async {
    return {
      'deviceId': await getDeviceId(),
      'deviceModel': await getDeviceModel(),
      'osVersion': await getOSVersion(),
      'packageName': await getPackageName(),
    };
  }
}

