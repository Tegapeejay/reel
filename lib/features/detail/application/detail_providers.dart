import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/tmdb_api_service.dart';
import '../../../core/models/media_item.dart';
import '../data/detail_repository.dart';
import '../domain/media_detail.dart';

final detailRepositoryProvider = Provider<DetailRepository>(
  (ref) => DetailRepository(ref.watch(tmdbApiProvider)),
);

final mediaDetailProvider =
    FutureProvider.autoDispose.family<MediaDetail, (MediaType, int)>(
  (ref, args) =>
      ref.watch(detailRepositoryProvider).fetchDetail(args.$1, args.$2),
);
