import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/tmdb_image.dart';

class TrailerSection extends StatelessWidget {
  const TrailerSection({super.key, required this.trailerKey});

  final String? trailerKey;

  Future<void> _open(BuildContext context) async {
    final uri = Uri.parse('https://www.youtube.com/watch?v=$trailerKey');
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication)
        .catchError((_) => false);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
            const SnackBar(content: Text('Could not open the trailer.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trailer', style: textTheme.titleLarge),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: trailerKey == null
              ? Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.videocam_off_outlined,
                          color: AppColors.textSecondary, size: 32),
                      const SizedBox(height: 8),
                      Text('No trailer available',
                          style: textTheme.bodyMedium),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () => _open(context),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      TmdbImage(
                        url:
                            'https://img.youtube.com/vi/$trailerKey/hqdefault.jpg',
                        radius: AppSpacing.radiusLg,
                      ),
                      Center(
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.brandGradient,
                          ),
                          child: const Icon(Icons.play_arrow_rounded,
                              size: 38, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
