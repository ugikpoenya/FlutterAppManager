import 'package:app_manager/app_manager.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AdsManager adsManager = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: FutureBuilder(future: Future.sync(() {
        adsManager.initAds();
      }), builder: (context, snapshot) {
        return Obx(() => SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => adsManager.isSubscription.value = !adsManager.isSubscription.value,
                      style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white), backgroundColor: (adsManager.isSubscription.value) ? Colors.green : Colors.orange),
                      child: (adsManager.isSubscription.value) ? const Text('Subscription', style: TextStyle(color: Colors.white)) : const Text('Not Subscription', style: TextStyle(color: Colors.white)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => adsManager.loadAppOpenAd(),
                          style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white), backgroundColor: Colors.red),
                          child: const Text('Open Ads', style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          onPressed: () => adsManager.resetGdpr(),
                          style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white), backgroundColor: Colors.red),
                          child: const Text('Reset GDPR', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => adsManager.showInterstitialAd(AdsType.ADMOB),
                          style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white)),
                          child: const Text('ADMOB Interstitial'),
                        ),
                        ElevatedButton(
                          onPressed: () => adsManager.showRewardedAd(AdsType.ADMOB),
                          style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white)),
                          child: const Text('ADMOB Rewarded'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => adsManager.showInterstitialAd(AdsType.FACEBOOK),
                          style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white)),
                          child: const Text('FACEBOOK Interstitial'),
                        ),
                        ElevatedButton(
                          onPressed: () => adsManager.showRewardedAd(AdsType.FACEBOOK),
                          style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white)),
                          child: const Text('FACEBOOK Rewarded'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => adsManager.showInterstitialAd(AdsType.UNITY),
                          style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white)),
                          child: const Text('UNITY Interstitial'),
                        ),
                        ElevatedButton(
                          onPressed: () => adsManager.showRewardedAd(AdsType.UNITY),
                          style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white)),
                          child: const Text('UNITY Rewarded'),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        adsManager.isInterstitialAdLoaded(const Text("Success"), const Text("Error")),
                        adsManager.isRewardedAdLoaded(const Text("Success"), const Text("Error")),
                        adsManager.isInterstitialAdLoaded_isRewardedAdLoaded(const Text("Success"), const Text("Error")),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text("Admob"),
                    adsManager.initBanner(context, AdsType.ADMOB),
                    adsManager.initNative(context, NativeType.SMALL, AdsType.ADMOB),
                    adsManager.initNative(context, NativeType.MEDIUM, AdsType.ADMOB),
                    const SizedBox(height: 30),
                    const Text("Facebook"),
                    adsManager.initBanner(context, AdsType.FACEBOOK),
                    adsManager.initNative(context, NativeType.SMALL, AdsType.FACEBOOK),
                    adsManager.initNative(context, NativeType.MEDIUM, AdsType.FACEBOOK),
                    const SizedBox(height: 30),
                    const Text("Unity"),
                    adsManager.initBanner(context, AdsType.UNITY),
                  ],
                ),
              ),
            ));
      }),
    );
  }
}
