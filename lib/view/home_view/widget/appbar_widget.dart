import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_bot/utill/app_constants.dart';
import 'package:chat_bot/utill/dimensions.dart';
import 'package:chat_bot/utill/extension.dart';
import 'package:chat_bot/utill/images.dart';
import 'package:chat_bot/utill/styles.dart';
import 'package:chat_bot/view_model/theme_provider.dart';
import 'show_firebase_details.dart';

PreferredSizeWidget buildAppBar(
    WidgetRef ref, ThemeMode themeMode, BuildContext context) {
  return AppBar(
    leading: IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () => showUserDataDialog(context),
    ),
    title: Row(
      children: [
        Image.asset(AppImages.logo,
            height: Dimensions.smallImageSizs,
            width: Dimensions.smallImageSizs),
        Dimensions.mediumSizedBox.sW,
        Text(AppConstants.appName, style: appbarTextStyle),
      ],
    ),
    actions: [
      IconButton(
        icon: Icon(
            themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
        onPressed: () => ref.read(themeNotifierProvider.notifier).toggleTheme(),
      ),
    ],
  );
}
