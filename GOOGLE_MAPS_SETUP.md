# 🗺️ Google Maps Integration Guide (Phase 2)

In Phase 1, **Mosque Finder** renders an interactive vector-based canvas map via `CustomPainter` (`lib/features/home/widgets/map_view.dart`), which provides full pan-and-zoom simulation, dynamic 200m/400m/800m search radii, and clickable mosque marker pins with custom status badges.

This document describes how to replace the custom canvas map with the official Google Maps Flutter SDK in Phase 2.

---

## 1. Prerequisites & API Keys

### A. Obtain Google Maps API Keys
1. Navigate to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create or select your project: `mosque-finder-prod`.
3. Enable **Maps SDK for Android** and **Maps SDK for iOS**.
4. Generate two separate API keys and restrict them by package name / bundle identifier.

---

## 2. Platform Configuration

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<manifest ...>
    <!-- Location Permissions -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />

    <application ...>
        <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="YOUR_ANDROID_MAPS_API_KEY" />
    </application>
</manifest>
```

### iOS (`ios/Runner/AppDelegate.swift` and `Info.plist`)
In `AppDelegate.swift`:
```swift
import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_IOS_MAPS_API_KEY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

In `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>يحتاج تطبيق مستكشف المساجد لتحديد موقعك لعرض أقرب المساجد ومواقيت الأذان الدقيقة.</string>
```

---

## 3. Dependency Setup

Add `google_maps_flutter` in `pubspec.yaml`:
```yaml
dependencies:
  google_maps_flutter: ^2.10.0
```

---

## 4. Code Migration (`map_view.dart`)

Replace the `CustomPaint` body in `lib/features/home/widgets/map_view.dart` with `GoogleMap`:

```dart
GoogleMap(
  initialCameraPosition: CameraPosition(
    target: LatLng(userLat, userLng),
    zoom: 15.5,
  ),
  myLocationEnabled: true,
  myLocationButtonEnabled: false,
  zoomControlsEnabled: false,
  circles: {
    Circle(
      circleId: const CircleId('search_radius'),
      center: LatLng(userLat, userLng),
      radius: homeState.selectedRadius,
      fillColor: AppColors.primary.withAlpha(20),
      strokeColor: AppColors.primary,
      strokeWidth: 2,
    ),
  },
  markers: homeState.mosques.map((mosque) {
    return Marker(
      markerId: MarkerId(mosque.id),
      position: LatLng(mosque.latitude, mosque.longitude),
      icon: _getMarkerBitmapForStatus(mosque.status),
      onTap: () => ref.read(homeProvider.notifier).selectMosque(mosque),
    );
  }).toSet(),
  onMapCreated: (controller) {
    _mapController = controller;
    // Apply soft light/dark map styling JSON matching AppColors
  },
)
```

The bottom sheet preview (`_BottomMosqueCard`), top bar, filter buttons, and radius pickers will continue functioning without any changes.
