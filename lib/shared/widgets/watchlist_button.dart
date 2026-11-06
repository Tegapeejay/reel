import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/media_item.dart';
import '../../features/watchlist/application/watchlist_providers.dart';
import '../../features/watchlist/presentation/watchlist_actions.dart';
import 'app_button.dart';

class WatchlistButton extends ConsumerWidget {
  const WatchlistButton({super.key, required this.item, this.compact = false});

  final MediaItem item;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(isWatchlistedProvider(item.key));
    return AppButton(
      label: saved ? 'In Watchlist' : (compact ? 'Watchlist' : 'Add to Watchlist'),
      icon: saved ? Icons.check_rounded : Icons.add_rounded,
      variant: saved ? AppButtonVariant.tonal : AppButtonVariant.secondary,
      onPressed: () => toggleWatchlist(context, ref, item),
    );
  }
}
