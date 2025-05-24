import 'package:chat_bot/routes/routes_name.dart';
import 'package:chat_bot/view/home_view/home_view.dart';
import 'package:chat_bot/view/splash_view/splash_view.dart';
import 'package:chat_bot/view/starting_view/starting_view.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routesname.splashView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashView());
      case Routesname.startingView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const StartingView());
      case Routesname.homeView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeView());

      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Scaffold(
                  body: Center(
                    child: Text("No Routes Defines"),
                  ),
                ));
    }
  }
}
