// lib/features/qibla/qibla_screen.dart
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/qibla_utils.dart';
import '../../shared/widgets/app_bar_widget.dart';
import '../../shared/widgets/toast_widget.dart';
import '../../data/models/settings_model.dart';
import '../settings/providers/settings_provider.dart';
import 'widgets/compass_widget.dart';

class QiblaScreen extends ConsumerStatefulWidget {
  const QiblaScreen({super.key});

  @override
  ConsumerState<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends ConsumerState<QiblaScreen> {
  // Default coordinates (Cairo, Egypt) as safe baseline
  double _userLat = 30.0444;
  double _userLng = 31.2357;
  String _locationName = 'القاهرة، مصر';
  bool _isLiveLocation = false;

  late double _qiblaBearing;
  double _currentHeading = 0.0;
  bool _hasSensorSignal = false;
  bool _lastAlignedState = false;

  StreamSubscription<MagnetometerEvent>? _sensorSubscription;

  @override
  void initState() {
    super.initState();
    _qiblaBearing = QiblaUtils.calculateQibla(_userLat, _userLng);
    _initSensors();
    _requestLiveLocation();
  }

  @override
  void dispose() {
    _sensorSubscription?.cancel();
    super.dispose();
  }

  void _initSensors() {
    _sensorSubscription = magnetometerEventStream(
      samplingPeriod: SensorInterval.uiInterval,
    ).listen(
      (event) {
        // Calculate compass azimuth from magnetometer vectors
        final rawHeading = (math.atan2(-event.x, event.y) * 180 / math.pi + 360) % 360;

        // Apply low-pass filter (exponential smoothing) to eliminate jitter
        final diff = (rawHeading - _currentHeading + 540) % 360 - 180;
        final newHeading = (_currentHeading + diff * 0.25 + 360) % 360;

        if (mounted) {
          setState(() {
            _hasSensorSignal = true;
            _currentHeading = newHeading;
          });
          _checkAlignmentFeedback();
        }
      },
      onError: (err) {
        if (mounted) {
          setState(() => _hasSensorSignal = false);
        }
      },
    );
  }

  Future<void> _requestLiveLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 5),
          ),
        );

        if (mounted) {
          setState(() {
            _userLat = pos.latitude;
            _userLng = pos.longitude;
            _isLiveLocation = true;
            _qiblaBearing = QiblaUtils.calculateQibla(pos.latitude, pos.longitude);
            _locationName = '${pos.latitude.toStringAsFixed(2)}° N, ${pos.longitude.toStringAsFixed(2)}° E';
          });
        }
      }
    } catch (_) {
      // Fallback seamlessly to Cairo coordinates
    }
  }

  bool get _isAligned => (_currentHeading - _qiblaBearing).abs() <= 3.0;

  void _checkAlignmentFeedback() {
    final currentlyAligned = _isAligned;
    if (currentlyAligned && !_lastAlignedState) {
      final settings = ref.read(settingsProvider);
      if (settings.hapticFeedback) {
        HapticFeedback.mediumImpact();
      }
    }
    _lastAlignedState = currentlyAligned;
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isArabic = settings.language == AppLanguage.arabic;

    final diff = (_qiblaBearing - _currentHeading).round();
    final directionAdvice = _isAligned
        ? (isArabic ? 'أنت تواجه القبلة مباشرة 🕋' : 'Directly Facing Qibla 🕋')
        : diff > 0
            ? (isArabic ? 'أدر الهاتف يميناً بمقدار $diff°' : 'Turn right by $diff°')
            : (isArabic
                ? 'أدر الهاتف يساراً بمقدار ${diff.abs()}°'
                : 'Turn left by ${diff.abs()}°');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MosqueFinderAppBar(
        title: isArabic ? 'اتجاه القبلة' : 'Qibla Direction',
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location_rounded, color: AppColors.primary),
            tooltip: isArabic ? 'تحديث الموقع الجغرافي' : 'Update Location',
            onPressed: () {
              _requestLiveLocation();
              showAppToast(
                context,
                isArabic ? 'جاري تحديث الموقع وحساب القبلة...' : 'Updating location...',
                icon: Icons.gps_fixed_rounded,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // 1. Live Sensor Status Banner
            _buildSensorStatusBadge(isArabic),
            const SizedBox(height: AppSpacing.md),

            // 2. Heading Degree & Direction Advice Pill
            _buildHeadingHeader(isArabic, directionAdvice),
            const SizedBox(height: AppSpacing.xl),

            // 3. Central Interactive Real Compass
            Center(
              child: CompassWidget(
                heading: _currentHeading,
                qiblaBearing: _qiblaBearing,
                isAligned: _isAligned,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // 4. Calibration & Guidance Card
            _buildCalibrationCard(isArabic),
            const SizedBox(height: AppSpacing.md),

            // 5. Geographic Coordinates & Azimuth Card
            _buildCoordinatesCard(isArabic),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorStatusBadge(bool isArabic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: AppColors.outlineVariant.withAlpha(70)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _hasSensorSignal ? AppColors.verified : AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _hasSensorSignal
                ? (isArabic ? 'مستشعر البوصلة: نشط ومتصل في الوقت الفعلي' : 'Compass Sensor: Active & Live')
                : (isArabic ? 'في انتظار إشارة مستشعر البوصلة...' : 'Waiting for sensor...'),
            style: AppTextStyles.labelSm.copyWith(
              color: _hasSensorSignal ? AppColors.verified : AppColors.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadingHeader(bool isArabic, String directionAdvice) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '${_currentHeading.round()}°',
              style: AppTextStyles.displayLg.copyWith(
                fontWeight: FontWeight.bold,
                color: _isAligned ? AppColors.verified : AppColors.onSurface,
                fontSize: 42,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isArabic ? 'الاتجاه الحالي' : 'Heading',
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _isAligned ? AppColors.verifiedBg : AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: Border.all(
              color: _isAligned ? AppColors.verified : Colors.transparent,
              width: 1.4,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isAligned ? Icons.check_circle_rounded : Icons.explore_rounded,
                size: 18,
                color: _isAligned ? AppColors.verified : AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                directionAdvice,
                style: AppTextStyles.labelMd.copyWith(
                  color: _isAligned ? AppColors.verified : AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalibrationCard(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceLowest,
        borderRadius: AppSpacing.cardRadius,
        border: Border.all(color: AppColors.outlineVariant.withAlpha(80)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryMuted,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.screen_rotation_rounded, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'نصيحة لدقة البوصلة' : 'Compass Accuracy Tip',
                  style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  isArabic
                      ? 'ضع الهاتف أفقياً في راحة يدك، وحرّكه على شكل الرقم 8 في الهواء لمعايرة المستشعر إذا لاحظت أي تذبذب.'
                      : 'Hold phone flat and move in a figure-8 motion to calibrate the magnetometer sensor.',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoordinatesCard(bool isArabic) {
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
              const Icon(Icons.my_location_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'بيانات الموقع وزاوية القبلة' : 'Location & Qibla Azimuth',
                style: AppTextStyles.headlineSm.copyWith(fontSize: 15),
              ),
              const Spacer(),
              if (_isLiveLocation)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.verifiedBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isArabic ? 'موقع دقيق GPS' : 'GPS Live',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.verified,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildInfoRow(
            label: isArabic ? 'موقعك المحسوب' : 'Your Location',
            value: _locationName,
          ),
          const Divider(height: 16),
          _buildInfoRow(
            label: isArabic ? 'الكعبة المشرفة' : 'Holy Kaaba',
            value: isArabic ? 'مكة المكرمة (21.42° N, 39.82° E)' : 'Makkah (21.42° N, 39.82° E)',
          ),
          const Divider(height: 16),
          _buildInfoRow(
            label: isArabic ? 'زاوية انحراف القبلة' : 'Qibla Bearing',
            value: '${_qiblaBearing.round()}° جنوب شرق (SE)',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
        ),
        Text(
          value,
          style: AppTextStyles.labelSm.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}
