# Integration Guide

## Setup với Remote Config

Để tích hợp App SDK với Remote Config để bật/tắt ads:

```dart
import 'package:app_sdk/app_sdk.dart';
import 'package:ha_translator/core/services/remote_config_service.dart';

// Initialize
await AdsManager.instance.initialize();

// Setup Remote Config callbacks
final remoteConfig = RemoteConfigService();
AdsService.instance.setRemoteConfigCallbacks(
  shouldShowBannerHome: () => remoteConfig.bannerHomeEnabled,
  shouldShowBannerSplash: () => remoteConfig.bannerSplashEnabled,
  shouldShowInterSplash: () => remoteConfig.interSplashConfig.enabled,
);

// Load ads với Remote Config check
await AdsService.instance.loadBannerHome();
await AdsService.instance.loadInterSplash(
  onAdDismissed: () {
    // Navigate to home
  },
);
```

## Sử dụng trong App

### 1. Banner Ad trong Home Screen

```dart
final bannerManager = AdsService.instance.bannerManager;

@override
void initState() {
  super.initState();
  AdsService.instance.loadBannerHome();
}

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      // Your content
      if (bannerManager.isLoaded)
        SizedBox(
          height: 50,
          child: bannerManager.getAdWidget(),
        ),
    ],
  );
}
```

### 2. Interstitial Ad trong Splash Screen

```dart
final interstitialManager = AdsService.instance.interstitialManager;

@override
void initState() {
  super.initState();
  AdsService.instance.loadInterSplash(
    onAdDismissed: () {
      // Navigate to home
      Get.offAllNamed(Routes.homePath);
    },
  );
}

// Show ad when ready
void _showInterSplash() {
  if (AdsService.instance.showInterSplash()) {
    // Ad is showing
  } else {
    // Ad not ready, navigate directly
    Get.offAllNamed(Routes.homePath);
  }
}
```

### 3. Rewarded Ad

```dart
final rewardedManager = AdsService.instance.rewardedManager;

void _showRewardedAd() {
  if (rewardedManager.isLoaded) {
    rewardedManager.showAd(
      onRewarded: (reward) {
        // Give reward to user
        _giveReward(reward.amount, reward.type);
      },
    );
  } else {
    // Load ad first
    rewardedManager.loadAd(
      onAdLoaded: () {
        rewardedManager.showAd(
          onRewarded: (reward) {
            _giveReward(reward.amount, reward.type);
          },
        );
      },
    );
  }
}
```

### 4. Analytics Tracking

```dart
// Track event
AnalyticsManager.instance.trackEvent(
  'screen_view',
  callbackParameters: {
    'screen_name': 'home',
  },
);

// Track revenue
AnalyticsManager.instance.trackRevenue(
  'purchase',
  9.99,
  'USD',
  callbackParameters: {
    'product_id': 'premium',
  },
);
```

## Customization

### Custom Ad Unit IDs

```dart
// Override default ad unit IDs
await bannerManager.loadAd(
  adUnitId: 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX',
);
```

### Custom Ad Request

```dart
final adRequest = AdRequest(
  keywords: ['keyword1', 'keyword2'],
  contentUrl: 'https://example.com',
);

await bannerManager.loadAd(
  adRequest: adRequest,
);
```

## Best Practices

1. **Preload Ads**: Load ads before they're needed
2. **Dispose Properly**: Always dispose ad managers when done
3. **Handle Errors**: Implement error callbacks
4. **Use Remote Config**: Control ads via Remote Config
5. **Test with Test IDs**: Use test ad unit IDs during development

