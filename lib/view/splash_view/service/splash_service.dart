import 'dart:async';

import 'package:chat_bot/routes/routes_name.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void moveNextScreen(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacementNamed(context, Routesname.startingView),
    );
  }
}
