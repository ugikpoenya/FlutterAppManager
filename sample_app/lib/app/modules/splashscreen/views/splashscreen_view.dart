import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splashscreen_controller.dart';

class SplashscreenView extends GetView<SplashscreenController> {
  const SplashscreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(future: Future.sync(() {
        controller.initAds();
      }), builder: (context, snapshot) {
        return Center(
            child: Obx(
          () => (controller.isProgress.value)
              ? CircularProgressIndicator()
              : TextButton(
                  onPressed: () => controller.initAds(),
                  child: Text("Try Again"),
                ),
        ));
      }),
    );
  }
}
