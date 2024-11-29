import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class Palette {
  // Colors
  static const Color blackColor = Color.fromRGBO(1, 1, 1, 1); // Primary color
  static Color greyColor = Colors.grey.shade100; // Secondary color
  static const Color drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const Color whiteColor = Colors.white;
  static final Color redColor = Colors.red.shade500;
  static final Color blueColor = Colors.blue.shade300;

  // Dark mode theme
  static final ThemeData darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: blackColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(color: whiteColor),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: drawerColor,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: blackColor,
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(redColor),
      errorBorder: _border(redColor),
    ),
    primaryColor: redColor,
    indicatorColor: blackColor,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          color: whiteColor, fontSize: 32, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
          color: whiteColor, fontSize: 20, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: whiteColor, fontSize: 16, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: whiteColor, fontSize: 14),
      bodyMedium: TextStyle(color: whiteColor, fontSize: 12),
    ),
  );

  // Light mode theme
  static final ThemeData lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: greyColor,
    cardColor: whiteColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(color: blackColor),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: whiteColor,
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(blueColor),
      errorBorder: _border(redColor),
    ),
    primaryColor: redColor,
    indicatorColor: whiteColor,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          color: blackColor, fontSize: 32, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(
          color: blackColor, fontSize: 20, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(
          color: blackColor, fontSize: 16, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: blackColor, fontSize: 14),
      bodyMedium: TextStyle(color: blackColor, fontSize: 12),
    ),
  );

  static OutlineInputBorder _border([Color color = Colors.grey]) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(10),
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;
  ThemeNotifier({ThemeMode mode = ThemeMode.light})
      : _mode = mode,
        super(
          Palette.darkModeAppTheme,
        ) {
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
