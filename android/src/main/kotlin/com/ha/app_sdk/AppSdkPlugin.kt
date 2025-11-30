package com.ha.app_sdk

import android.content.Context
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/// App SDK Plugin for Android
/// Provides native platform functionality
class AppSdkPlugin: FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var context: Context? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "app_sdk/methods")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val ctx = context
        if (ctx == null) {
            result.error("CONTEXT_ERROR", "Context is not available", null)
            return
        }

        when (call.method) {
            "getDeviceId" -> {
                try {
                    val deviceId = Settings.Secure.getString(
                        ctx.contentResolver,
                        Settings.Secure.ANDROID_ID
                    )
                    result.success(deviceId)
                } catch (e: Exception) {
                    result.error("DEVICE_ID_ERROR", "Failed to get device ID: ${e.message}", null)
                }
            }
            "getDeviceModel" -> {
                try {
                    val model = Build.MODEL
                    val manufacturer = Build.MANUFACTURER
                    result.success("$manufacturer $model")
                } catch (e: Exception) {
                    result.error("DEVICE_MODEL_ERROR", "Failed to get device model: ${e.message}", null)
                }
            }
            "getOSVersion" -> {
                try {
                    val version = Build.VERSION.RELEASE
                    val sdkInt = Build.VERSION.SDK_INT
                    result.success("Android $version (SDK $sdkInt)")
                } catch (e: Exception) {
                    result.error("OS_VERSION_ERROR", "Failed to get OS version: ${e.message}", null)
                }
            }
            "getPackageName" -> {
                try {
                    val packageName = ctx.packageName
                    result.success(packageName)
                } catch (e: Exception) {
                    result.error("PACKAGE_NAME_ERROR", "Failed to get package name: ${e.message}", null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

