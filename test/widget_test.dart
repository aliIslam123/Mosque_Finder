// test/widget_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mosque_finder/core/utils/qibla_utils.dart';
import 'package:mosque_finder/data/datasources/local/mock_mosque_datasource.dart';
import 'package:mosque_finder/data/datasources/local/mock_community_datasource.dart';
import 'package:mosque_finder/data/models/mosque_model.dart';

void main() {
  group('Qibla Calculations', () {
    test('Calculates bearing to Kaaba from Cairo accurately', () {
      // Cairo coordinates
      final bearing = QiblaUtils.calculateQibla(30.0444, 31.2357);
      // Bearing from Cairo to Makkah is approximately 136° SE
      expect(bearing, closeTo(136.0, 2.0));
    });

    test('Checks alignment within tolerance', () {
      expect(QiblaUtils.isAligned(136.0, 136.0, tolerance: 3.0), isTrue);
      expect(QiblaUtils.isAligned(138.0, 136.0, tolerance: 3.0), isTrue);
      expect(QiblaUtils.isAligned(150.0, 136.0, tolerance: 3.0), isFalse);
    });
  });

  group('Mock Mosque Datasource', () {
    test('Returns 10+ realistic mosques', () {
      final mosques = MockMosqueDataSource.getAll();
      expect(mosques.length, greaterThanOrEqualTo(10));
    });

    test('Can find mosque by ID', () {
      final mosque = MockMosqueDataSource.getById('masjid_nour');
      expect(mosque, isNotNull);
      expect(mosque!.nameAr, contains('النور'));
      expect(mosque.status, MosqueStatus.verified);
    });

    test('Filters mosques by status', () {
      final verified = MockMosqueDataSource.getByStatus(MosqueStatus.verified);
      expect(verified, isNotEmpty);
      expect(verified.every((m) => m.status == MosqueStatus.verified), isTrue);
    });
  });

  group('Mock Community Datasource', () {
    test('Returns community activity feed items', () {
      final activities = MockCommunityDataSource.getActivities();
      expect(activities, isNotEmpty);
      expect(activities.first.contributorName, isNotEmpty);
    });
  });
}
