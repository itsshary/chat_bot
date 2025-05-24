import 'package:chat_bot/routes/routes_name.dart';
import 'package:chat_bot/utill/app_constants.dart';
import 'package:chat_bot/utill/color_resources.dart';
import 'package:chat_bot/utill/dimensions.dart';
import 'package:chat_bot/utill/extension.dart';
import 'package:chat_bot/utill/images.dart';
import 'package:chat_bot/utill/roundbutton.dart';
import 'package:chat_bot/utill/styles.dart';
import 'package:flutter/material.dart';

class StartingView extends StatefulWidget {
  const StartingView({super.key});

  @override
  State<StartingView> createState() => _StartingViewState();
}

class _StartingViewState extends State<StartingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: Dimensions.paddingSizeExtraLarge,
          left: Dimensions.paddingSizeDefault,
          right: Dimensions.paddingSizeDefault,
        ),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppConstants.aiassitent, style: tagLineOne(context)),
              Dimensions.mediumSizedBox.sH,
              const Text(textAlign: TextAlign.center, AppConstants.description),
              Dimensions.largerSizedBox.sH,
              Image.asset(
                AppImages.aiIcon,
                height: Dimensions.extraLargeImageSizs,
                width: Dimensions.extraLargeImageSizs,
              ),
              Dimensions.largerSizedBox.sH,
              MyButton(
                title: 'Continue',
                ontap: () {
                  Navigator.pushReplacementNamed(context, Routesname.homeView);
                },
                bgcolor: ColorResources.blackBackroundColor,
                textColor: ColorResources.whiteColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
