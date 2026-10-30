import 'package:flutter/material.dart';

/// Design system colors extracted from DESIGN.md and HTML design files
class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF167447);       // primary-container / brand
  static const Color primaryDeep = Color(0xFF005A34);   // primary (dark)
  static const Color primaryDark = Color(0xFF005A34);
  static const Color primaryContainer = Color(0xFFE4F1E7);
  static const Color primaryMuted = Color(0xFFEAF7ED);
  static const Color secondary = Color(0xFF006D3F);

  // ── Backgrounds & Surfaces ────────────────────────────────────────────
  static const Color background = Color(0xFFF0FDF2);
  static const Color surface = Color(0xFFF0FDF2);
  static const Color surfaceLowest = Color(0xFFFFFFFF);
  static const Color surfaceLow = Color(0xFFEAF7ED);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF0FDF2);
  static const Color surfaceContainer = Color(0xFFE4F1E7);
  static const Color surfaceContainerHigh = Color(0xFFDEEBE1);
  static const Color surfaceHigh = Color(0xFFDEEBE1);
  static const Color surfaceHighest = Color(0xFFD9E6DC);
  static const Color surfaceDim = Color(0xFFD0DDD4);

  // ── Text ──────────────────────────────────────────────────────────────
  static const Color onSurface = Color(0xFF131E18);
  static const Color onSurfaceVariant = Color(0xFF3F4941);
  static const Color outline = Color(0xFF6F7A71);
  static const Color outlineVariant = Color(0xFFBEC9BF);

  // ── On Colors ─────────────────────────────────────────────────────────
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF9FF7BE);
  static const Color primaryFixed = Color(0xFF9EF5BD);
  static const Color primaryFixedDim = Color(0xFF82D8A2);

  static const Color secondaryContainer = Color(0xFF97F7B9);
  static const Color onSecondaryContainer = Color(0xFF007443);
  static const Color secondaryFixed = Color(0xFF97F7B9);

  // ── Status ────────────────────────────────────────────────────────────
  static const Color verified = Color(0xFF218653);
  static const Color verifiedGreen = Color(0xFF218653);
  static const Color verifiedBg = Color(0xFFEAF6EF);

  static const Color unverified = Color(0xFFD99A16);
  static const Color unverifiedAmber = Color(0xFFD99A16);
  static const Color unverifiedBg = Color(0xFFFEF7E6);

  static const Color flagged = Color(0xFFD64545);
  static const Color flaggedRed = Color(0xFFD64545);
  static const Color flaggedBg = Color(0xFFFDF0F0);

  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);

  // ── Tertiary (amber/gold for community points) ─────────────────────────
  static const Color tertiaryContainer = Color(0xFF885E00);
  static const Color tertiaryFixed = Color(0xFFFFDEAC);
  static const Color tertiaryFixedDim = Color(0xFFFEBA3A);
  static const Color onTertiaryFixed = Color(0xFF281900);
  static const Color onTertiaryFixedVariant = Color(0xFF604100);

  // ── Inverse ───────────────────────────────────────────────────────────
  static const Color inverseSurface = Color(0xFF28332C);
  static const Color inverseOnSurface = Color(0xFFE7F4EA);
  static const Color inversePrimary = Color(0xFF82D8A2);

  // ── Shadows & Borders ─────────────────────────────────────────────────
  static const Color border = Color(0xFFE6EAE7);
  static const Color shadow1 = Color(0x0A17221C);
  static const Color shadow2 = Color(0x1417221C);
  static const Color shadow3 = Color(0x2017221C);

  // ── Dark Theme ────────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0D1610);
  static const Color darkSurface = Color(0xFF131E18);
  static const Color darkSurfaceLowest = Color(0xFF1A2A1F);
  static const Color darkSurfaceLow = Color(0xFF1E2E23);
  static const Color darkSurfaceContainer = Color(0xFF222F27);
  static const Color darkOnSurface = Color(0xFFE2F0E6);
  static const Color darkOnSurfaceVariant = Color(0xFFB0BDB3);
  static const Color darkOutline = Color(0xFF8B9A8E);
}
