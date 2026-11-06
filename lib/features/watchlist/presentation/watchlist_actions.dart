import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/media_item.dart';
import '../application/watchlist_providers.dart';

/// Toggles an item in the watchlist and confirms with a snackbar.
void toggleWatchlist(BuildContext context, WidgetRef ref, MediaItem item) {
  final added = ref.read(watchlistProvider.notifier).toggle(item);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(added
            ? 'Added "${item.title}" to your watchlist'
            : 'Removed "${item.title}" from your watchlist'),
      ),
    );
}
