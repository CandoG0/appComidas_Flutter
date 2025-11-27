// lib/utils/colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // Colores principales de tu paleta
  static const Color primary = Color(0xFFFF724C);
  static const Color secondary = Color(0xFFFDBF50);
  static const Color background = Color(0xFFF4F4F8);
  static const Color text = Color(0xFF2A2C41);

  // Colores adicionales para estados
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Escala de grises
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // Colores con opacidad
  static Color primaryWithOpacity(double opacity) {
    return primary.withOpacity(opacity);
  }

  static Color textWithOpacity(double opacity) {
    return text.withOpacity(opacity);
  }
}
