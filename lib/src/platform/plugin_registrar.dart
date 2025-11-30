import 'package:flutter/services.dart';

/// Plugin Registrar Helper
/// Helps register the native plugin in your app's MainActivity
/// 
/// For Android, add this to your MainActivity.kt:
/// 
/// ```kotlin
/// import com.ha.app_sdk.AppSdkPlugin
/// 
/// class MainActivity: FlutterActivity() {
///     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
///         super.configureFlutterEngine(flutterEngine)
///         AppSdkPlugin().apply {
///             onAttachedToEngine(flutterEngine.plugins)
///         }
///     }
/// }
/// ```
class PluginRegistrar {
  PluginRegistrar._();

  /// Verify that the plugin is registered
  /// Returns true if plugin methods are available
  static Future<bool> verifyPlugin() async {
    try {
      const channel = MethodChannel('app_sdk/methods');
      await channel.invokeMethod('getPackageName');
      return true;
    } catch (e) {
      return false;
    }
  }
}

