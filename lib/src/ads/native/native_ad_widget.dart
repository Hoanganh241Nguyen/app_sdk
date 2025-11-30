import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../interstitial/interstitial_ad_manager.dart';

/// Native Ad Widget with Full Screen on Tap
/// Displays native ad and shows full screen interstitial when tapped
class NativeAdWidget extends StatefulWidget {
  final NativeAd ad;
  final double? height;
  final InterstitialAdManager? interstitialManager;
  final VoidCallback? onAdTapped;
  final VoidCallback? onFullScreenShown;
  final VoidCallback? onFullScreenDismissed;

  const NativeAdWidget({
    super.key,
    required this.ad,
    this.height,
    this.interstitialManager,
    this.onAdTapped,
    this.onFullScreenShown,
    this.onFullScreenDismissed,
  });

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  bool _isShowingFullScreen = false;

  Future<void> _handleTap() async {
    widget.onAdTapped?.call();

    // Show full screen interstitial if available
    if (widget.interstitialManager != null && widget.interstitialManager!.isLoaded) {
      setState(() {
        _isShowingFullScreen = true;
      });

      widget.onFullScreenShown?.call();

      // Show interstitial ad (full screen)
      final shown = widget.interstitialManager!.showAd();
      
      if (shown) {
        // Interstitial will handle its own lifecycle
        // We'll reset state when user comes back
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _isShowingFullScreen = false;
            });
            widget.onFullScreenDismissed?.call();
          }
        });
      } else {
        // If failed to show, show dialog instead
        setState(() {
          _isShowingFullScreen = false;
        });
        _showFullScreenDialog();
      }
    } else {
      // If no interstitial, show full screen dialog with ad content
      _showFullScreenDialog();
    }
  }

  void _showFullScreenDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _FullScreenAdDialog(
        ad: widget.ad,
        onDismissed: () {
          widget.onFullScreenDismissed?.call();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        height: widget.height ?? 300,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Stack(
          children: [
            // Native Ad Content
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AdWidget(ad: widget.ad),
            ),
            
            // Tap indicator overlay
            if (!_isShowingFullScreen)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Tap to view full screen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Full Screen Ad Dialog
/// Shows native ad content in full screen
class _FullScreenAdDialog extends StatelessWidget {
  final NativeAd ad;
  final VoidCallback? onDismissed;

  const _FullScreenAdDialog({
    required this.ad,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Stack(
          children: [
            // Full screen ad content
            Center(
              child: AdWidget(ad: ad),
            ),
            
            // Close button
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () {
                  Navigator.of(context).pop();
                  onDismissed?.call();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

