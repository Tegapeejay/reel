import '../../../core/models/media_item.dart';

/// Full detail for one movie or TV show (from /movie/{id} or /tv/{id}).
class MediaDetail {
  const MediaDetail({
    required this.id,
    required this.mediaType,
    required this.title,
    required this.overview,
    this.tagline,
    this.posterPath,
    this.backdropPath,
    this.voteAverage = 0,
    this.releaseDate,
    this.genres = const [],
    this.runtime,
    this.trailerKey,
  });

  factory MediaDetail.fromJson(Map<String, dynamic> json, MediaType type) {
    final date = (json['release_date'] ?? json['first_air_date']) as String?;
    final tv = json['episode_run_time'];
    final tvRuntime = (tv is List && tv.isNotEmpty && tv.first is num)
        ? (tv.first as num).toInt()
        : null;
    final tagline = json['tagline'] as String?;
    return MediaDetail(
      id: (json['id'] as num).toInt(),
      mediaType: type,
      title: (json['title'] ?? json['name'] ?? 'Untitled') as String,
      overview: (json['overview'] as String?) ?? '',
      tagline: (tagline == null || tagline.isEmpty) ? null : tagline,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      releaseDate: (date == null || date.isEmpty) ? null : date,
      genres: (json['genres'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map((g) => g['name'] as String)
          .toList(),
      runtime: (json['runtime'] as num?)?.toInt() ?? tvRuntime,
      trailerKey: _pickTrailer(json['videos']),
    );
  }

  /// Prefers an official YouTube "Trailer", then any YouTube "Teaser".
  static String? _pickTrailer(Object? videos) {
    if (videos is! Map) return null;
    final results = videos['results'];
    if (results is! List) return null;
    final youtube = results
        .whereType<Map<String, dynamic>>()
        .where((v) => v['site'] == 'YouTube' && v['key'] is String)
        .toList();
    for (final kind in const ['Trailer', 'Teaser']) {
      for (final v in youtube) {
        if (v['type'] == kind) return v['key'] as String;
      }
    }
    return null;
  }

  final int id;
  final MediaType mediaType;
  final String title;
  final String overview;
  final String? tagline;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String? releaseDate;
  final List<String> genres;
  final int? runtime;
  final String? trailerKey;

  /// Lightweight form used by the watchlist and poster cards.
  MediaItem toMediaItem() => MediaItem(
        id: id,
        mediaType: mediaType,
        title: title,
        overview: overview,
        posterPath: posterPath,
        backdropPath: backdropPath,
        voteAverage: voteAverage,
        releaseDate: releaseDate,
      );
}
