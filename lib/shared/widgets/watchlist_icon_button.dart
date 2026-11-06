import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/media_item.dart';
import '../../core/theme/app_colors.dart';
import '../../features/watchlist/application/watchlist_providers.dart';
import '../../features/watchlist/presentation/watchlist_actions.dart';

class WatchlistIconButton extends ConsumerWidget {
  const WatchlistIconButton({super.key, required this.item});

  final MediaItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(isWatchlistedProvider(item.key));
    return IconButton(
      iconSize: 20,
      visualDensity: VisualDensity.compact,
      tooltip: saved ? 'Remove from watchlist' : 'Add to watchlist',
      style: IconButton.styleFrom(backgroundColor: Colors.black.withAlpha(140)),
      onPressed: () => toggleWatchlist(context, ref, item),
      icon: Icon(
        saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
        color: saved ? AppColors.primary : Colors.white,
      ),
    );
  }
}
