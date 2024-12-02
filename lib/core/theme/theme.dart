import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class Palette {
  // Colors inspired by the design
  static const Color lightBackground = Color(0xFFF7F7F7);
  static const Color darkBackground = Color(0xFF121212);
  static const Color lightCardColor = Color(0xFFFFFFFF);
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color primaryAccentLight = Color(0xFF3366FF);
  static const Color primaryAccentDark = Color(0xFF4DB6AC);
  static const Color lightText = Color(0xFF333333);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color indicatorColor = Color(0x1C142B);

  // Jakarta font-based TextTheme
  static const String fontFamilyJakarta = 'jakarta';

  static TextTheme jakartaTextTheme = const TextTheme(
    headlineLarge: TextStyle(
        fontFamily: fontFamilyJakarta,
        color: lightText,
        fontSize: 32,
        fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(
        fontFamily: fontFamilyJakarta,
        color: lightText,
        fontSize: 20,
        fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(
        fontFamily: fontFamilyJakarta,
        color: lightText,
        fontSize: 16,
        fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(
        fontFamily: fontFamilyJakarta, color: lightText, fontSize: 14),
    bodyMedium: TextStyle(
        fontFamily: fontFamilyJakarta, color: lightText, fontSize: 12),
  );

  // Light mode theme
  static final ThemeData lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: lightBackground,
    cardColor: lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: lightText),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: lightCardColor,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: lightCardColor,
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(primaryAccentLight),
      errorBorder: _border(Colors.red),
    ),
    primaryColor: primaryAccentLight,
    indicatorColor: indicatorColor,
    textTheme: jakartaTextTheme.copyWith(
      headlineLarge: jakartaTextTheme.headlineLarge?.copyWith(color: lightText),
    ),
  );

  // Dark mode theme
  static final ThemeData darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: darkBackground,
    cardColor: darkCardColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: darkText),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: darkCardColor,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: darkCardColor,
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(primaryAccentDark),
      errorBorder: _border(Colors.red),
    ),
    primaryColor: primaryAccentDark,
    indicatorColor: primaryAccentDark,
    textTheme: jakartaTextTheme.copyWith(
      headlineLarge: jakartaTextTheme.headlineLarge?.copyWith(color: darkText),
    ),
  );

  static OutlineInputBorder _border([Color color = Colors.grey]) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(12),
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;
  ThemeNotifier({ThemeMode mode = ThemeMode.light})
      : _mode = mode,
        super(Palette.lightModeAppTheme) {
    getTheme();
  }

  ThemeMode get mode => _mode;

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');

    if (theme == 'light') {
      _mode = ThemeMode.light;
      state = Palette.lightModeAppTheme;
    } else {
      _mode = ThemeMode.dark;
      state = Palette.darkModeAppTheme;
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
      state = Palette.lightModeAppTheme;
      prefs.setString('theme', 'light');
    } else {
      _mode = ThemeMode.dark;
      state = Palette.darkModeAppTheme;
      prefs.setString('theme', 'dark');
    }
  }
}
