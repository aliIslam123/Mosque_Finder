// lib/features/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../shared/widgets/app_bar_widget.dart';
import '../../shared/widgets/toast_widget.dart';
import '../../data/models/settings_model.dart';
import 'providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final isArabic = settings.language == AppLanguage.arabic;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MosqueFinderAppBar(
        title: isArabic ? 'الإعدادات' : 'Settings',
        actions: [
          AppBarNotificationButton(
            onTap: () => showAppToast(
              context,
              isArabic ? 'لا توجد إشعارات معلقة' : 'No pending notifications',
            ),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // 1. Contributor Profile Header Card
          _buildProfileCard(context, ref, settings, isArabic),
          const SizedBox(height: AppSpacing.lg),

          // 2. Notifications & Alerts Section
          _buildNotificationsSection(settings, notifier, isArabic),
          const SizedBox(height: AppSpacing.lg),

          // 3. Search Preferences & Scope Section
          _buildPreferencesSection(context, settings, notifier, isArabic),
          const SizedBox(height: AppSpacing.lg),

          // 4. About App & Community Footer
          _buildAboutCard(isArabic),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    WidgetRef ref,
    AppSettings settings,
    bool isArabic,
  ) {
    final initialLetter = settings.contributorName.isNotEmpty
        ? settings.contributorName[0]
        : 'أ';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar Circle
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.primaryDark,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initialLetter,
                  style: AppTextStyles.headlineSm.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Name & Active Contributor Badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          settings.contributorName,
                          style: AppTextStyles.headlineSm.copyWith(fontSize: 16),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.verifiedBg,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_rounded, size: 12, color: AppColors.verified),
                              const SizedBox(width: 3),
                              Text(
                                isArabic ? 'مساهم نشط' : 'Active Contributor',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: AppColors.verified,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.stars_rounded, size: 16, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          isArabic
                              ? '${settings.contributionPoints} نقطة مساهمة'
                              : '${settings.contributionPoints} Contribution Points',
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Edit Button
              GestureDetector(
                onTap: () => _showEditNameSheet(context, ref, settings.contributorName, isArabic),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit_outlined, size: 14, color: AppColors.onSurface),
                      const SizedBox(width: 4),
                      Text(
                        isArabic ? 'تعديل' : 'Edit',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // No-registration guarantee card
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withAlpha(40),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                const Icon(Icons.volunteer_activism_outlined, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isArabic
                        ? 'لا يتطلب تسجيل دخول أو كلمة مرور. الاسم يظهر فقط مع مساهماتك وتوثيقاتك للمساجد المحيطة.'
                        : 'No password or sign-in needed. Your name only appears on contributions to nearby mosques.',
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.primary,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(
    AppSettings settings,
    SettingsNotifier notifier,
    bool isArabic,
  ) {
    return Container(
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
            children: [
              const Icon(Icons.notifications_active_outlined, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'الإشعارات والتنبيهات' : 'Notifications & Alerts',
                style: AppTextStyles.headlineSm.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Item 1: New Mosques
          _buildSwitchRow(
            title: isArabic
                ? 'إشعارات المساجد الجديدة القريبة'
                : 'Nearby New Mosque Alerts',
            subtitle: isArabic
                ? 'تنبيه فوري عند إضافة مسجد جديد في منطقتك'
                : 'Instant alerts when a new mosque is added in your area',
            value: settings.notifyNewMosques,
            onChanged: (val) => notifier.setNotifyNewMosques(val),
          ),
          const Divider(height: 24),

          // Item 2: Community Confirmations
          _buildSwitchRow(
            title: isArabic
                ? 'إشعارات تأكيدات المجتمع'
                : 'Community Confirmation Alerts',
            subtitle: isArabic
                ? 'تأكيد المصلين على مواقيت ومرافق المساجد التي وثقتها'
                : 'When worshippers confirm times & facilities you documented',
            value: settings.notifyConfirmations,
            onChanged: (val) => notifier.setNotifyConfirmations(val),
          ),
          const Divider(height: 24),

          // Item 3: Reports & Reviews
          _buildSwitchRow(
            title: isArabic
                ? 'إشعارات البلاغات والمراجعة'
                : 'Reports & Review Alerts',
            subtitle: isArabic
                ? 'متابعة طلبات التعديل ومراجعة حالة دورات المياه أو التحديثات'
                : 'Follow edit requests and facility maintenance updates',
            value: settings.notifyReports,
            onChanged: (val) => notifier.setNotifyReports(val),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.labelLg.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          activeTrackColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
    bool isArabic,
  ) {
    return Container(
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
            children: [
              const Icon(Icons.tune_rounded, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'التفضيلات ونطاق البحث' : 'Preferences & Search Scope',
                style: AppTextStyles.headlineSm.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Default Search Radius
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic ? 'نطاق الاستكشاف الافتراضي' : 'Default Search Scope',
                style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                isArabic
                    ? '${settings.radiusInMeters.toInt()} متر مشياً (حوالي 5 دقائق)'
                    : '${settings.radiusInMeters.toInt()}m walk (~5 min)',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.primary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Radius Segmented Options
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                _buildSegmentItem(
                  label: isArabic ? '200 م' : '200m',
                  isSelected: settings.defaultRadius == SearchRadius.r200,
                  onTap: () => notifier.setRadius(SearchRadius.r200),
                ),
                _buildSegmentItem(
                  label: isArabic ? '400 م' : '400m',
                  isSelected: settings.defaultRadius == SearchRadius.r400,
                  onTap: () => notifier.setRadius(SearchRadius.r400),
                ),
                _buildSegmentItem(
                  label: isArabic ? '800 م' : '800m',
                  isSelected: settings.defaultRadius == SearchRadius.r800,
                  onTap: () => notifier.setRadius(SearchRadius.r800),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Interface Language
          Text(
            isArabic ? 'لغة الواجهة' : 'Interface Language',
            style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                _buildSegmentItem(
                  label: isArabic ? 'العربية (افتراضي)' : 'العربية',
                  isSelected: settings.language == AppLanguage.arabic,
                  onTap: () => notifier.setLanguage(AppLanguage.arabic),
                ),
                _buildSegmentItem(
                  label: settings.language == AppLanguage.english
                      ? 'English (Active)'
                      : 'English',
                  isSelected: settings.language == AppLanguage.english,
                  onTap: () => notifier.setLanguage(AppLanguage.english),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Dark Theme Toggle
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? 'الوضع الليلي (Dark Mode)' : 'Dark Mode',
                      style: AppTextStyles.labelLg.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      isArabic
                          ? 'مريح للعينين أثناء صلاة الفجر والعشاء'
                          : 'Comfortable reading for Fajr and Isha prayers',
                      style: AppTextStyles.bodySm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: settings.isDarkMode,
                activeTrackColor: AppColors.primary,
                onChanged: (val) => notifier.setDarkMode(val),
              ),
            ],
          ),
          const Divider(height: 24),

          // Location Permission Box
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.verifiedBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.navigation_rounded, color: AppColors.verified, size: 18),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? 'إذن تحديد الموقع' : 'Location Permission',
                        style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        isArabic ? 'مفعّل (دقيق للغاية)' : 'Enabled (High accuracy)',
                        style: AppTextStyles.bodySm.copyWith(
                          color: AppColors.verified,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showAppToast(
                      context,
                      isArabic ? 'تم تأكيد صلاحيات الموقع بدقة' : 'Location permissions confirmed',
                      icon: Icons.check_circle_outline,
                    );
                  },
                  child: Text(
                    isArabic ? 'إعدادات الجهاز' : 'Device Settings',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentItem({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.labelSm.copyWith(
              color: isSelected ? AppColors.onSurface : AppColors.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutCard(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
      ),
      child: Column(
        children: [
          // Mosque Logo Badge
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withAlpha(60),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: const Icon(Icons.mosque_rounded, color: AppColors.primary, size: 30),
          ),
          const SizedBox(height: AppSpacing.sm),

          Text(
            isArabic ? 'مستكشف المساجد' : 'Mosque Finder',
            style: AppTextStyles.headlineSm.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            isArabic ? 'الإصدار 1.0.0 (تحديث رجب 1446)' : 'Version 1.0.0 (Rajab 1446 Update)',
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isArabic
                ? 'تطبيق مجتمعي غير ربحي لمساعدة المصلين وعابري السبيل في مختلف المحافظات.'
                : 'A non-profit community app helping worshippers and travelers find nearby mosques.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite_rounded, size: 14, color: AppColors.flagged),
              const SizedBox(width: 4),
              Text(
                isArabic ? 'مبني بسواعد متطوعي المجتمع' : 'Built with community volunteers',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditNameSheet(
    BuildContext context,
    WidgetRef ref,
    String currentName,
    bool isArabic,
  ) {
    final ctrl = TextEditingController(text: currentName);
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
                isArabic ? 'تعديل اسم المساهم' : 'Edit Contributor Name',
                style: AppTextStyles.headlineSm,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: ctrl,
                decoration: InputDecoration(
                  labelText: isArabic ? 'الاسم' : 'Name',
                  filled: true,
                  fillColor: AppColors.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    final newName = ctrl.text.trim();
                    if (newName.isNotEmpty) {
                      ref.read(settingsProvider.notifier).setContributorName(newName);
                    }
                    Navigator.pop(ctx);
                    showAppToast(
                      context,
                      isArabic ? 'تم حفظ الاسم بنجاح' : 'Name saved successfully',
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
                  child: Text(isArabic ? 'حفظ' : 'Save'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
