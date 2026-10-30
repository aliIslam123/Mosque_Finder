// lib/features/home/providers/home_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/mosque_model.dart';
import '../../../data/datasources/local/mock_mosque_datasource.dart';
import '../../settings/providers/settings_provider.dart';

class HomeState {
  final List<MosqueModel> nearbyMosques;
  final MosqueModel? selectedMosque;
  final double radiusMeters;
  final bool isDetailSheetOpen;

  const HomeState({
    required this.nearbyMosques,
    this.selectedMosque,
    this.radiusMeters = 400,
    this.isDetailSheetOpen = false,
  });

  HomeState copyWith({
    List<MosqueModel>? nearbyMosques,
    Object? selectedMosque = _sentinel,
    double? radiusMeters,
    bool? isDetailSheetOpen,
  }) {
    return HomeState(
      nearbyMosques: nearbyMosques ?? this.nearbyMosques,
      selectedMosque: selectedMosque == _sentinel
          ? this.selectedMosque
          : selectedMosque as MosqueModel?,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      isDetailSheetOpen: isDetailSheetOpen ?? this.isDetailSheetOpen,
    );
  }
}

const _sentinel = Object();

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    final settings = ref.watch(settingsProvider);
    final all = MockMosqueDataSource.getAll();
    final nearby = all
        .where((m) => m.distance <= settings.radiusInMeters)
        .toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));
    return HomeState(
      nearbyMosques: nearby,
      selectedMosque: nearby.isNotEmpty ? nearby.first : null,
      radiusMeters: settings.radiusInMeters,
    );
  }

  void selectMosque(MosqueModel mosque) {
    state = state.copyWith(selectedMosque: mosque, isDetailSheetOpen: false);
  }

  void setRadius(double meters) {
    final all = MockMosqueDataSource.getAll();
    final nearby = all
        .where((m) => m.distance <= meters)
        .toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));
    state = state.copyWith(
      nearbyMosques: nearby,
      radiusMeters: meters,
      selectedMosque: nearby.isNotEmpty ? nearby.first : null,
    );
  }

  void openDetailSheet() => state = state.copyWith(isDetailSheetOpen: true);
  void closeDetailSheet() => state = state.copyWith(isDetailSheetOpen: false);
}

final homeProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);
