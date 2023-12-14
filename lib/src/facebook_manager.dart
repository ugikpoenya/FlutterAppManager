// ignore_for_file: unused_local_variable

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ads_manager.dart';
import 'unity_manager.dart';
import 'item_model.dart';

class FacebookManager extends GetxController {
  final unityManager = Get.put(UnityManager());
  RxBool isInterstitialAdLoaded = false.obs;
  RxBool isRewardedAdLoaded = false.obs;

  void initAds() {
    print("initAds FacebookAudienceNetwork");
    FacebookAudienceNetwork.init();
    loadInterstitialAd();
    loadRewardedAd();
  }

  Widget loadBannerAd() {
    String placementId = ItemModel.fromBoxStorage().facebook_banner;
    Rx<LoadingProgress> bannerAdIsLoaded = LoadingProgress.LOADING.obs;

    if (placementId.isEmpty) {
      print("FacebookBannerAd Disable");
      return unityManager.loadBannerAd();
    } else {
      print("FacebookBannerAd Load");
      return Obx(() => (bannerAdIsLoaded.value == LoadingProgress.ERROR)
          ? unityManager.loadBannerAd()
          : Container(
              alignment: const Alignment(0.5, 1),
              child: FacebookBannerAd(
                placementId: placementId,
                bannerSize: BannerSize.STANDARD,
                listener: (result, value) {
                  print("FacebookBannerAd : $result --> $value");
                  if (result == BannerAdResult.ERROR) bannerAdIsLoaded.value = LoadingProgress.ERROR;
                },
              ),
            ));
    }
  }

  Widget loadNativeAd(NativeType type) {
    Rx<LoadingProgress> nativeAdIsLoaded = LoadingProgress.LOADING.obs;
    String placementId = ItemModel.fromBoxStorage().facebook_native;
    if (placementId.isEmpty) {
      print("FacebookNativeAd Disable");
      return const SizedBox.shrink();
    } else {
      print("FacebookNativeAd Load");
      return Obx(() => (nativeAdIsLoaded.value == LoadingProgress.ERROR)
          ? const SizedBox.shrink()
          : (type == NativeType.MEDIUM)
              ? FacebookNativeAd(
                  placementId: placementId,
                  adType: NativeAdType.NATIVE_AD,
                  height: 300,
                  width: double.infinity,
                  backgroundColor: Colors.blue,
                  titleColor: Colors.white,
                  descriptionColor: Colors.white,
                  buttonColor: Colors.deepPurple,
                  buttonTitleColor: Colors.white,
                  buttonBorderColor: Colors.white,
                  listener: (result, value) {
                    print("FacebookNativeAd : $result --> $value");
                    if (result == NativeAdResult.ERROR) nativeAdIsLoaded.value = LoadingProgress.ERROR;
                  },
                )
              : SizedBox(
                  height: 100,
                  child: FacebookNativeAd(
                    placementId: placementId,
                    adType: NativeAdType.NATIVE_BANNER_AD,
                    bannerAdSize: NativeBannerAdSize.HEIGHT_100,
                    width: double.infinity,
                    backgroundColor: Colors.blue,
                    titleColor: Colors.white,
                    descriptionColor: Colors.white,
                    buttonColor: Colors.deepPurple,
                    buttonTitleColor: Colors.white,
                    buttonBorderColor: Colors.white,
                    listener: (result, value) {
                      print("FacebookNativeAd: $result --> $value");
                      if (result == NativeAdResult.ERROR) nativeAdIsLoaded.value = LoadingProgress.ERROR;
                    },
                  ),
                ));
    }
  }

  void loadInterstitialAd() {
    String placementId = ItemModel.fromBoxStorage().facebook_interstitial;
    isInterstitialAdLoaded.value = false;
    if (placementId.isEmpty) {
      print("FacebookInterstitialAd Disable");
    } else {
      print("FacebookInterstitialAd Load");
      FacebookInterstitialAd.loadInterstitialAd(
        placementId: placementId,
        listener: (result, value) {
          print("FacebookInterstitialAd: $result --> $value");
          if (result == InterstitialAdResult.LOADED) isInterstitialAdLoaded.value = true;

          if (result == InterstitialAdResult.DISMISSED && value["invalidated"] == true) {
            isInterstitialAdLoaded.value = false;
            loadInterstitialAd();
          }
        },
      );
    }
  }

  void loadRewardedAd() {
    String placementId = ItemModel.fromBoxStorage().facebook_rewarded_ads;
    isRewardedAdLoaded.value = false;
    if (placementId.isEmpty) {
      print("FacebookRewardedVideoAd Disable");
    } else {
      print("FacebookRewardedVideoAd Load");
      FacebookRewardedVideoAd.loadRewardedVideoAd(
        placementId: placementId,
        listener: (result, value) {
          print("FacebookRewardedVideoAd: $result --> $value");
          if (result == RewardedVideoAdResult.LOADED) isRewardedAdLoaded.value = true;

          if (result == RewardedVideoAdResult.VIDEO_CLOSED) {
            isRewardedAdLoaded.value = false;
            loadRewardedAd();
          }
        },
      );
    }
  }
}
