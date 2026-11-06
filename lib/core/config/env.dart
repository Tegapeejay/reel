import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Reads values from the local `.env` file (see `.env.example`).
abstract final class Env {
  static const String _placeholder = 'your_tmdb_read_access_token_here';

  static String get tmdbAccessToken {
    if (!dotenv.isInitialized) return '';
    return dotenv.maybeGet('TMDB_ACCESS_TOKEN')?.trim() ?? '';
  }

  static bool get hasToken {
    final token = tmdbAccessToken;
    return token.isNotEmpty && token != _placeholder;
  }
}
