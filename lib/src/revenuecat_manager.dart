// ignore_for_file: use_build_context_synchronously, avoid_print, non_constant_identifier_names

import 'dart:io';

import 'package:app_manager/app_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RevenuecatManager extends GetxController {
  GetStorage box = GetStorage();
  AdsManager adsManager = AdsManager();
  ServerManager serverManager = ServerManager();
  List<Package> availablePackages = <Package>[].obs;
  RxBool isPurchasingLoading = false.obs;
  late CustomerInfo customerInfo;
  RxString identifierSelected = "".obs;
  Package? packageSelected;

  Widget getSubscriptionIcon(BuildContext context) {
    return Obx(() => IconButton(
          onPressed: () => showSubscriptions(context),
          icon: Icon(
            MdiIcons.crown,
            color: (adsManager.isSubscription.value) ? Colors.green : Colors.yellow,
          ),
        ));
  }

  void initPurchases() async {
    var REVENUECAT_API_KEY = AppConfig.fromBoxStorage().REVENUECAT_API_KEY;
    if (REVENUECAT_API_KEY.isEmpty) {
      print("Revenucat Disable");
    } else {
      print("Revenucat initPurchases");
      PurchasesConfiguration configuration = PurchasesConfiguration(REVENUECAT_API_KEY);
      await Purchases.configure(configuration);
      await Purchases.enableAdServicesAttributionTokenCollection();
      Purchases.addCustomerInfoUpdateListener((info) {
        if (kDebugMode) print("Revenucat Listener");
        cekCustomerInfo(info);
      });
      if (availablePackages.isEmpty) getOfferings();
    }
  }

  void cekCustomerInfo(CustomerInfo info) async {
    customerInfo = info;
    if (kDebugMode) print(info);
    if (customerInfo.entitlements.active.isNotEmpty) {
      adsManager.isSubscription.value = true;
    } else {
      adsManager.isSubscription.value = false;
    }
    print("isSubscription ${adsManager.isSubscription.value}");
  }

  void getOfferings() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        availablePackages = offerings.current!.availablePackages;
      }
      print("getOfferings ${availablePackages.length}");
      availablePackages.forEach((element) {
        print("${element.storeProduct.priceString} => ${element.storeProduct.title}");
      });
    } on PlatformException catch (e) {
      print("getOfferings : " + e.message.toString());
    }
  }

  void showUserSubscriptions(BuildContext context) {
    print(customerInfo);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: (adsManager.isSubscription.value)
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 30),
                  FloatingActionButton.large(
                    onPressed: () {},
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.check),
                  ),
                  const SizedBox(height: 10),
                  const Text("You're subscribed!"),
                  const SizedBox(height: 10),
                  getCustomerInfo(context),
                  const SizedBox(height: 20),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  FloatingActionButton.large(
                    onPressed: () {},
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.close),
                  ),
                  const SizedBox(height: 10),
                  const Text("You haven't subscribed yet!"),
                  const SizedBox(height: 20),
                ],
              ),
      ),
    );
  }

  Widget getCustomerInfo(BuildContext context) {
    var entitlements = customerInfo.entitlements.active;
    List<Widget> entitlementInfo = <Widget>[];
    entitlementInfo.add(const SizedBox(height: 10));
    entitlementInfo.add(const Text(
      "You're subscribed!",
      style: TextStyle(fontSize: 20),
    ));
    entitlementInfo.add(const SizedBox(height: 10));
    entitlements.forEach(
      (key, value) {
        var parse = DateTime.parse(value.expirationDate.toString());
        var expired = parse.toLocal().toString().split(".").first;
        entitlementInfo.add(ListTile(
          tileColor: Colors.green[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(key),
          subtitle: Text("Expired : $expired"),
        ));
        entitlementInfo.add(const SizedBox(height: 10));
      },
    );
    return Column(
      children: List.generate(entitlementInfo.length, (index) {
        return entitlementInfo[index];
      }),
    );
  }

  Widget subscriptionsButton(BuildContext context) {
    return Obx(() => Column(
          children: [
            for (var item in availablePackages)
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: Obx(() {
                  if (identifierSelected.value.isEmpty) identifierSelected.value = item.storeProduct.identifier;
                  packageSelected ??= item;

                  String title = item.storeProduct.title;

                  return ListTile(
                    tileColor: (packageSelected == item) ? Colors.red[100] : Colors.grey[200],
                    onTap: (isPurchasingLoading.value)
                        ? null
                        : () {
                            identifierSelected.value = item.storeProduct.identifier.toString();
                            packageSelected = item;
                            buySubscriptions(context, item);
                            // Navigator.pop(context);
                          },
                    trailing: (packageSelected == item)
                        ? const Icon(
                            Icons.check_circle_outline,
                            color: Colors.red,
                          )
                        : const SizedBox.shrink(),
                    title: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      item.storeProduct.priceString,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }),
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FloatingActionButton.extended(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      onPressed: (isPurchasingLoading.value)
                          ? null
                          : () {
                              buySubscriptions(context, packageSelected!);
                            },
                      label: (isPurchasingLoading.value)
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                          : const Text("Redeem My Offer", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      restoringPurchases(context);
                    },
                    child: const Text("Restore purchase"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          launchUrl(Uri.parse(AppConfig.fromBoxStorage().PRIVACY_POLICY));
                        },
                        child: const Text("Privacy Policy"),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text("&"),
                      ),
                      InkWell(
                        onTap: () {
                          launchUrl(Uri.parse(AppConfig.fromBoxStorage().PRIVACY_POLICY));
                        },
                        child: const Text("Terms of Use"),
                      ),
                    ],
                  ),
                  (kDebugMode)
                      ? InkWell(
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 3000), () {
                              adsManager.isSubscription.value = !adsManager.isSubscription.value;
                            });
                          },
                          child: const Text("Test purchase"),
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ],
        ));
  }

  Widget subscriptionsText(BuildContext context) {
    return Obx(() {
      Icon iconList = Icon(Icons.check_circle_outline_rounded, color: (adsManager.isSubscription.value) ? Colors.green : Colors.red);
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (adsManager.isSubscription.value) ? getCustomerInfo(context) : const SizedBox.shrink(),
                    Row(children: [iconList, const Text("Faster Generation")]),
                    Row(children: [iconList, const Text("Unlimited Art Generation")]),
                    Row(children: [iconList, const Text("No Ads")]),
                    Row(children: [iconList, const Text("Better quality")]),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  void showSubscriptions(BuildContext context) {
    showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: (Platform.isMacOS) ? 1 : 0.9,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel,
                        ),
                      ),
                      const Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Select Subscription",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[300],
                  height: 0,
                  indent: 0,
                  thickness: 2,
                ),
                Expanded(
                  child: OrientationBuilder(
                    builder: (context, orientation) {
                      return (orientation == Orientation.portrait)
                          ? SingleChildScrollView(
                              child: Column(children: [
                                subscriptionsText(context),
                                subscriptionsButton(context),
                              ]),
                            )
                          : SingleChildScrollView(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: subscriptionsText(context)),
                                  Expanded(child: subscriptionsButton(context)),
                                ],
                              ),
                            );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );
        });
  }

  void buySubscriptions(BuildContext context, Package package) async {
    isPurchasingLoading.value = true;
    print("buySubscriptions");
    try {
      CustomerInfo info = await Purchases.purchasePackage(package);
      cekCustomerInfo(info);
      if (adsManager.isSubscription.value) {
        showAllert(context, "Purchases Successfully");
      }
      isPurchasingLoading.value = false;
      Navigator.pop(context);
    } on PlatformException catch (e) {
      print("buy " + e.toString());
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {}
      isPurchasingLoading.value = false;
    }
  }

  void restoringPurchases(BuildContext context) async {
    isPurchasingLoading.value = true;
    print("restoringPurchases");
    try {
      CustomerInfo info = await Purchases.restorePurchases();
      cekCustomerInfo(info);
      if (adsManager.isSubscription.value) {
        showAllert(context, "Restoring Purchases Successfully");
      } else {
        showAllert(context, "Purchases not found");
      }
      isPurchasingLoading.value = false;
    } on PlatformException catch (e) {
      print("buy " + e.toString());
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {}
      isPurchasingLoading.value = false;
    }
  }
}
