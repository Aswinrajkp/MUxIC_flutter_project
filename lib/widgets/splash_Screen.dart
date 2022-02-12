import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Get.offNamed("/Home");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          color: Colors.black,
          width: 150,
          height: 150,
          child: Image.asset('assets/image/default.png')),
    );
  }
}
