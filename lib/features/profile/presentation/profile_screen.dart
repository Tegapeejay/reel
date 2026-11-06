import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../search/application/search_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final hasRecents = ref.watch(recentSearchesProvider).isNotEmpty;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          children: [
            Text('Profile', style: textTheme.headlineMedium),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.brandGradient,
                    ),
                    child: const Icon(Icons.person_rounded, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Guest', style: textTheme.titleMedium),
                        Text('Accounts are not part of this milestone',
                            style: textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('SETTINGS',
                style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w800, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            const _SettingsTile(
              icon: Icons.dark_mode_outlined,
              title: 'Appearance',
              subtitle: 'Dark (default)',
            ),
            _SettingsTile(
              icon: Icons.history_rounded,
              title: 'Clear recent searches',
              subtitle: hasRecents ? 'Remove saved search terms' : 'Nothing to clear',
              onTap: hasRecents
                  ? () {
                      ref.read(recentSearchesProvider.notifier).clear();
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(const SnackBar(
                            content: Text('Recent searches cleared')));
                    }
                  : null,
            ),
            const _SettingsTile(
              icon: Icons.language_rounded,
              title: 'Language',
              subtitle: 'English (more languages coming later)',
            ),
            const SizedBox(height: 24),
            Text('ABOUT',
                style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w800, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            const _SettingsTile(
              icon: Icons.info_outline_rounded,
              title: 'Reel',
              subtitle: 'Version 0.1.0 — Phase 1',
            ),
            const SizedBox(height: 16),
            Text(
              'This product uses the TMDB API but is not endorsed or certified by TMDB.',
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          leading: Icon(icon, color: AppColors.secondary),
          title: Text(title, style: textTheme.titleSmall),
          subtitle: Text(subtitle, style: textTheme.bodySmall),
          trailing: onTap == null
              ? null
              : const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
