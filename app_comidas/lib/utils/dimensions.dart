// lib/utils/dimensions.dart

import 'package:flutter/material.dart';

class AppDimensions {
  // Métodos para obtener dimensiones responsive
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // Padding y márgenes
  static EdgeInsets getScreenPadding(BuildContext context) {
    return EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.06);
  }

  static double getStandardHorizontalPadding(BuildContext context) {
    return getScreenWidth(context) * 0.06;
  }

  static EdgeInsets getCardPadding(BuildContext context) {
    return EdgeInsets.all(getScreenWidth(context) * 0.04);
  }

  // Tamaños de texto responsive
  static double getTitleLargeSize(BuildContext context) {
    return getScreenWidth(context) * 0.08;
  }

  static double getTitleMediumSize(BuildContext context) {
    return getScreenWidth(context) * 0.075;
  }

  static double getTitleSmallSize(BuildContext context) {
    return getScreenWidth(context) * 0.06;
  }

  static double getBodyLargeSize(BuildContext context) {
    return getScreenWidth(context) * 0.045;
  }

  static double getBodyMediumSize(BuildContext context) {
    return getScreenWidth(context) * 0.04;
  }

  static double getBodySmallSize(BuildContext context) {
    return getScreenWidth(context) * 0.035;
  }

  static double getCaptionSize(BuildContext context) {
    return getScreenWidth(context) * 0.03;
  }

  // Alturas fijas (puedes mantener las que ya tienes)
  static const double buttonHeight = 56;
  static const double appBarHeight = 100;
  static const double bottomBarHeight = 70;
  static const double inputFieldHeight = 56;
  static const double categorySelectorHeight = 50;
  static const double cartFooterHeight = 80;

  // Espacios fijos (para mantener consistencia)
  static const double spaceSmall = 8;
  static const double spaceMedium = 16;
  static const double spaceLarge = 24;
  static const double spaceXLarge = 32;
  static const double spaceXXLarge = 40;

  // Border radius
  static const double borderRadiusSmall = 8;
  static const double borderRadiusMedium = 12;
  static const double borderRadiusLarge = 16;
  static const double borderRadiusXLarge = 20;

  // Tamaños de iconos
  static double getIconSizeLarge(BuildContext context) {
    return getScreenWidth(context) * 0.08;
  }

  static double getIconSizeMedium(BuildContext context) {
    return getScreenWidth(context) * 0.06;
  }

  static double getIconSizeSmall(BuildContext context) {
    return getScreenWidth(context) * 0.04;
  }

  // Tamaños de imágenes y avatares
  static double getAvatarSizeLarge(BuildContext context) {
    return getScreenWidth(context) * 0.25;
  }

  static double getAvatarSizeMedium(BuildContext context) {
    return getScreenWidth(context) * 0.15;
  }

  static double getAvatarSizeSmall(BuildContext context) {
    return getScreenWidth(context) * 0.1;
  }

  // Alturas de tarjetas
  static double getCardHeightMedium(BuildContext context) {
    return getScreenWidth(context) * 0.5;
  }

  static double getCardHeightLarge(BuildContext context) {
    return getScreenWidth(context) * 0.6;
  }

  // Métodos de ayuda para usar en tus pantallas existentes
  static EdgeInsets symmetricPadding(
    BuildContext context, {
    double horizontal = 0.06,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: getScreenWidth(context) * horizontal,
      vertical: getScreenHeight(context) * vertical,
    );
  }

  static EdgeInsets allPadding(BuildContext context, {double factor = 0.04}) {
    return EdgeInsets.all(getScreenWidth(context) * factor);
  }
}
