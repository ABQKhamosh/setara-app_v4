import 'package:flutter/material.dart';

class AppColors {
  static const Color anar = Color(0xFFD7263D);
  static const Color anarDark = Color(0xFFA3122A);
  static const Color anarLight = Color(0xFFFFE3E7);
  static const Color leaf = Color(0xFF2E9E5B);
  static const Color leafDark = Color(0xFF1F7A43);
  static const Color leafLight = Color(0xFFDDF5E7);
  static const Color gold = Color(0xFFFFC93C);
  static const Color goldDark = Color(0xFFE0A100);
  static const Color cream = Color(0xFFFFF6E9);
  static const Color ink = Color(0xFF2B2437);
  static const Color inkSoft = Color(0xFF7A708C);
  static const Color line = Color(0xFFEADFCF);
}

class Txt {
  static const TextStyle h1 = TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.ink, height: 1.3);
  static const TextStyle h2 = TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ink, height: 1.35);
  static const TextStyle body = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.ink, height: 1.5);
  static const TextStyle small = TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.inkSoft, height: 1.4);
}

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.anar),
    scaffoldBackgroundColor: AppColors.cream,
  );
}
