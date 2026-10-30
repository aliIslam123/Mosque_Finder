// lib/shared/widgets/app_bar_widget.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_spacing.dart';

class MosqueFinderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final List<Widget>? actions;
  final bool showProfile;

  const MosqueFinderAppBar({
    super.key,
    required this.title,
    this.subtitle = 'Mosque Finder',
    this.actions,
    this.showProfile = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(AppSpacing.appBarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: AppSpacing.appBarHeight + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface.withAlpha(220)
            : AppColors.surfaceLowest.withAlpha(220),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF2A3D2F) : AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            // App Icon + Title
            Row(
              children: [
                _MosqueIcon(),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle,
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      title,
                      style: AppTextStyles.headlineSm.copyWith(
                        color: isDark ? AppColors.darkOnSurface : AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            // Actions
            if (actions != null) ...actions!,
            if (showProfile) ...[
              const SizedBox(width: AppSpacing.xs),
              _ProfileButton(),
            ],
          ],
        ),
      ),
    );
  }
}

class _MosqueIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.mosque, color: AppColors.onPrimary, size: 18),
    );
  }
}

class _ProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: AppColors.onPrimary, size: 18),
    );
  }
}

class AppBarNotificationButton extends StatelessWidget {
  final VoidCallback? onTap;
  const AppBarNotificationButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: const Icon(Icons.notifications_outlined),
      color: AppColors.onSurfaceVariant,
      iconSize: 22,
    );
  }
}
