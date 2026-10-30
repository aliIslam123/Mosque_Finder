// lib/data/datasources/local/settings_local_datasource.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/settings_model.dart';

class SettingsLocalDataSource {
  static const _keyLanguage = 'language';
  static const _keyDarkMode = 'dark_mode';
  static const _keyRadius = 'radius';
  static const _keyNotifyMosques = 'notify_mosques';
  static const _keyNotifyConfirm = 'notify_confirm';
  static const _keyNotifyReports = 'notify_reports';
  static const _keyLocationEnabled = 'location_enabled';
  static const _keyFontSize = 'font_size';
  static const _keyHaptic = 'haptic';
  static const _keyContributorName = 'contributor_name';
  static const _keyPhone = 'user_phone';
  static const _keyEmail = 'user_email';
  static const _keyPoints = 'contribution_points';

  final SharedPreferences _prefs;

  SettingsLocalDataSource(this._prefs);

  AppSettings load() {
    return AppSettings(
      language: _prefs.getString(_keyLanguage) == 'en'
          ? AppLanguage.english
          : AppLanguage.arabic,
      isDarkMode: _prefs.getBool(_keyDarkMode) ?? false,
      defaultRadius: _radiusFromInt(_prefs.getInt(_keyRadius) ?? 400),
      notifyNewMosques: _prefs.getBool(_keyNotifyMosques) ?? true,
      notifyConfirmations: _prefs.getBool(_keyNotifyConfirm) ?? true,
      notifyReports: _prefs.getBool(_keyNotifyReports) ?? false,
      locationEnabled: _prefs.getBool(_keyLocationEnabled) ?? false,
      fontSize: _prefs.getDouble(_keyFontSize) ?? 1.0,
      hapticFeedback: _prefs.getBool(_keyHaptic) ?? true,
      contributorName: _prefs.getString(_keyContributorName) ?? '',
      phone: _prefs.getString(_keyPhone) ?? '',
      email: _prefs.getString(_keyEmail) ?? '',
      contributionPoints: _prefs.getInt(_keyPoints) ?? 0,
    );
  }

  Future<void> save(AppSettings s) async {
    await _prefs.setString(
        _keyLanguage, s.language == AppLanguage.english ? 'en' : 'ar');
    await _prefs.setBool(_keyDarkMode, s.isDarkMode);
    await _prefs.setInt(_keyRadius, s.radiusInMeters.toInt());
    await _prefs.setBool(_keyNotifyMosques, s.notifyNewMosques);
    await _prefs.setBool(_keyNotifyConfirm, s.notifyConfirmations);
    await _prefs.setBool(_keyNotifyReports, s.notifyReports);
    await _prefs.setBool(_keyLocationEnabled, s.locationEnabled);
    await _prefs.setDouble(_keyFontSize, s.fontSize);
    await _prefs.setBool(_keyHaptic, s.hapticFeedback);
    await _prefs.setString(_keyContributorName, s.contributorName);
    await _prefs.setString(_keyPhone, s.phone);
    await _prefs.setString(_keyEmail, s.email);
    await _prefs.setInt(_keyPoints, s.contributionPoints);
  }

  SearchRadius _radiusFromInt(int r) {
    if (r <= 200) return SearchRadius.r200;
    if (r <= 400) return SearchRadius.r400;
    return SearchRadius.r800;
  }
}
