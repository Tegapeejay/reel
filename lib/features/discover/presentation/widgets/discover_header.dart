import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import 'media_type_toggle.dart';

class DiscoverHeader extends StatelessWidget {
  const DiscoverHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding, 12, AppSpacing.pagePadding, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.brandGradient.createShader(bounds),
                  child: Text(
                    'REEL',
                    style: textTheme.titleLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 6,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Search',
                  onPressed: () => context.go(AppRoutes.search),
                  style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface),
                  icon: const Icon(Icons.search_rounded),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Find your next obsession.', style: textTheme.headlineLarge),
            const SizedBox(height: 16),
            const MediaTypeToggle(),
          ],
        ),
      ),
    );
  }
}
