// lib/features/settings/providers/settings_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/settings_model.dart';
import '../../../data/datasources/local/settings_local_datasource.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

final settingsDataSourceProvider = Provider<SettingsLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsLocalDataSource(prefs);
});

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    final ds = ref.watch(settingsDataSourceProvider);
    return ds.load();
  }

  Future<void> _save(AppSettings s) async {
    state = s;
    await ref.read(settingsDataSourceProvider).save(s);
  }

  Future<void> setLanguage(AppLanguage lang) => _save(state.copyWith(language: lang));
  Future<void> setDarkMode(bool value) => _save(state.copyWith(isDarkMode: value));
  Future<void> setRadius(SearchRadius r) => _save(state.copyWith(defaultRadius: r));
  Future<void> setNotifyNewMosques(bool v) => _save(state.copyWith(notifyNewMosques: v));
  Future<void> setNotifyConfirmations(bool v) => _save(state.copyWith(notifyConfirmations: v));
  Future<void> setNotifyReports(bool v) => _save(state.copyWith(notifyReports: v));
  Future<void> setLocationEnabled(bool v) => _save(state.copyWith(locationEnabled: v));
  Future<void> setFontSize(double v) => _save(state.copyWith(fontSize: v));
  Future<void> setHaptic(bool v) => _save(state.copyWith(hapticFeedback: v));

  Future<void> setContributorName(String name) {
    if (name.trim().isEmpty) return Future.value();
    return _save(state.copyWith(contributorName: name.trim()));
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String email,
  }) {
    final points = state.contributionPoints == 0 ? 45 : state.contributionPoints;
    return _save(state.copyWith(
      contributorName: name.trim(),
      phone: phone.trim(),
      email: email.trim(),
      contributionPoints: points,
    ));
  }

  Future<void> addPoints(int points) =>
      _save(state.copyWith(contributionPoints: state.contributionPoints + points));
}

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);
