# Hướng dẫn Push Package lên GitHub

## Bước 1: Tạo Repository trên GitHub

1. Đăng nhập GitHub
2. Click "New repository"
3. Đặt tên: `app_sdk` (hoặc tên bạn muốn)
4. Chọn Public hoặc Private
5. **KHÔNG** tích "Initialize with README" (vì đã có code local)
6. Click "Create repository"

## Bước 2: Push Code lên GitHub

Chạy các lệnh sau trong thư mục `packages/app_sdk`:

```bash
# Thêm remote repository (thay YOUR_USERNAME bằng username GitHub của bạn)
git remote add origin https://github.com/YOUR_USERNAME/app_sdk.git

# Đổi branch sang main (nếu cần)
git branch -M main

# Push code lên GitHub
git push -u origin main
```

## Bước 3: Sử dụng Package từ GitHub

Sau khi push lên GitHub, thêm vào `pubspec.yaml` của project khác:

```yaml
dependencies:
  app_sdk:
    git:
      url: https://github.com/YOUR_USERNAME/app_sdk.git
      ref: main  # hoặc tag/commit cụ thể
```

Sau đó chạy:
```bash
flutter pub get
```

## Bước 4: Sử dụng trong Code

```dart
import 'package:app_sdk/app_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo tất cả SDK components
  await AppSdk.initialize();
  
  runApp(const MyApp());
}
```

## Cập nhật Package

Khi có thay đổi, push lên GitHub:

```bash
git add .
git commit -m "Your commit message"
git push origin main
```

## Tạo Tag cho Version

```bash
# Tạo tag
git tag -a v1.0.0 -m "Version 1.0.0"

# Push tag
git push origin v1.0.0
```

Sau đó có thể dùng version cụ thể:
```yaml
dependencies:
  app_sdk:
    git:
      url: https://github.com/YOUR_USERNAME/app_sdk.git
      ref: v1.0.0
```

