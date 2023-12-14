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
        controller.initAds();
      }), builder: (context, snapshot) {
        return Obx(() => (controller.isLoading.value)
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => controller.isSubscription.value = !controller.isSubscription.value,
                        style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white)),
                        child: (controller.isSubscription.value) ? const Text('Is Subscription') : const Text('Is Not Subscription'),
                      ),
                      ElevatedButton(
                        onPressed: () => adsManager.loadAppOpenAd(),
                        style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white)),
                        child: const Text('Open Ads'),
                      ),
                      ElevatedButton(
                        onPressed: () => adsManager.resetGdpr(),
                        style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white)),
                        child: const Text('Reset GDPR Admib'),
                      ),
                      ElevatedButton(
                        onPressed: () => adsManager.showInterstitialAd(AdsType.ADMOB),
                        style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white)),
                        child: const Text('Show Interstitial'),
                      ),
                      ElevatedButton(
                        onPressed: () => adsManager.showRewardedAd(AdsType.ADMOB),
                        style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white)),
                        child: const Text('Show Rewarded'),
                      ),
                      adsManager.isInterstitialAdLoaded(const Text("Success"), const Text("Error")),
                      adsManager.isRewardedAdLoaded(const Text("Success"), const Text("Error")),
                      adsManager.isInterstitialAdLoaded_isRewardedAdLoaded(const Text("Success"), const Text("Error")),
                      adsManager.initBanner(context, AdsType.ADMOB, controller.isSubscription.value),
                      adsManager.initBanner(context, AdsType.FACEBOOK, controller.isSubscription.value),
                      adsManager.initBanner(context, AdsType.UNITY, controller.isSubscription.value),
                      adsManager.initNative(context, NativeType.SMALL, AdsType.ADMOB, controller.isSubscription.value),
                      adsManager.initNative(context, NativeType.SMALL, AdsType.FACEBOOK, controller.isSubscription.value),
                      adsManager.initNative(context, NativeType.MEDIUM, AdsType.ADMOB, controller.isSubscription.value),
                      adsManager.initNative(context, NativeType.MEDIUM, AdsType.FACEBOOK, controller.isSubscription.value),
                    ],
                  ),
                ),
              ));
      }),
    );
  }
}
