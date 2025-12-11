import 'package:coffee/core/constants/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

abstract class ThemeManager{
  static ThemeData themeData = ThemeData(
    primaryColor: AppColors.gold,
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.white,
      iconTheme: IconThemeData(color: AppColors.gold),
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontFamily: "Inter",
        fontWeight: FontWeight.w700,
        color: AppColors.gold,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.gold,
      selectedItemColor: AppColors.white,
      showSelectedLabels: true,
      selectedLabelStyle: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.w700,
        fontSize: 12,
        fontFamily: "Inter",
      ),
      unselectedItemColor: AppColors.white,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        color: AppColors.white,
        fontWeight: FontWeight.w700,
        fontFamily: "Inter",
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        color: AppColors.gold,
        fontWeight: FontWeight.w700,
        fontFamily: "Inter",
      ),
      titleSmall: TextStyle(
        fontSize: 20,
        color: AppColors.gold,
        fontWeight: FontWeight.w500,
        fontFamily: "Inter",
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.black,
        fontWeight: FontWeight.w500,
        fontFamily: "Inter",
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: AppColors.gray,
        fontWeight: FontWeight.w500,
        fontFamily: "Inter",
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: AppColors.white,
        fontWeight: FontWeight.w700,
        fontFamily: "Inter",
      ),
      labelSmall: TextStyle(
        fontSize: 14,
        color: AppColors.white,
        fontWeight: FontWeight.w400,
        fontFamily: "Inter",
      ),
    ),
  );
}