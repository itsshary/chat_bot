import 'package:chat_bot/utill/color_resources.dart';
import 'package:chat_bot/utill/dimensions.dart';
import 'package:chat_bot/utill/images.dart';
import 'package:chat_bot/view/splash_view/service/splash_service.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SplashServices splashServices = SplashServices();

  @override
  void initState() {
    splashServices.moveNextScreen(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.whiteColor,
      body: Center(
        child: Image.asset(AppImages.logo,
            height: Dimensions.largeImageSizs,
            width: Dimensions.largeImageSizs),
      ),
    );
  }
}
