// lib/core/routing/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/shell/main_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/nearby/nearby_screen.dart';
import '../../features/mosque_detail/mosque_detail_screen.dart';
import '../../features/qibla/qibla_screen.dart';
import '../../features/community/community_screen.dart';
import '../../features/settings/settings_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, __) => const HomeScreen(),
        ),
        GoRoute(
          path: '/nearby',
          builder: (_, __) => const NearbyScreen(),
          routes: [
            GoRoute(
              path: 'mosque/:id',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (_, state) {
                final id = state.pathParameters['id'] ?? '';
                return MosqueDetailScreen(mosqueId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/qibla',
          builder: (_, __) => const QiblaScreen(),
        ),
        GoRoute(
          path: '/community',
          builder: (_, __) => const CommunityScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (_, __) => const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/mosque/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) {
        final id = state.pathParameters['id'] ?? '';
        return MosqueDetailScreen(mosqueId: id);
      },
    ),
  ],
);
