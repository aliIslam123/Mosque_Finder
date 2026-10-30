// lib/features/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../shared/widgets/toast_widget.dart';
import '../../data/models/settings_model.dart';
import '../settings/providers/settings_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isArabic = settings.language == AppLanguage.arabic;
    final isRegistered = settings.isProfileRegistered;

    final initialLetter = settings.contributorName.isNotEmpty
        ? settings.contributorName[0]
        : (isArabic ? 'م' : 'M');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isArabic ? 'الملف الشخصي' : 'Profile',
          style: AppTextStyles.headlineSm.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isArabic ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
            color: AppColors.onSurface,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            tooltip: isArabic ? 'تعديل البيانات' : 'Edit Profile',
            onPressed: () => _showEditProfileDialog(context, ref, settings, isArabic),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          // 1. Header Profile Banner Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: AppSpacing.cardRadius,
              border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.onSurface.withAlpha(10),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Avatar with Badge
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryDark,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initialLetter,
                        style: AppTextStyles.displayLg.copyWith(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isRegistered ? Icons.check_circle_rounded : Icons.account_circle_outlined,
                        size: 22,
                        color: isRegistered ? AppColors.verified : AppColors.unverified,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Name
                Text(
                  settings.contributorName.isNotEmpty
                      ? settings.contributorName
                      : (isArabic ? 'ضيف غير مسجل' : 'Guest Contributor'),
                  style: AppTextStyles.headlineSm.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),

                // Status Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isRegistered ? AppColors.verifiedBg : AppColors.unverifiedBg,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isRegistered ? Icons.verified_user_rounded : Icons.pending_outlined,
                        size: 14,
                        color: isRegistered ? AppColors.verified : AppColors.unverified,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isRegistered
                            ? (isArabic ? 'مساهم معتمد في المجتمع' : 'Verified Community Member')
                            : (isArabic ? 'يلزم إكمال البيانات للتفعيل' : 'Profile Incomplete'),
                        style: AppTextStyles.labelSm.copyWith(
                          color: isRegistered ? AppColors.verified : AppColors.unverified,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Points counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.stars_rounded, color: AppColors.primary, size: 22),
                    const SizedBox(width: 6),
                    Text(
                      isArabic
                          ? '${settings.contributionPoints} نقطة مساهمة'
                          : '${settings.contributionPoints} Contribution Points',
                      style: AppTextStyles.labelLg.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // 2. Personal Information Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: AppSpacing.cardRadius,
              border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isArabic ? 'بيانات الاتصال والتسجيل' : 'Contact & Registration Info',
                      style: AppTextStyles.headlineSm.copyWith(fontSize: 16),
                    ),
                    TextButton.icon(
                      onPressed: () => _showEditProfileDialog(context, ref, settings, isArabic),
                      icon: const Icon(Icons.edit, size: 14),
                      label: Text(isArabic ? 'تعديل' : 'Edit'),
                    ),
                  ],
                ),
                const Divider(height: 16),

                _buildInfoTile(
                  icon: Icons.person_outline_rounded,
                  label: isArabic ? 'الاسم الكامل' : 'Full Name',
                  value: settings.contributorName.isNotEmpty ? settings.contributorName : (isArabic ? 'غير محدد' : 'Not set'),
                ),
                const SizedBox(height: 12),
                _buildInfoTile(
                  icon: Icons.phone_outlined,
                  label: isArabic ? 'رقم الهاتف' : 'Phone Number',
                  value: settings.phone.isNotEmpty ? settings.phone : (isArabic ? 'غير محدد' : 'Not set'),
                ),
                const SizedBox(height: 12),
                _buildInfoTile(
                  icon: Icons.email_outlined,
                  label: isArabic ? 'البريد الإلكتروني' : 'Email Address',
                  value: settings.email.isNotEmpty ? settings.email : (isArabic ? 'غير محدد' : 'Not set'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // 3. Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  icon: Icons.add_location_alt_outlined,
                  color: AppColors.primary,
                  count: isRegistered ? '3' : '0',
                  label: isArabic ? 'مساجد أضفتها' : 'Added',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildStatBox(
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.verified,
                  count: isRegistered ? '12' : '0',
                  label: isArabic ? 'مساجد أكدتها' : 'Confirmed',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildStatBox(
                  icon: Icons.flag_outlined,
                  color: AppColors.flagged,
                  count: isRegistered ? '1' : '0',
                  label: isArabic ? 'بلاغات قدمتها' : 'Reports',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // 4. Badges & Recognition Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceLowest,
              borderRadius: AppSpacing.cardRadius,
              border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'الأوسمة والإنجازات' : 'Badges & Achievements',
                  style: AppTextStyles.headlineSm.copyWith(fontSize: 16),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBadgeItem(
                      icon: Icons.volunteer_activism_rounded,
                      title: isArabic ? 'عمار المساجد' : 'Pioneer',
                      unlocked: isRegistered,
                    ),
                    _buildBadgeItem(
                      icon: Icons.explore_rounded,
                      title: isArabic ? 'مستكشف الحي' : 'Explorer',
                      unlocked: isRegistered,
                    ),
                    _buildBadgeItem(
                      icon: Icons.schedule_rounded,
                      title: isArabic ? 'حارس المواقيت' : 'Timekeeper',
                      unlocked: isRegistered,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySm.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
            Text(
              value,
              style: AppTextStyles.labelMd.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatBox({
    required IconData icon,
    required Color color,
    required String count,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(
            count,
            style: AppTextStyles.headlineSm.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem({
    required IconData icon,
    required String title,
    required bool unlocked,
  }) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: unlocked ? AppColors.primaryMuted : AppColors.surfaceContainer,
            shape: BoxShape.circle,
            border: Border.all(
              color: unlocked ? AppColors.primary : AppColors.outlineVariant.withAlpha(60),
              width: 1.5,
            ),
          ),
          child: Icon(
            icon,
            color: unlocked ? AppColors.primary : AppColors.outlineVariant,
            size: 26,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: AppTextStyles.labelSm.copyWith(
            fontWeight: FontWeight.bold,
            color: unlocked ? AppColors.onSurface : AppColors.outlineVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
    bool isArabic,
  ) {
    final nameCtrl = TextEditingController(text: settings.contributorName);
    final phoneCtrl = TextEditingController(text: settings.phone);
    final emailCtrl = TextEditingController(text: settings.email);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
            top: AppSpacing.lg,
            left: AppSpacing.lg,
            right: AppSpacing.lg,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surfaceLowest,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outline.withAlpha(80),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  isArabic ? 'تعديل البيانات الشخصية' : 'Edit Profile Information',
                  style: AppTextStyles.headlineSm,
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic
                      ? 'الاسم ورقم الهاتف والبريد ضرورية لتفعيل خدمات ومشاركات المجتمع'
                      : 'Name, phone, and email are required to unlock community features',
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.md),

                // Name
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    labelText: isArabic ? 'الاسم الكامل' : 'Full Name',
                    prefixIcon: const Icon(Icons.person_outline),
                    filled: true,
                    fillColor: AppColors.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Phone
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: isArabic ? 'رقم الهاتف' : 'Phone Number',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    hintText: '01xxxxxxxxx',
                    filled: true,
                    fillColor: AppColors.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Email
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: isArabic ? 'البريد الإلكتروني' : 'Email Address',
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintText: 'example@domain.com',
                    filled: true,
                    fillColor: AppColors.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      final name = nameCtrl.text.trim();
                      final phone = phoneCtrl.text.trim();
                      final email = emailCtrl.text.trim();

                      if (name.isEmpty || phone.isEmpty || email.isEmpty) {
                        showAppToast(
                          context,
                          isArabic
                              ? 'يرجى إكمال جميع الحقول (الاسم، الهاتف، والبريد)'
                              : 'Please fill in all fields (name, phone, email)',
                        );
                        return;
                      }

                      ref.read(settingsProvider.notifier).updateProfile(
                            name: name,
                            phone: phone,
                            email: email,
                          );

                      Navigator.pop(ctx);
                      showAppToast(
                        context,
                        isArabic ? 'تم حفظ وتحديث الملف بنجاح' : 'Profile updated successfully',
                        icon: Icons.check_circle_outline,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                    ),
                    child: Text(isArabic ? 'حفظ البيانات' : 'Save Profile'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
