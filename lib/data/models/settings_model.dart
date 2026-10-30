// lib/data/models/settings_model.dart

enum AppLanguage { arabic, english }

enum SearchRadius { r200, r400, r800 }

enum DistanceUnit { meters, kilometers }

class AppSettings {
  final AppLanguage language;
  final bool isDarkMode;
  final SearchRadius defaultRadius;
  final DistanceUnit distanceUnit;
  final bool notifyNewMosques;
  final bool notifyConfirmations;
  final bool notifyReports;
  final bool locationEnabled;
  final double fontSize; // 1.0 = normal
  final bool hapticFeedback;
  final String contributorName;
  final String phone;
  final String email;
  final int contributionPoints;

  const AppSettings({
    this.language = AppLanguage.arabic,
    this.isDarkMode = false,
    this.defaultRadius = SearchRadius.r400,
    this.distanceUnit = DistanceUnit.meters,
    this.notifyNewMosques = true,
    this.notifyConfirmations = true,
    this.notifyReports = false,
    this.locationEnabled = false,
    this.fontSize = 1.0,
    this.hapticFeedback = true,
    this.contributorName = '',
    this.phone = '',
    this.email = '',
    this.contributionPoints = 0,
  });

  bool get isProfileRegistered =>
      contributorName.trim().isNotEmpty &&
      phone.trim().isNotEmpty &&
      email.trim().isNotEmpty;

  double get radiusInMeters {
    switch (defaultRadius) {
      case SearchRadius.r200:
        return 200;
      case SearchRadius.r400:
        return 400;
      case SearchRadius.r800:
        return 800;
    }
  }

  String get radiusLabel {
    switch (defaultRadius) {
      case SearchRadius.r200:
        return '٢٠٠ م';
      case SearchRadius.r400:
        return '٤٠٠ م';
      case SearchRadius.r800:
        return '٨٠٠ م';
    }
  }

  AppSettings copyWith({
    AppLanguage? language,
    bool? isDarkMode,
    SearchRadius? defaultRadius,
    DistanceUnit? distanceUnit,
    bool? notifyNewMosques,
    bool? notifyConfirmations,
    bool? notifyReports,
    bool? locationEnabled,
    double? fontSize,
    bool? hapticFeedback,
    String? contributorName,
    String? phone,
    String? email,
    int? contributionPoints,
  }) {
    return AppSettings(
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      defaultRadius: defaultRadius ?? this.defaultRadius,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      notifyNewMosques: notifyNewMosques ?? this.notifyNewMosques,
      notifyConfirmations: notifyConfirmations ?? this.notifyConfirmations,
      notifyReports: notifyReports ?? this.notifyReports,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      fontSize: fontSize ?? this.fontSize,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      contributorName: contributorName ?? this.contributorName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      contributionPoints: contributionPoints ?? this.contributionPoints,
    );
  }
}
