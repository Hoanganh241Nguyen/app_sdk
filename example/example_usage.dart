/// Example usage of App SDK
/// 
/// This file demonstrates how to use the App SDK package
/// in your Flutter application

import 'package:adjust_sdk/adjust_config.dart';
import 'package:app_sdk/app_sdk.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize AdMob
  await AdsManager.instance.initialize();
  
  // Initialize Adjust Analytics
  await AnalyticsManager.instance.initialize(
    appToken: 'YOUR_ADJUST_APP_TOKEN',
    environment: AdjustEnvironment.sandbox, // Use production in release
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App SDK Example',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BannerAdManager _bannerManager = BannerAdManager();
  final InterstitialAdManager _interstitialManager = InterstitialAdManager();
  final RewardedAdManager _rewardedManager = RewardedAdManager();

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  void _loadAds() {
    // Load banner ad
    _bannerManager.loadAd(
      onAdLoaded: () {
        setState(() {});
      },
    );

    // Load interstitial ad
    _interstitialManager.loadAd(
      onAdLoaded: () {
        print('Interstitial ad loaded');
      },
      onAdDismissed: () {
        // Preload next ad
        _interstitialManager.preload();
      },
    );

    // Load rewarded ad
    _rewardedManager.loadAd(
      onAdLoaded: () {
        print('Rewarded ad loaded');
      },
      onRewarded: (reward) {
        print('User earned: ${reward.amount} ${reward.type}');
        // Give reward to user
      },
    );
  }

  @override
  void dispose() {
    _bannerManager.dispose();
    _interstitialManager.dispose();
    _rewardedManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App SDK Example')),
      body: Column(
        children: [
          // Banner Ad
          if (_bannerManager.isLoaded)
            SizedBox(
              height: 50,
              child: _bannerManager.getAdWidget(),
            ),
          
          const Spacer(),
          
          // Buttons
          ElevatedButton(
            onPressed: () {
              if (_interstitialManager.isLoaded) {
                _interstitialManager.showAd();
              }
            },
            child: const Text('Show Interstitial Ad'),
          ),
          
          ElevatedButton(
            onPressed: () {
              if (_rewardedManager.isLoaded) {
                _rewardedManager.showAd(
                  onRewarded: (reward) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reward: ${reward.amount} ${reward.type}'),
                      ),
                    );
                  },
                );
              }
            },
            child: const Text('Show Rewarded Ad'),
          ),
          
          // Track Analytics Event
          ElevatedButton(
            onPressed: () {
              AnalyticsManager.instance.trackEvent(
                'button_clicked',
                callbackParameters: {'button_name': 'example_button'},
              );
            },
            child: const Text('Track Event'),
          ),
          
          const Spacer(),
        ],
      ),
    );
  }
}

