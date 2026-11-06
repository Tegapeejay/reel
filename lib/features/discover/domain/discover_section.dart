import '../../../core/models/media_item.dart';

/// A horizontal row on the Discover screen and the TMDB endpoint behind it.
/// Movies mode uses the endpoints from the Phase 1 spec; TV mode uses the
/// closest TV equivalents.
enum DiscoverSection {
  trending(
    movieTitle: 'Trending Today',
    tvTitle: 'Trending Today',
    moviePath: '/trending/all/day',
    tvPath: '/trending/tv/day',
  ),
  popular(
    movieTitle: 'Popular Movies',
    tvTitle: 'Popular TV Shows',
    moviePath: '/movie/popular',
    tvPath: '/tv/popular',
  ),
  topRated(
    movieTitle: 'Top Rated Movies',
    tvTitle: 'Top Rated TV Shows',
    moviePath: '/movie/top_rated',
    tvPath: '/tv/top_rated',
  ),
  nowPlaying(
    movieTitle: 'Now Playing',
    tvTitle: 'On The Air',
    moviePath: '/movie/now_playing',
    tvPath: '/tv/on_the_air',
  ),
  upcoming(
    movieTitle: 'Upcoming Movies',
    tvTitle: 'Airing Today',
    moviePath: '/movie/upcoming',
    tvPath: '/tv/airing_today',
  );

  const DiscoverSection({
    required this.movieTitle,
    required this.tvTitle,
    required this.moviePath,
    required this.tvPath,
  });

  final String movieTitle;
  final String tvTitle;
  final String moviePath;
  final String tvPath;

  String titleFor(MediaType mode) => mode == MediaType.tv ? tvTitle : movieTitle;
  String pathFor(MediaType mode) => mode == MediaType.tv ? tvPath : moviePath;
}
