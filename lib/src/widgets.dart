import 'dart:io';

import 'package:app_manager/app_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

void showAllert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(message.toString()),
      contentPadding: EdgeInsets.zero,
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

Widget bottomsheetTitle(BuildContext context, String title) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.cancel,
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    ],
  );
}

void showConfig(
  BuildContext context,
  String email,
  String privacyPolicy,
  String termsOfUse,
  bool isSubscription,
  Function function,
) {
  final adsManager = Get.put(AdsManager());
  ItemModel itemModel = ItemModel.fromBoxStorage();
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: (Platform.isMacOS) ? 1 : 0.9,
          child: Column(
            children: [
              bottomsheetTitle(context, "Settings"),
              ListTile(
                onTap: () {
                  launchUrl(Uri.parse("mailto:${email}"));
                },
                title: const Text("Support"),
              ),
              Divider(
                color: Colors.grey[300],
                height: 0,
                indent: 0,
                thickness: 1,
              ),
              ListTile(
                onTap: () {
                  launchUrl(Uri.parse(privacyPolicy));
                },
                title: const Text("Privacy Policy"),
              ),
              Divider(
                color: Colors.grey[300],
                height: 0,
                indent: 0,
                thickness: 1,
              ),
              ListTile(
                onTap: () {
                  launchUrl(Uri.parse(termsOfUse));
                },
                title: const Text("Terms of Use"),
              ),
              (isSubscription) ? const SizedBox.shrink() : AdsManager().initNative(context, NativeType.SMALL, AdsType.ADMOB),
              ((Platform.isAndroid || Platform.isIOS) && !isSubscription && itemModel.isAdmobAds() && itemModel.admob_gdpr)
                  ? ListTile(
                      onTap: () {
                        adsManager.resetGdpr();
                        Navigator.of(context).pop();
                        function();
                      },
                      title: const Text("Reset General Data Protection Regulation (GDPR) consent"),
                    )
                  : const SizedBox.shrink(),
              Divider(
                color: Colors.grey[300],
                height: 0,
                indent: 0,
                thickness: 1,
              ),
            ],
          ),
        );
      });
}
