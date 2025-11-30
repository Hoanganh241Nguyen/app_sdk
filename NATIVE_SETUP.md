# Native Code Setup Guide

## Vấn đề

Khi sử dụng package từ GitHub, native code (Kotlin/Java) không tự động được compile vào app project. Cần setup thủ công.

## Giải pháp

### Cách 1: Copy Native Code vào App Project (Khuyến nghị)

1. Copy file `AppSdkPlugin.kt` vào app project:
   ```bash
   # Từ package
   packages/app_sdk/android/src/main/kotlin/com/ha/app_sdk/AppSdkPlugin.kt
   
   # Đến app project
   android/app/src/main/kotlin/com/ha/app_sdk/AppSdkPlugin.kt
   ```

2. Register plugin trong `MainActivity.kt`:
   ```kotlin
   package com.ha.translator
   
   import io.flutter.embedding.android.FlutterActivity
   import io.flutter.embedding.engine.FlutterEngine
   import com.ha.app_sdk.AppSdkPlugin
   
   class MainActivity: FlutterActivity() {
       override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
           super.configureFlutterEngine(flutterEngine)
           flutterEngine.plugins.add(AppSdkPlugin())
       }
   }
   ```

### Cách 2: Sử dụng Package từ Local Path

Thay vì dùng từ GitHub, dùng local path:

```yaml
dependencies:
  app_sdk:
    path: packages/app_sdk
```

Sau đó Flutter sẽ tự động compile native code.

### Cách 3: Publish lên pub.dev

Publish package lên pub.dev để Flutter tự động handle native code registration.

## Lưu ý

- Native code chỉ hoạt động trên Android
- iOS cần implement riêng nếu cần
- PlatformHelper sẽ trả về `null` nếu plugin chưa được register

