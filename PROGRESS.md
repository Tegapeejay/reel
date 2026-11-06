# Reel — Development Progress (Phase 1)

## 1. Project Overview

I have completed the initial development phase of **Reel**, a movie and TV discovery application built with Flutter and powered by the TMDB API.

The main focus of this phase was to establish the app's foundation, set up the project architecture, implement the core screens, connect the TMDB API, and build the major features required for browsing and discovering movies and TV shows.

The application currently has five main screens: Home/Discover, Search, Watchlist, Profile, and Media Details.

## 2. Development and Verification Status

The initial source code and project structure have been created. However, the development environment used for writing the code did not have the Flutter SDK or internet access available.

Because of this, I have not yet been able to run the application or verify everything through actual execution.

| Check | Current Status |
|---|---|
| `flutter pub get` | Not yet tested |
| `flutter analyze` | Not yet tested |
| `flutter test` | Tests written, not yet executed |
| App launch on emulator/device | Pending |
| Live TMDB API integration test | Pending |

**Note:** The features listed below have been implemented at the source-code level but still require compilation, testing, and verification before they can be considered fully validated.

## 3. What I Have Implemented

### Project Setup and Architecture
- Set up a feature-based Flutter project structure to keep the code organised and easier to maintain.
- Integrated Dio for API requests.
- Set up Riverpod for state management.
- Integrated GoRouter for application navigation.
- Added CachedNetworkImage for loading movie and TV posters.
- Configured Google Fonts and the application's reusable design system.

### User Interface and Design
- Created a dark-themed interface with Reel branding and Manrope typography.
- Added reusable components for movie posters, buttons, section headings, loading skeletons, error messages, and empty states.
- Designed a consistent navigation experience across the application.

### Home / Discover Screen
- Added the Reel logo and featured content section.
- Implemented a Movies and TV Shows toggle.
- Added a featured movie section displaying its backdrop, title, overview, rating, release year, and action buttons.
- Added five horizontally scrollable content sections.
- Implemented pull-to-refresh functionality.
- Added individual loading, error, and retry states for content sections.

### TMDB API Integration
- Set up the TMDB API connection using Dio and Bearer-token authentication.
- Created API services, repositories, and data models for movies and TV shows.
- Added API error handling and image URL generation.
- Configured environment variables using `.env` and `.env.example` files.

### Search Functionality
- Implemented movie, TV show, and person search.
- Added a search input with a 500ms debounce to reduce unnecessary API requests.
- Added recent searches with duplicate prevention.
- Included trending and popular suggestions.
- Search results are clearly identified as Movies, TV Shows, or People.

### Movie and TV Details
- Created a reusable details screen for movies and TV shows.
- Added movie backdrops, posters, titles, ratings, release dates, runtime, genres, and descriptions.
- Integrated watchlist functionality.
- Added trailer previews using YouTube thumbnails, with an option to open trailers externally.
- Included a fallback message when a trailer is unavailable.

### Watchlist
- Implemented the ability to add, remove, and toggle movies and TV shows in the watchlist.
- Added duplicate prevention.
- Created a watchlist grid with an empty-state screen.
- Connected the watchlist count to the bottom navigation badge.
- Structured the storage logic behind a `WatchlistRepository` to make future database integration easier.

### Profile and Navigation
- Added the Profile screen with a basic settings list.
- Implemented bottom navigation for Home, Search, Watchlist, and Profile.
- Configured GoRouter to manage navigation between screens.
- Added a separate details route that opens above the main navigation.

## 4. TMDB API Endpoints Connected in the Source Code

The following endpoints have been integrated:

**Movie endpoints**
- `/trending/all/day`
- `/movie/popular`
- `/movie/top_rated`
- `/movie/now_playing`
- `/movie/upcoming`
- `/movie/{id}`

**TV endpoints**
- `/trending/tv/day`
- `/tv/popular`
- `/tv/top_rated`
- `/tv/on_the_air`
- `/tv/airing_today`
- `/tv/{id}`

**Search and additional data**
- `/search/multi`
- `append_to_response=videos` for movie and TV details.

The TV section uses the corresponding TV endpoints rather than relying entirely on movie data.

## 5. Screens Completed

The following screens have been created:

1. **Home / Discover:** Browse trending, popular, top-rated, and upcoming content.
2. **Search:** Search for movies, TV shows, and people.
3. **Watchlist:** View and manage saved movies and TV shows.
4. **Profile:** Access basic application settings.
5. **Details:** View additional information about selected movies and TV shows.

## 6. Tests Prepared

I have also written initial tests to cover some of the application's core functionality.

- `media_item_test.dart` — Tests movie and TV data parsing, image URLs, formatting, genres, runtime, and trailer selection.
- `watchlist_test.dart` — Tests adding and removing items, duplicate prevention, toggling, and ordering.
- `search_debounce_test.dart` — Tests search delays, clearing searches, and recent-search management.
- `widget_test.dart` — Tests PosterCard rendering, watchlist interactions, and EmptyState.

These tests are currently written but have not yet been executed. They do not require live network access.

## 7. Current Limitations

There are still a few areas I plan to improve in the next development phase:

- Watchlist data and recent searches are currently stored in memory and do not persist after restarting the application.
- Person search results are recognised, but a dedicated person details screen has not been implemented.
- Most Profile settings are currently static.
- Upcoming movies without ratings do not display a rating badge.
- Pagination and dedicated See All screens are not yet available.
- Tablet-specific layouts, localisation, and a full accessibility review are still pending.
- Repository and screen-level test coverage needs to be expanded.

## 8. Next Development Phase — Phase 2

My next focus will be improving the application's functionality, data persistence, and overall user experience.

The planned tasks are:

1. **SQLite Integration:** Implement local database storage for the watchlist and ensure saved items remain available after restarting the app.
2. **Search History:** Persist recent searches instead of keeping them only in memory.
3. **Enhanced Details:** Add cast information, similar movies and shows, streaming providers, and TV seasons.
4. **Pagination:** Introduce pagination and dedicated See All pages for the different content sections.
5. **Person Details:** Build a dedicated screen for actors, directors, and other people returned by the search API.
6. **Testing:** Expand test coverage for repositories, API responses, and application screens.
7. **Final Verification:** Run the application, resolve any compilation or analysis issues, and test the main features on an emulator or physical device.

## 9. Overall Progress

Phase 1 has established the core structure and major functionality of Reel. The application now has its main navigation, discovery interface, search functionality, movie and TV details, and watchlist features implemented in the source code.

My immediate priority is to run the project in a proper Flutter development environment, resolve any issues identified during testing, and then proceed with SQLite integration and the additional features planned for Phase 2.

**Project status:** Phase 1 source-code implementation completed. Runtime verification and Phase 2 development are pending.