import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  // 4px base grid
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // Semantic
  static const double screenPadding = 16.0;
  static const double cardPadding = 16.0;
  static const double bottomNavHeight = 64.0;
  static const double appBarHeight = 64.0;
  static const double bottomSafeArea = 88.0;

  // Border Radii
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 9999.0;

  // Specific
  static const double buttonHeight = 48.0;
  static const double inputHeight = 48.0;
  static const double iconSize = 24.0;
  static const double iconSizeSm = 18.0;
  static const double iconSizeLg = 28.0;
  static const double avatarSm = 32.0;
  static const double avatarMd = 44.0;
  static const double avatarLg = 56.0;
  static const double fabSize = 44.0;

  static EdgeInsets get screenInsets =>
      const EdgeInsets.symmetric(horizontal: screenPadding);

  static BorderRadius get cardRadius =>
      BorderRadius.circular(radiusLg);

  static BorderRadius get buttonRadius =>
      BorderRadius.circular(radiusMd);

  static BorderRadius get inputRadius =>
      BorderRadius.circular(radiusMd);

  static BorderRadius get badgeRadius =>
      BorderRadius.circular(radiusFull);

  static BorderRadius get sheetRadius => const BorderRadius.only(
        topLeft: Radius.circular(radiusXl),
        topRight: Radius.circular(radiusXl),
      );
}
