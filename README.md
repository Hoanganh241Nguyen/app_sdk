# App SDK Package

Reusable SDK package for ads (AdMob), analytics (Adjust), and other integrations.

## Features

- ✅ **AdMob Integration**
  - Banner Ads
  - Interstitial Ads
  - Rewarded Ads
  - App Open Ads
  
- ✅ **Adjust Analytics Integration**
  - Event tracking
  - Revenue tracking
  - Attribution tracking

- ✅ **Locale Manager**
  - Automatic locale loading on app start
  - Persistent locale storage
  - Easy locale management

- ✅ **Clean Architecture**
  - Modular design
  - Easy to extend
  - Reusable across projects

## Installation

### From GitHub

Add to your `pubspec.yaml`:

```yaml
dependencies:
  app_sdk:
    git:
      url: https://github.com/YOUR_USERNAME/app_sdk.git
      ref: main  # or specific tag/commit
```

### From Local Path

```yaml
dependencies:
  app_sdk:
    path: packages/app_sdk
```

### From pub.dev (if published)

```yaml
dependencies:
  app_sdk: ^1.0.0
```

## Usage

### 1. Initialize SDK (Recommended)

Initialize all SDK components at app startup:

```dart
import 'package:app_sdk/app_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize all SDK components
  await AppSdk.initialize();
  
  runApp(const MyApp());
}
```

### 2. Initialize Individual Components

Or initialize components separately:

```dart
import 'package:app_sdk/app_sdk.dart';

// Initialize Locale Manager (loads saved locale)
await LocaleManager.instance.initialize();

// Initialize AdMob
await AdsManager.instance.initialize();

// Initialize Adjust Analytics
await AnalyticsManager.instance.initialize(
  appToken: 'YOUR_ADJUST_APP_TOKEN',
  environment: AdjustEnvironment.production, // or AdjustEnvironment.sandbox
);
```

### 3. Locale Manager

```dart
// Get current locale ID
final localeId = LocaleManager.instance.getLocaleId(); // Returns 'en', 'vi', etc.

// Save locale ID
await LocaleManager.instance.saveLocaleId('vi');

// Check if initialized
if (LocaleManager.instance.isInitialized) {
  // Locale manager is ready
}
```

### 2. Banner Ads

```dart
final bannerManager = BannerAdManager();

// Load banner ad
await bannerManager.loadAd(
  onAdLoaded: () {
    print('Banner ad loaded');
  },
  onAdFailedToLoad: () {
    print('Banner ad failed to load');
  },
);

// Get ad widget
final adWidget = bannerManager.getAdWidget();
if (adWidget != null) {
  // Use in your UI
  return adWidget;
}

// Dispose when done
bannerManager.dispose();
```

### 3. Interstitial Ads

```dart
final interstitialManager = InterstitialAdManager();

// Load interstitial ad
await interstitialManager.loadAd(
  onAdLoaded: () {
    print('Interstitial ad loaded');
  },
  onAdDismissed: () {
    print('User dismissed ad');
    // Preload next ad
    interstitialManager.preload();
  },
);

// Show ad
if (interstitialManager.isLoaded) {
  interstitialManager.showAd();
}
```

### 4. Rewarded Ads

```dart
final rewardedManager = RewardedAdManager();

// Load rewarded ad
await rewardedManager.loadAd(
  onAdLoaded: () {
    print('Rewarded ad loaded');
  },
  onRewarded: (reward) {
    print('User earned: ${reward.amount} ${reward.type}');
    // Give reward to user
  },
);

// Show ad
if (rewardedManager.isLoaded) {
  rewardedManager.showAd(
    onRewarded: (reward) {
      // Handle reward
    },
  );
}
```

### 5. App Open Ads

```dart
final appOpenManager = AppOpenAdManager();

// Load app open ad
await appOpenManager.loadAd(
  onAdLoaded: () {
    print('App Open ad loaded');
  },
);

// Show ad when app opens
if (appOpenManager.isLoaded) {
  appOpenManager.showAd();
}
```

### 6. Analytics (Adjust)

```dart
// Track event
AnalyticsManager.instance.trackEvent(
  'event_token',
  callbackParameters: {'key': 'value'},
);

// Track revenue
AnalyticsManager.instance.trackRevenue(
  'revenue_token',
  9.99,
  'USD',
);
```

## Configuration

### AdMob App IDs

Update `SdkConfig` in `lib/src/config/sdk_config.dart` with your AdMob App IDs and Ad Unit IDs.

### Adjust App Token

Pass your Adjust app token when initializing `AnalyticsManager`.

## Android Setup

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
    <application>
        <!-- AdMob App ID -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>
    </application>
</manifest>
```

## iOS Setup

Add to `ios/Runner/Info.plist`:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX</string>
```

## License

MIT

