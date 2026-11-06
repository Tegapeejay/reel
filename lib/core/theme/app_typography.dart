import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static TextTheme textTheme() {
    final base = GoogleFonts.manropeTextTheme(ThemeData.dark().textTheme).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );
    return base.copyWith(
      headlineLarge: base.headlineLarge?.copyWith(
          fontSize: 32, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.5),
      headlineMedium: base.headlineMedium?.copyWith(
          fontSize: 26, fontWeight: FontWeight.w800, height: 1.15, letterSpacing: -0.3),
      titleLarge:
          base.titleLarge?.copyWith(fontSize: 19, fontWeight: FontWeight.w700),
      titleMedium:
          base.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
      titleSmall:
          base.titleSmall?.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
      bodyLarge: base.bodyLarge?.copyWith(fontSize: 15, height: 1.5),
      bodyMedium: base.bodyMedium
          ?.copyWith(fontSize: 14, height: 1.45, color: AppColors.textSecondary),
      bodySmall: base.bodySmall
          ?.copyWith(fontSize: 12, color: AppColors.textSecondary),
      labelLarge:
          base.labelLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
    );
  }
}
