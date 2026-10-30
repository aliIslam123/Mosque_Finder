// lib/shared/widgets/status_badge.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_spacing.dart';
import '../../data/models/mosque_model.dart';

class StatusBadge extends StatelessWidget {
  final MosqueStatus status;
  final bool small;

  const StatusBadge({
    super.key,
    required this.status,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _BadgeConfig.forStatus(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 6 : 8,
        vertical: small ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: AppSpacing.badgeRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: small ? 10 : 13, color: config.textColor),
          const SizedBox(width: 3),
          Text(
            config.label,
            style: (small ? AppTextStyles.labelSm : AppTextStyles.labelMd).copyWith(
              color: config.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeConfig {
  final Color bgColor;
  final Color textColor;
  final IconData icon;
  final String label;

  const _BadgeConfig({
    required this.bgColor,
    required this.textColor,
    required this.icon,
    required this.label,
  });

  static _BadgeConfig forStatus(MosqueStatus status) {
    switch (status) {
      case MosqueStatus.verified:
        return const _BadgeConfig(
          bgColor: AppColors.verifiedBg,
          textColor: AppColors.verifiedGreen,
          icon: Icons.verified_outlined,
          label: 'موثّق مجتمعيًا',
        );
      case MosqueStatus.unverified:
        return const _BadgeConfig(
          bgColor: AppColors.unverifiedBg,
          textColor: AppColors.unverifiedAmber,
          icon: Icons.hourglass_top_outlined,
          label: 'غير متحقق منه',
        );
      case MosqueStatus.flagged:
        return const _BadgeConfig(
          bgColor: AppColors.flaggedBg,
          textColor: AppColors.flaggedRed,
          icon: Icons.warning_amber_outlined,
          label: 'مشكوك في تواجده',
        );
    }
  }
}
