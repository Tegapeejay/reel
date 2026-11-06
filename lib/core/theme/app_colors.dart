import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color background = Color(0xFF090B10);
  static const Color backgroundSecondary = Color(0xFF11151D);
  static const Color surface = Color(0xFF181E28);
  static const Color primary = Color(0xFF8B5CF6);
  static const Color secondary = Color(0xFF22D3EE);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color border = Color(0xFF262E3B);
  static const Color star = Color(0xFFFACC15);
  static const Color error = Color(0xFFF87171);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [primary, secondary],
  );
}
