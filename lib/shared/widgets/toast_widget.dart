// lib/shared/widgets/toast_widget.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_spacing.dart';

void showAppToast(
  BuildContext context,
  String message, {
  IconData icon = Icons.check_circle_outline,
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            icon,
            color: isError ? AppColors.errorContainer : AppColors.inversePrimary,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.inverseOnSurface,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.inverseSurface,
      duration: const Duration(milliseconds: 2500),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusMd)),
      ),
    ),
  );
}
