// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:io';

import 'package:app_manager/app_manager.dart';
import 'package:app_manager/src/ads/admob_manager.dart';
import 'package:app_manager/src/ads/facebook_manager.dart';
import 'package:app_manager/src/ads/unity_manager.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get_storage/get_storage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum AdsType { ADMOB, FACEBOOK, UNITY }

enum NativeType { SMALL, MEDIUM }

enum LoadingProgress { LOADING, SUCCESS, ERROR }

class AdsManager extends GetxController {
  GetStorage box = GetStorage();
  final admobManager = Get.put(AdmobManager());
  final facebookManager = Get.put(FacebookManager());
  final unityManager = Get.put(UnityManager());

  RxBool isSubscription = false.obs;
  String admobTestIdentifiers = "";

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

  void initAds() {
    if (!isSubscription.value && (Platform.isIOS || Platform.isAndroid)) {
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

  void initGDPR(Function function) {
    if (!isSubscription.value && (Platform.isIOS || Platform.isAndroid)) {
      ItemModel itemModel = ItemModel.fromBoxStorage();
      print("Init Ads Admob DGPR ${itemModel.admob_gdpr}");
      if (itemModel.admob_gdpr) {
        if (admobTestIdentifiers.isEmpty) {
          admobManager.initGdpr(function);
        } else {
          admobManager.initGdprTest(function, admobTestIdentifiers);
        }
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

  Widget initBanner(BuildContext context, AdsType adsType) {
    if (!isSubscription.value && (Platform.isIOS || Platform.isAndroid)) {
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

  Widget initNative(BuildContext context, NativeType type, AdsType adsType) {
    if (!isSubscription.value && (Platform.isIOS || Platform.isAndroid)) {
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

  void confirmAdsAction(
    BuildContext context,
    String title,
    String button,
    Function function,
  ) {
    if (isSubscription.value) {
      function();
    } else {
      AdsManager adsManager = Get.put(AdsManager());
      AdmobManager admobManager = Get.put(AdmobManager());
      FacebookManager facebookManager = Get.put(FacebookManager());
      UnityManager unityManager = Get.put(UnityManager());

      if (admobManager.isRewardedAdLoaded.value || admobManager.isInterstitialAdLoaded.value || facebookManager.isRewardedAdLoaded.value || facebookManager.isInterstitialAdLoaded.value || unityManager.isRewardedAdLoaded.value || unityManager.isInterstitialAdLoaded.value) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.grey.shade200,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (title.isEmpty)
                    ? const SizedBox.shrink()
                    : Text(
                        title,
                        style: const TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    adsManager.showRewardedAd(AdsType.ADMOB);
                    Navigator.pop(context);
                    function();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(MdiIcons.playBoxLock, size: 45.0, color: Colors.black),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(button, style: const TextStyle(fontSize: 20, color: Colors.black)),
                            const Text("Show Ads", style: TextStyle(fontSize: 15, color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    }
  }
}
