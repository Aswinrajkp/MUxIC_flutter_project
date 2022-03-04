import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_project/Controller/Splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SplashController controller = Get.put(SplashController());
    return GetBuilder<SplashController>(initState: (state) {
      Timer(const Duration(seconds: 2), () {
        Get.offNamed("/Home");
      });
    }, builder: (controller) {
      return Center(
        child: Container(
            color: Colors.black,
            width: 150,
            height: 150,
            child: Image.asset('assets/image/MusicLogoSplash.png')),
      );
    });
  }
}
