import 'package:chat_bot/firebase_options.dart';
import 'package:chat_bot/view_model/theme_provider.dart';
import 'package:chat_bot/routes/routes.dart';
import 'package:chat_bot/routes/routes_name.dart';
import 'package:chat_bot/utill/color_resources.dart';
import 'package:chat_bot/view/splash_view/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: GeminiChatApp()));
}

class GeminiChatApp extends ConsumerWidget {
  const GeminiChatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    return MaterialApp(
      theme: ColorResources.lightTheme,
      darkTheme: ColorResources.darkTheme,
      themeMode: themeMode,
      title: 'Gemini Chatbot',
      initialRoute: Routesname.splashView,
      onGenerateRoute: Routes.generateRoutes,
      debugShowCheckedModeBanner: false,
      home: const SplashView(),
    );
  }
}
