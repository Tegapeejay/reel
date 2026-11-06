# Reel — Movie & TV Discovery App

Reel is a Flutter application I built to make it easier to discover movies and TV shows. It uses the TMDB API to display trending titles, popular movies, TV shows, and detailed information about different titles.

The first phase of the project focuses on the main app structure, UI design, API integration, search functionality, movie details, navigation, and watchlist management.

The goal is to build a simple and smooth experience where users can explore movies and shows, find information about them, and save titles they want to watch later.

> This product uses the TMDB API but is not endorsed or certified by TMDB.

## Tech Stack

- Flutter & Dart
- Dio — API requests
- Riverpod — State management
- GoRouter — Navigation
- CachedNetworkImage — Movie and TV images
- Google Fonts (Manrope) — Typography
- flutter_dotenv — Environment configuration
- url_launcher — Opening external links and trailers

## Getting Started

To run the project locally, you'll need Flutter installed and a TMDB API access token.

### 1. Set up Flutter

Install the stable version of Flutter and make sure Dart 3.4 or later is available.

Run:

```bash
flutter doctor
```

Resolve any issues reported before continuing.

### 2. Get your TMDB API token

1. Create an account at [TMDB](https://www.themoviedb.org/).
2. Open your account settings.
3. Go to the API section.
4. Generate or copy your **API Read Access Token**.

Make sure you copy the long JWT token (`eyJ...`), not the shorter v3 API key.

### 3. Configure the environment

From the project root, create your `.env` file using the example provided:

```bash
cp .env.example .env
```

Open `.env` and add your token:

```env
TMDB_ACCESS_TOKEN=your_tmdb_access_token
```

The `.env` file is loaded when the app starts, so make sure it exists before running the project.

Also, add `.env` to your `.gitignore` to avoid accidentally pushing your API token to GitHub. You can use the entries in `.gitignore.reel-additions`.

### 4. Install dependencies and run

Run the following commands from the project directory:

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## Working with an Existing Flutter Project

If you're adding Reel to an existing Flutter project, copy the following files and folders:

- `lib/`
- `test/`
- `pubspec.yaml`
- `analysis_options.yaml`
- `.env.example`

The package name should be `reel` because the tests use `package:reel/...` imports.

For a completely new project, create the Flutter project first:

```bash
flutter create --project-name reel .
```

Then copy the Reel files into it.

## Platform Notes

A few things to check when running the application on different platforms:

**Android internet permission**

For Android release builds, make sure the following permission is included in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

**Opening YouTube trailers**

Reel uses `url_launcher` to open trailers externally. For Android 11 and later, add the following query to the Android manifest:

```xml
<queries>
    <intent>
        <action android:name="android.intent.action.VIEW"/>
        <data android:scheme="https"/>
    </intent>
</queries>
```

**Google Fonts**

Manrope is loaded using Google Fonts. An internet connection is required the first time the font is downloaded.

## Project Structure

I organised the project by features so that each part of the application has its own data, business logic, and presentation layers.

```text
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── api/
│   │   ├── Dio client
│   │   ├── TMDB service
│   │   └── ApiException
│   │
│   ├── config/
│   │   ├── Environment configuration
│   │   ├── API constants
│   │   └── Image URL builder
│   │
│   ├── models/
│   │   └── MediaItem (movie / TV / person)
│   │
│   ├── router/
│   │   └── GoRouter configuration
│   │
│   ├── theme/
│   │   ├── Colors
│   │   ├── Spacing
│   │   └── Typography
│   │
│   └── utils/
│       └── Date and runtime formatting
│
├── shared/
│   └── widgets/
│       ├── PosterCard
│       ├── Skeleton
│       ├── ErrorView
│       ├── EmptyState
│       └── AppButton
│
└── features/
    ├── discover/
    │   ├── data/
    │   ├── domain/
    │   ├── application/
    │   └── presentation/
    │
    ├── search/
    ├── detail/
    ├── watchlist/
    └── profile/

test/
```

## TMDB API Endpoints

These are the main TMDB endpoints used for fetching content.

| Endpoint | Purpose |
|---|---|
| `GET /trending/all/day` | Trending titles and featured content |
| `GET /movie/popular` | Popular movies |
| `GET /movie/top_rated` | Top-rated movies |
| `GET /movie/now_playing` | Movies currently showing |
| `GET /movie/upcoming` | Upcoming movie releases |
| `GET /search/multi?query=` | Search movies, TV shows, and people |
| `GET /movie/{id}` | Movie details |
| `GET /tv/{id}` | TV show details |
| `append_to_response=videos` | Fetch available trailers |

For the TV Shows section, the app also uses:

- `/trending/tv/day`
- `/tv/popular`
- `/tv/top_rated`
- `/tv/on_the_air`
- `/tv/airing_today`

## Current Features

The first development phase includes:

- Browse trending and popular movies.
- Switch between Movies and TV Shows.
- Search for movies, TV shows, and people.
- View detailed information about selected titles.
- Watch trailer previews through YouTube.
- Add and remove titles from a personal watchlist.
- Navigate between Home, Search, Watchlist, and Profile.

## What's Next?

There are still some features I want to improve as development continues.

My next phase will focus on:

- Adding SQLite to save watchlist items locally.
- Saving recent searches between app sessions.
- Adding cast and crew information.
- Showing similar movies and TV shows.
- Adding streaming provider information.
- Supporting TV seasons and episodes.
- Implementing pagination and See All pages.
- Improving test coverage and overall app performance.

For a more detailed breakdown of completed work, outstanding tasks, and testing status, see [PROGRESS.md](PROGRESS.md).

---

**Reel is still under development.** This is the first milestone, and I'm continuing to improve the app as I work through the remaining features.