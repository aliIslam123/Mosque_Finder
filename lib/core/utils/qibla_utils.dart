// lib/core/utils/qibla_utils.dart
import 'dart:math';

/// Qibla calculation utilities.
/// Calculates the bearing from any coordinate to the Kaaba in Mecca.
class QiblaUtils {
  QiblaUtils._();

  /// Kaaba coordinates
  static const double kaabaLat = 21.4225;
  static const double kaabaLng = 39.8262;

  /// Calculate Qibla bearing from [lat], [lng] to Kaaba.
  /// Returns bearing in degrees (0–360, clockwise from North).
  static double calculateQibla(double lat, double lng) {
    final latRad = _toRad(lat);
    final lngRad = _toRad(lng);
    final kLatRad = _toRad(kaabaLat);
    final kLngRad = _toRad(kaabaLng);

    final dLng = kLngRad - lngRad;

    final x = sin(dLng) * cos(kLatRad);
    final y = cos(latRad) * sin(kLatRad) -
        sin(latRad) * cos(kLatRad) * cos(dLng);

    final bearing = atan2(x, y);
    return (_toDeg(bearing) + 360) % 360;
  }

  static double _toRad(double deg) => deg * pi / 180;
  static double _toDeg(double rad) => rad * 180 / pi;

  /// Returns whether heading is within [tolerance] degrees of target
  static bool isAligned(double heading, double target,
      {double tolerance = 5.0}) {
    final diff = ((heading - target) % 360 + 360) % 360;
    return diff < tolerance || diff > (360 - tolerance);
  }
}
