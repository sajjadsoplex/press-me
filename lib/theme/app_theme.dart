import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF050608),

      colorScheme: const ColorScheme.dark(
        surface: Color(0xFF050608),
        primary: Color(0xFFA8C7FF),
      ),

      fontFamily: 'sans',

      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: Color(0xFFF5F2EA),
        ),
        bodyMedium: TextStyle(
          color: Color(0xFF8D9098),
        ),
      ),

      useMaterial3: true,
    );
  }
}