import 'package:flutter/material.dart';

class AppTheme {
  // AÇIK TEMA
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF6DA8FF),

    scaffoldBackgroundColor: Colors.white,

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6DA8FF),
      secondary: Color(0xFF03DAC6),
      surface: Color(0xFFF2F2F2),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6DA8FF),
      elevation: 0,
      foregroundColor: Colors.white,
    ),

    cardColor: Colors.white,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );

  // KOYU TEMA
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    primaryColor: const Color(0xFF6DA8FF),

    colorScheme: const ColorScheme.dark(
      surface: Color(0xFF2A2A2A),
      primary: Color(0xFF6DA8FF),
      secondary: Color(0xFF03DAC6),
    ),

    cardColor: const Color(0xFF2A2A2A),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
      bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
    ),
  );
}
