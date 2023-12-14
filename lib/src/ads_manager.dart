// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:io';

import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'facebook_manager.dart';
import 'unity_manager.dart';
import 'admob_manager.dart';
import 'item_model.dart';
import 'package:get_storage/get_storage.dart';

enum AdsType { ADMOB, FACEBOOK, UNITY }

enum NativeType { SMALL, MEDIUM }

enum LoadingProgress { LOADING, SUCCESS, ERROR }

class AdsManager extends GetxController {
  GetStorage box = GetStorage();
  final admobManager = Get.put(AdmobManager());
  final facebookManager = Get.put(FacebookManager());
  final unityManager = Get.put(UnityManager());

  Widget isInterstitialAdLoaded(Widget success, Widget error) {
    return Obx(() {
      print("Interstitial : A-${admobManager.isInterstitialAdLoaded.value} | F-${facebookManager.isInterstitialAdLoaded.value} | U-${unityManager.isInterstitialAdLoaded.value}");
      if (admobManager.isInterstitialAdLoaded.value || facebookManager.isInterstitialAdLoaded.value || unityManager.isInterstitialAdLoaded.value) {
        return success;
      } else {
        return error;
      }
    });
  }

  Widget isRewardedAdLoaded(Widget success, Widget error) {
    return Obx(() {
      print("Rewarded : A-${admobManager.isRewardedAdLoaded.value} | F-${facebookManager.isRewardedAdLoaded.value} | U-${unityManager.isRewardedAdLoaded.value}");
      if (admobManager.isRewardedAdLoaded.value || facebookManager.isRewardedAdLoaded.value || unityManager.isRewardedAdLoaded.value) {
        return success;
      } else {
        return error;
      }
    });
  }

  Widget isInterstitialAdLoaded_isRewardedAdLoaded(Widget success, Widget error) {
    return Obx(() {
      print("Gabungan => Interstitial  : A-${admobManager.isInterstitialAdLoaded.value} | F-${facebookManager.isInterstitialAdLoaded.value} | U-${unityManager.isInterstitialAdLoaded.value}, Rewarded : A-${admobManager.isRewardedAdLoaded.value} | F-${facebookManager.isRewardedAdLoaded.value} | U-${unityManager.isRewardedAdLoaded.value}");
      if (admobManager.isInterstitialAdLoaded.value || facebookManager.isInterstitialAdLoaded.value || unityManager.isInterstitialAdLoaded.value || admobManager.isRewardedAdLoaded.value || facebookManager.isRewardedAdLoaded.value || unityManager.isRewardedAdLoaded.value) {
        return success;
      } else {
        return error;
      }
    });
  }

  void loadAppOpenAd() {
    admobManager.loadAppOpenAd();
  }

  void initAds(bool isSubscription) {
    if (!isSubscription && (Platform.isIOS || Platform.isAndroid)) {
      print("Init Ads");
      facebookManager.initAds();
      unityManager.initAds();
      admobManager.initAds();
    } else {
      print("Ads Disable");
    }
  }

  void resetGdpr() {
    ConsentInformation.instance.reset();
  }

  void initGDPRTest(bool isSubscription, Function function, String testIdentifiers) {
    if (!isSubscription && (Platform.isIOS || Platform.isAndroid)) {
      ItemModel itemModel = ItemModel.fromBoxStorage();
      print("Init Ads Admob DGPR Test${itemModel.admob_gdpr}");
      if (itemModel.admob_gdpr) {
        admobManager.initGdprTest(function, testIdentifiers);
      } else {
        function();
      }
    } else {
      print("Ads Disable");
      function();
    }
  }

  void initGDPR(bool isSubscription, Function function) {
    if (!isSubscription && (Platform.isIOS || Platform.isAndroid)) {
      ItemModel itemModel = ItemModel.fromBoxStorage();
      print("Init Ads Admob DGPR ${itemModel.admob_gdpr}");
      if (itemModel.admob_gdpr) {
        admobManager.initGdpr(function);
      } else {
        function();
      }
    } else {
      print("Ads Disable");
      function();
    }
  }

  void showInterstitialAd(AdsType adsType) {
    if (adsType == AdsType.ADMOB) {
      if (admobManager.interstitialAd == null) {
        showInterstitialAd(AdsType.FACEBOOK);
      } else {
        admobManager.interstitialAd?.show();
      }
    } else if (adsType == AdsType.FACEBOOK) {
      if (facebookManager.isInterstitialAdLoaded.value) {
        FacebookInterstitialAd.showInterstitialAd();
      } else {
        showInterstitialAd(AdsType.UNITY);
      }
    } else {
      unityManager.showVideoAds(ItemModel.fromBoxStorage().unity_interstitial);
    }
  }

  void showRewardedAd(AdsType adsType) {
    if (adsType == AdsType.ADMOB) {
      if (admobManager.rewardedAd == null) {
        showRewardedAd(AdsType.FACEBOOK);
      } else {
        admobManager.rewardedAd?.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {});
      }
    } else if (adsType == AdsType.FACEBOOK) {
      if (facebookManager.isRewardedAdLoaded.value) {
        FacebookRewardedVideoAd.showRewardedVideoAd();
      } else {
        showRewardedAd(AdsType.UNITY);
      }
    } else if (unityManager.isRewardedAdLoaded.value) {
      unityManager.showVideoAds(ItemModel.fromBoxStorage().unity_rewarded_ads);
    } else {
      showInterstitialAd(AdsType.ADMOB);
    }
  }

  Widget initBanner(BuildContext context, AdsType adsType, bool isSubscription) {
    if (!isSubscription && (Platform.isIOS || Platform.isAndroid)) {
      print("Init banner");
      if (adsType == AdsType.ADMOB) {
        return admobManager.loadBannerAd(context);
      } else if (adsType == AdsType.FACEBOOK) {
        return facebookManager.loadBannerAd();
      } else if (adsType == AdsType.UNITY) {
        return unityManager.loadBannerAd();
      } else {
        return const SizedBox.shrink();
      }
    } else {
      print("Banner Disable");
      return const SizedBox.shrink();
    }
  }

  Widget initNative(BuildContext context, NativeType type, AdsType adsType, isSubscription) {
    if (!isSubscription && (Platform.isIOS || Platform.isAndroid)) {
      print("Init Native");
      if (adsType == AdsType.ADMOB) {
        return admobManager.loadNativeAd(context, type);
      } else if (adsType == AdsType.FACEBOOK) {
        return facebookManager.loadNativeAd(type);
      } else {
        return const SizedBox.shrink();
      }
    } else {
      print("Native Disable");
      return const SizedBox.shrink();
    }
  }
}