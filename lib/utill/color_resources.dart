import 'package:flutter/material.dart';

class ColorResources {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF3B82F6),
    scaffoldBackgroundColor: const Color(0xFFF9FAFB),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3B82F6),
      secondary: Color(0xFF10B981),
      error: Color(0xFFEF4444),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF10B981),
    scaffoldBackgroundColor: const Color(0xFF111827),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF10B981),
      secondary: Color(0xFF3B82F6),
      error: Color(0xFFEF4444),
    ),
  );

  static Color whiteColor = Colors.white;
  static Color blackColor = Colors.black;
  static Color buttonColor = const Color(0xFF3B82F6);
  static Color blackBackroundColor = const Color.fromARGB(255, 24, 32, 51);
  static Color whiteBackroundColor = const Color(0xFFF9FAFB);
  static Color amberColor = Colors.amber;
  static Color amberShades300 = Colors.amber.shade300;

  // list of Colors confitee
  static const List<Color> confitteColors = [
    Colors.green,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.purple,
  ];
}
