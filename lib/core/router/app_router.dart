import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/detail/presentation/detail_screen.dart';
import '../../features/discover/presentation/discover_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/watchlist/presentation/watchlist_screen.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/main_shell.dart';
import '../models/media_item.dart';
import 'routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const DiscoverScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.search,
              builder: (context, state) => const SearchScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.watchlist,
              builder: (context, state) => const WatchlistScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: AppRoutes.detailsPattern,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          final type = MediaType.fromString(state.pathParameters['type']);
          if (id == null) {
            return const Scaffold(
              body: EmptyState(
                icon: Icons.error_outline_rounded,
                title: 'Title not found',
                message: 'This link is not valid.',
              ),
            );
          }
          return DetailScreen(mediaType: type, id: id);
        },
      ),
    ],
  );
});
