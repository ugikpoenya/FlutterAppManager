import 'dart:io';

import 'package:app_manager/src/app_config.dart';
import 'package:flutter/material.dart';
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

void showConfig(BuildContext context) {
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
                  launchUrl(Uri.parse("mailto:${AppConfig().getEmail()}"));
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
                  launchUrl(Uri.parse(AppConfig().getPrivacyPolicy()));
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
                  launchUrl(Uri.parse(AppConfig().getTermsOfUse()));
                },
                title: const Text("Terms of Use"),
              ),
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
