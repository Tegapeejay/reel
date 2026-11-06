enum MediaType {
  movie,
  tv,
  person;

  static MediaType fromString(String? value) => switch (value) {
        'tv' => MediaType.tv,
        'person' => MediaType.person,
        _ => MediaType.movie,
      };

  String get label => switch (this) {
        MediaType.movie => 'Movie',
        MediaType.tv => 'TV Show',
        MediaType.person => 'Person',
      };
}

/// A movie, TV show or person returned by TMDB list / search endpoints.
class MediaItem {
  const MediaItem({
    required this.id,
    required this.mediaType,
    required this.title,
    this.overview = '',
    this.posterPath,
    this.backdropPath,
    this.profilePath,
    this.voteAverage = 0,
    this.releaseDate,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json, {MediaType? fallbackType}) {
    final rawType = json['media_type'] as String?;
    final type = rawType != null
        ? MediaType.fromString(rawType)
        : (fallbackType ?? MediaType.movie);
    final date = (json['release_date'] ?? json['first_air_date']) as String?;
    return MediaItem(
      id: (json['id'] as num).toInt(),
      mediaType: type,
      title: (json['title'] ?? json['name'] ?? 'Untitled') as String,
      overview: (json['overview'] as String?) ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      profilePath: json['profile_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0,
      releaseDate: (date == null || date.isEmpty) ? null : date,
    );
  }

  /// Parses the `results` array of a TMDB list response.
  static List<MediaItem> listFromResponse(
    Map<String, dynamic> json, {
    MediaType? fallbackType,
    bool includePeople = true,
  }) {
    final results = json['results'];
    if (results is! List) return const [];
    return results
        .whereType<Map<String, dynamic>>()
        .map((e) => MediaItem.fromJson(e, fallbackType: fallbackType))
        .where((i) => includePeople || i.mediaType != MediaType.person)
        .toList();
  }

  final int id;
  final MediaType mediaType;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String? profilePath;
  final double voteAverage;
  final String? releaseDate;

  /// Unique across movies / TV / people (TMDB ids overlap between types).
  String get key => '${mediaType.name}-$id';

  String? get year {
    final d = releaseDate;
    return (d != null && d.length >= 4) ? d.substring(0, 4) : null;
  }

  /// Poster for movies/TV, profile photo for people.
  String? get imagePath =>
      mediaType == MediaType.person ? profilePath : posterPath;

  @override
  bool operator ==(Object other) => other is MediaItem && other.key == key;

  @override
  int get hashCode => key.hashCode;
}
