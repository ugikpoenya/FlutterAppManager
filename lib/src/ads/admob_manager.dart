// ignore_for_file: unused_local_variable

import 'package:app_manager/app_manager.dart';
import 'package:app_manager/src/ads/facebook_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobManager extends GetxController {
  final facebookManager = Get.put(FacebookManager());
  RxBool isInterstitialAdLoaded = false.obs;
  RxBool isRewardedAdLoaded = false.obs;

  InterstitialAd? interstitialAd;
  RewardedAd? rewardedAd;

  void initAds(ItemModel itemModel) {
    if (itemModel.isAdmobAds()) {
      print("Init Admob");
      MobileAds.instance.initialize();
    } else {
      print("Init Admob Empty");
    }
  }

  void loadAds(ItemModel itemModel) {
    if (itemModel.isAdmobAds()) {
      print("Load Admob");
      loadInterstitialAd();
      loadRewardedAd();
    } else {
      print("Init Admob Empty");
    }
  }

  void initGdprTest(Function(ItemModel?) function, ItemModel itemModel, String testIdentifiers) {
    print("Init Admob GDPR Test");
    ConsentDebugSettings debugSettings = ConsentDebugSettings(
      debugGeography: DebugGeography.debugGeographyEea,
      testIdentifiers: [testIdentifiers],
    );

    ConsentInformation.instance.requestConsentInfoUpdate(ConsentRequestParameters(consentDebugSettings: debugSettings), () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        print("Init Admob GDPR isConsentFormAvailable");
        loadForm(function, itemModel);
      } else {
        function(itemModel);
      }
    }, (FormError error) {
      print(error);
      function(itemModel);
    });
  }

  void initGdpr(Function(ItemModel?) function, ItemModel itemModel) {
    print("Init Admob GDPR");
    ConsentInformation.instance.requestConsentInfoUpdate(ConsentRequestParameters(), () async {
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        print("Init Admob GDPR isConsentFormAvailable");
        loadForm(function, itemModel);
      } else {
        function(itemModel);
      }
    }, (FormError error) {
      print(error);
      function(itemModel);
    });
  }

  void loadForm(Function(ItemModel?) function, ItemModel itemModel) {
    print("Admob GDPR Load Form");
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        var status = await ConsentInformation.instance.getConsentStatus();
        print("Admob GDPR $status");
        if (status == ConsentStatus.obtained) {
          function(itemModel);
        }
        if (status == ConsentStatus.required) {
          consentForm.show(
            (formError) {
              loadForm(function, itemModel);
            },
          );
        }
      },
      (formError) {
        print(formError);
        function(itemModel);
      },
    );
  }

  void loadAppOpenAd(Function() function) {
    String adUnitId = ItemModel.fromBoxStorage().admob_open_ads;
    if (adUnitId.isEmpty) {
      print("Admob AppOpenAd isEmpty");
      function();
    } else {
      print("Admob AppOpenAd Load");
      AppOpenAd.load(
        adUnitId: adUnitId,
        orientation: AppOpenAd.orientationPortrait,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            print('Admob $ad loaded');
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                print('Admob $ad onAdShowedFullScreenContent');
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                print('Admob $ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
                function();
              },
              onAdDismissedFullScreenContent: (ad) {
                print('Admob $ad onAdDismissedFullScreenContent');
                ad.dispose();
                function();
              },
            );
            ad.show();
          },
          onAdFailedToLoad: (error) {
            print('Admob AppOpenAd failed to load: $error');
            function();
          },
        ),
      );
    }
  }

  Widget loadBannerAd(BuildContext context) {
    String adUnitId = ItemModel.fromBoxStorage().admob_banner;
    Widget? widgetBannerAd;
    Rx<LoadingProgress> bannerAdIsLoaded = LoadingProgress.LOADING.obs;

    if (adUnitId.isEmpty) {
      print("Admob BannerAd isEmpty");
      return facebookManager.loadBannerAd();
    } else {
      return FutureBuilder(future: Future.sync(() async {
        final AnchoredAdaptiveBannerAdSize? bannerAdSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(MediaQuery.of(context).size.width.truncate());
        if (bannerAdSize == null) {
          print('Unable to get height of anchored banner.');
        } else {
          print("Admob BannerAd Load");
          await BannerAd(
            adUnitId: adUnitId,
            request: const AdRequest(),
            size: bannerAdSize,
            listener: BannerAdListener(
              onAdLoaded: (ad) {
                var bannerAd = ad as BannerAd;
                widgetBannerAd = SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: bannerAd),
                  ),
                );

                bannerAdIsLoaded.value = LoadingProgress.SUCCESS;
                print('$ad loaded.');
              },
              onAdFailedToLoad: (ad, error) {
                ad.dispose();
                print('BannerAd failed to load: $error');
                bannerAdIsLoaded.value = LoadingProgress.ERROR;
              },
              onAdOpened: (Ad ad) {},
              onAdClosed: (Ad ad) {},
              onAdImpression: (Ad ad) {},
            ),
          ).load();
        }
      }), builder: (context, snapshot) {
        return Obx(() => (bannerAdIsLoaded.value == LoadingProgress.SUCCESS)
            ? widgetBannerAd!
            : (bannerAdIsLoaded.value == LoadingProgress.ERROR)
                ? facebookManager.loadBannerAd()
                : const SizedBox.shrink());
      });
    }
  }

  Widget loadNativeAd(BuildContext context, NativeType type) {
    TemplateType nativeTemplate = (type == NativeType.SMALL) ? TemplateType.small : TemplateType.medium;
    Widget? widgetNativeAd;
    Rx<LoadingProgress> nativeAdIsLoaded = LoadingProgress.LOADING.obs;

    String adUnitId = ItemModel.fromBoxStorage().admob_native;
    if (adUnitId.isEmpty) {
      print("Admob NativeAd isEmpty");
      return facebookManager.loadNativeAd(type);
    } else {
      print("Admob NativeAd Load");
      return FutureBuilder(future: Future.sync(() async {
        NativeAd nativeAd = NativeAd(
          adUnitId: adUnitId,
          listener: NativeAdListener(
            onAdLoaded: (ad) {
              var result = ad as NativeAd;
              print('Admob $NativeAd loaded.');
              widgetNativeAd = SizedBox(
                height: MediaQuery.of(context).size.width * (((nativeTemplate == TemplateType.medium) ? 370 : 91) / 355),
                width: MediaQuery.of(context).size.width,
                child: AdWidget(ad: result),
              );
              nativeAdIsLoaded.value = LoadingProgress.SUCCESS;
            },
            onAdFailedToLoad: (ad, error) {
              print('Admob $NativeAd failed to load: $error');
              ad.dispose();
              nativeAdIsLoaded.value = LoadingProgress.ERROR;
            },
          ),
          request: const AdRequest(),
          nativeTemplateStyle: nativeTemplateStyle(nativeTemplate),
        )..load();
      }), builder: (context, snapshot) {
        return Obx(() => (nativeAdIsLoaded.value == LoadingProgress.SUCCESS)
            ? widgetNativeAd!
            : (nativeAdIsLoaded.value == LoadingProgress.ERROR)
                ? facebookManager.loadNativeAd(type)
                : const SizedBox.shrink());
      });
    }
  }

  NativeTemplateStyle nativeTemplateStyle(TemplateType nativeTemplate) {
    return NativeTemplateStyle(
        templateType: nativeTemplate,
        cornerRadius: 5.0,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          style: NativeTemplateFontStyle.monospace,
          size: 16.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          style: NativeTemplateFontStyle.italic,
          size: 16.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black,
          style: NativeTemplateFontStyle.normal,
          size: 16.0,
        ));
  }

  void loadInterstitialAd() {
    String adUnitId = ItemModel.fromBoxStorage().admob_interstitial;
    isInterstitialAdLoaded.value = false;
    if (adUnitId.isEmpty) {
      print("Admob InterstitialAd isEmpty");
    } else {
      print("Admob InterstitialAd Load");
      InterstitialAd.load(
          adUnitId: adUnitId,
          request: const AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              print('Admob $ad loaded.');
              ad.fullScreenContentCallback = FullScreenContentCallback(
                  onAdShowedFullScreenContent: (ad) {},
                  onAdImpression: (ad) {},
                  onAdFailedToShowFullScreenContent: (ad, err) {
                    ad.dispose();
                  },
                  onAdDismissedFullScreenContent: (ad) {
                    loadInterstitialAd();
                    ad.dispose();
                  },
                  onAdClicked: (ad) {});
              interstitialAd = ad;
              isInterstitialAdLoaded.value = true;
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('Admob InterstitialAd failed to load: $error');
              isInterstitialAdLoaded.value = false;
            },
          ));
    }
  }

  void loadRewardedAd() {
    String adUnitId = ItemModel.fromBoxStorage().admob_interstitial;
    isRewardedAdLoaded.value = false;
    if (adUnitId.isEmpty) {
      print("Admob RewardedAd isEmpty");
    } else {
      print("Admob RewardedAd Load");
      RewardedAd.load(
          adUnitId: adUnitId,
          request: const AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) {
              print('Admob $ad loaded.');
              ad.fullScreenContentCallback = FullScreenContentCallback(
                  onAdShowedFullScreenContent: (ad) {},
                  onAdImpression: (ad) {},
                  onAdFailedToShowFullScreenContent: (ad, err) {
                    ad.dispose();
                  },
                  onAdDismissedFullScreenContent: (ad) {
                    loadRewardedAd();
                    ad.dispose();
                  },
                  onAdClicked: (ad) {});

              rewardedAd = ad;
              isRewardedAdLoaded.value = true;
            },
            onAdFailedToLoad: (LoadAdError error) {
              debugPrint('Admob RewardedAd failed to load: $error');
              isRewardedAdLoaded.value = false;
            },
          ));
    }
  }
}
