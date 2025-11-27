import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../config/sdk_config.dart';
import '../ads_manager.dart';

/// Rewarded Ad Manager
/// Manages rewarded ad loading and display
class RewardedAdManager {
  RewardedAd? _rewardedAd;
  bool _isLoading = false;
  bool _isLoaded = false;

  String? _adUnitId;
  AdRequest? _adRequest;

  /// Load rewarded ad
  Future<void> loadAd({
    String? adUnitId,
    AdRequest? adRequest,
    VoidCallback? onAdLoaded,
    VoidCallback? onAdFailedToLoad,
    Function(RewardItem)? onRewarded,
    VoidCallback? onAdDismissed,
  }) async {
    if (_isLoading || _isLoaded) {
      debugPrint('⚠️ Rewarded ad is already loading or loaded');
      return;
    }

    // Ensure AdsManager is initialized
    if (!AdsManager.instance.isInitialized) {
      await AdsManager.instance.initialize();
    }

    _isLoading = true;

    try {
      _adUnitId = adUnitId ?? SdkConfig.getRewardedAdUnitId(
        isAndroid: Platform.isAndroid,
      );
      _adRequest = adRequest ?? const AdRequest();

      await RewardedAd.load(
        adUnitId: _adUnitId!,
        request: _adRequest!,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _rewardedAd = ad;
            _isLoading = false;
            _isLoaded = true;
            debugPrint('✅ Rewarded ad loaded successfully');

            // Set full screen content callbacks
            _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                debugPrint('📱 Rewarded ad dismissed');
                ad.dispose();
                _rewardedAd = null;
                _isLoaded = false;
                onAdDismissed?.call();
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                debugPrint('❌ Rewarded ad failed to show: ${error.message}');
                ad.dispose();
                _rewardedAd = null;
                _isLoaded = false;
              },
              onAdShowedFullScreenContent: (_) {
                debugPrint('📱 Rewarded ad showed');
              },
            );

            onAdLoaded?.call();
          },
          onAdFailedToLoad: (error) {
            _isLoading = false;
            _isLoaded = false;
            debugPrint('❌ Rewarded ad failed to load: ${error.message}');
            onAdFailedToLoad?.call();
          },
        ),
      );
    } catch (e) {
      _isLoading = false;
      _isLoaded = false;
      debugPrint('❌ Error loading rewarded ad: $e');
      onAdFailedToLoad?.call();
    }
  }

  /// Show rewarded ad
  /// Returns true if ad was shown, false if ad is not loaded
  bool showAd({
    Function(RewardItem)? onRewarded,
  }) {
    if (_rewardedAd != null && _isLoaded) {
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          debugPrint('🎁 User earned reward: ${reward.amount} ${reward.type}');
          onRewarded?.call(reward);
        },
      );
      return true;
    }
    debugPrint('⚠️ Rewarded ad is not loaded');
    return false;
  }

  /// Check if ad is loaded
  bool get isLoaded => _isLoaded && _rewardedAd != null;

  /// Check if ad is loading
  bool get isLoading => _isLoading;

  /// Dispose rewarded ad
  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isLoaded = false;
    _isLoading = false;
    debugPrint('🗑️ Rewarded ad disposed');
  }

  /// Preload next rewarded ad
  Future<void> preload({
    VoidCallback? onAdLoaded,
    VoidCallback? onAdFailedToLoad,
    Function(RewardItem)? onRewarded,
    VoidCallback? onAdDismissed,
  }) async {
    dispose();
    await loadAd(
      adUnitId: _adUnitId,
      adRequest: _adRequest,
      onAdLoaded: onAdLoaded,
      onAdFailedToLoad: onAdFailedToLoad,
      onRewarded: onRewarded,
      onAdDismissed: onAdDismissed,
    );
  }
}

