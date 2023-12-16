// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/item_model.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class UnityManager extends GetxController {
  RxBool isInterstitialAdLoaded = false.obs;
  RxBool isRewardedAdLoaded = false.obs;

  void initAds(ItemModel itemModel) {
    if (itemModel.isUnityAds()) {
      print("Unity Ads init test : ${itemModel.unity_test_mode}");
      UnityAds.init(
        gameId: itemModel.unity_game_id,
        testMode: itemModel.unity_test_mode,
        onComplete: () {
          print('UnityAds Initialization Complete');
        },
        onFailed: (error, message) => print('UnityAds Initialization Failed: $error $message'),
      );

      loadVideoAds(itemModel.unity_interstitial);
      loadVideoAds(itemModel.unity_rewarded_ads);
    } else {
      print("Init Unity isEmpty");
    }
  }

  Widget loadBannerAd() {
    String placementId = ItemModel.fromBoxStorage().unity_banner;
    if (placementId.isEmpty) {
      print("UnityBannerAd isEmpty");
      return const SizedBox.shrink();
    } else {
      print("UnityBannerAd Load");
      return Container(
        width: double.infinity,
        color: Colors.black,
        child: Center(
          child: UnityBannerAd(
            placementId: placementId,
            onLoad: (placementId) => print('Banner loaded: $placementId'),
            onClick: (placementId) => print('Banner clicked: $placementId'),
            onShown: (placementId) => print('Banner shown: $placementId'),
            onFailed: (placementId, error, message) => print('Banner Ad $placementId failed: $error $message'),
          ),
        ),
      );
    }
  }

  void loadVideoAds(String PLACEMENT_ID) {
    ItemModel itemModel = ItemModel.fromBoxStorage();
    if (PLACEMENT_ID == itemModel.unity_interstitial) isInterstitialAdLoaded.value = false;
    if (PLACEMENT_ID == itemModel.unity_rewarded_ads) isRewardedAdLoaded.value = false;
    if (PLACEMENT_ID.isEmpty) {
      print("UnityAds $PLACEMENT_ID isEmpty");
    } else {
      print("UnityAds Load $PLACEMENT_ID");

      UnityAds.load(
        placementId: PLACEMENT_ID,
        onComplete: (placementId) {
          print('UnityAds Load Complete $placementId');

          if (placementId == itemModel.unity_interstitial) isInterstitialAdLoaded.value = true;
          if (placementId == itemModel.unity_rewarded_ads) isRewardedAdLoaded.value = true;
        },
        onFailed: (placementId, error, message) => print('UnityAds Load Failed $placementId: $error $message'),
      );
    }
  }

  void showVideoAds(String PLACEMENT_ID) {
    UnityAds.showVideoAd(
      placementId: PLACEMENT_ID,
      onStart: (placementId) => print('Video Ad $placementId started'),
      onClick: (placementId) => print('Video Ad $placementId click'),
      onSkipped: (placementId) => print('Video Ad $placementId skipped'),
      onComplete: (placementId) {
        print('Video Ad $placementId completed');
        ItemModel itemModel = ItemModel.fromBoxStorage();
        if (placementId == itemModel.unity_interstitial) isInterstitialAdLoaded.value = false;
        if (placementId == itemModel.unity_rewarded_ads) isRewardedAdLoaded.value = false;
        loadVideoAds(PLACEMENT_ID);
      },
      onFailed: (placementId, error, message) => print('Video Ad $placementId failed: $error $message'),
    );
  }
}
