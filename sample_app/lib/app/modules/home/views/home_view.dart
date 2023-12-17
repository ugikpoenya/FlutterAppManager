import 'package:app_manager/app_manager.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sample_app/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AdsManager adsManager = Get.find();
    // ServerManager serverManager = Get.find();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'HomeView',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(future: Future.sync(() {
        adsManager.initAds(controller.isSubscription.value);
        // serverManager.getPosts((response) {
        //   response?.forEach((element) {
        //     print(element.post_title);
        //   });
        // });

        // serverManager.getAssets((response) {
        //   response?.files.forEach((element) {
        //     print("File $element");
        //   });

        //   response?.folders.forEach((key, value) {
        //     print("Folder $key : ${value.length}");
        //     for (var element in value) {
        //       print("File $element");
        //     }
        //   });
        // });
      }), builder: (context, snapshot) {
        return Obx(() => SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => controller.isSubscription.value = !controller.isSubscription.value,
                          style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white), backgroundColor: (controller.isSubscription.value) ? Colors.green : Colors.orange),
                          child: (controller.isSubscription.value) ? const Text('Subscription', style: TextStyle(color: Colors.white)) : const Text('Not Subscription', style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton(
                          onPressed: () => showConfig(context, controller.isSubscription.value, () {
                            Get.offAllNamed(Routes.SPLASHSCREEN);
                          }),
                          style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white)),
                          child: const Text('Setting'),
                        ),
                      ],
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
                    ElevatedButton(
                      onPressed: () {
                        if (controller.isSubscription.value) {
                          showAllert(context, "Gnerate OK");
                        } else {
                          adsManager.confirmAdsAction(context, "Generate App", "Generateing", () => showAllert(context, "Gnerate OK"));
                        }
                      },
                      style: ElevatedButton.styleFrom(elevation: 12.0, textStyle: const TextStyle(color: Colors.white)),
                      child: const Text('Generate'),
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
                    (controller.isSubscription.value) ? SizedBox.shrink() : adsManager.initBanner(context, AdsType.ADMOB),
                    (controller.isSubscription.value) ? SizedBox.shrink() : adsManager.initNative(context, NativeType.SMALL, AdsType.ADMOB),
                    (controller.isSubscription.value) ? SizedBox.shrink() : adsManager.initNative(context, NativeType.MEDIUM, AdsType.ADMOB),
                    const SizedBox(height: 30),
                    const Text("Facebook"),
                    (controller.isSubscription.value) ? SizedBox.shrink() : adsManager.initBanner(context, AdsType.FACEBOOK),
                    (controller.isSubscription.value) ? SizedBox.shrink() : adsManager.initNative(context, NativeType.SMALL, AdsType.FACEBOOK),
                    (controller.isSubscription.value) ? SizedBox.shrink() : adsManager.initNative(context, NativeType.MEDIUM, AdsType.FACEBOOK),
                    const SizedBox(height: 30),
                    const Text("Unity"),
                    (controller.isSubscription.value) ? SizedBox.shrink() : adsManager.initBanner(context, AdsType.UNITY),
                  ],
                ),
              ),
            ));
      }),
    );
  }
}
