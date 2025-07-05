import 'dart:async';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:tmdb_movie_app/controller/services/movie_services.dart';
import 'package:tmdb_movie_app/model/movie_model.dart';

class MovieProvider with ChangeNotifier {
  // Movie Lists
  List<MovieModel> movies = [];
  List<MovieModel> searchResults = [];
  List<MovieModel> upcomingMovies = [];

  // Loading States
  bool isLoading = false;
  bool isLoadingMore = false;
  bool isSearching = false;
  bool isSearchingMore = false;

  // Pagination
  bool hasMore = true;
  bool hasMoreSearch = true;
  int currentPage = 1;
  int currentSearchPage = 1;

  // Search
  String searchQuery = '';
  bool isSearchMode = false;

  Timer? _searchTimer;

  // Error Handling
  String? errorMessage;
  String? searchErrorMessage;

  MovieService movieService = MovieService();

  // TRENDING MOVIES FUNCTIONALITY
  Future<void> fetchTrendingMovies({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      movies.clear();
      hasMore = true;
      errorMessage = null;
    }

    if (isLoading || isLoadingMore || !hasMore) return;

    if (currentPage == 1) {
      isLoading = true;
    } else {
      isLoadingMore = true;
    }
    notifyListeners();

    try {
      final result = await movieService.fetchTrendingMovies(page: currentPage);

      if (result.isEmpty) {
        hasMore = false;
      } else {
        movies.addAll(result);
        currentPage++;
      }
      errorMessage = null;
    } catch (e) {
      log('Error fetching trending movies: $e');
      errorMessage = 'Failed to load movies. Please try again.';
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  // SEARCH FUNCTIONALITY
  Future<void> searchMovies(String query, {bool isRefresh = false}) async {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    if (isRefresh) {
      currentSearchPage = 1;
      searchResults.clear();
      hasMoreSearch = true;
      searchErrorMessage = null;
    }

    if (isSearching || isSearchingMore || !hasMoreSearch) return;

    searchQuery = query.trim();
    isSearchMode = true;

    if (currentSearchPage == 1) {
      isSearching = true;
    } else {
      isSearchingMore = true;
    }
    notifyListeners();

    try {
      final result = await movieService.searchMovies(
        query: searchQuery,
        page: currentSearchPage,
      );

      if (result.isEmpty) {
        hasMoreSearch = false;
      } else {
        searchResults.addAll(result);
        currentSearchPage++;
      }
      searchErrorMessage = null;
    } catch (e) {
      log('Error searching movies: $e');
      searchErrorMessage = 'Failed to search movies. Please try again.';
    } finally {
      isSearching = false;
      isSearchingMore = false;
      notifyListeners();
    }
  }

  // DEBOUNCED SEARCH
  void onSearchChanged(String query) {
    _searchTimer?.cancel();

    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    _searchTimer = Timer(const Duration(milliseconds: 500), () {
      searchMovies(query, isRefresh: true);
    });
  }

  // LOAD MORE SEARCH RESULTS
  Future<void> loadMoreSearchResults() async {
    if (searchQuery.isNotEmpty && hasMoreSearch) {
      await searchMovies(searchQuery);
    }
  }

  // CLEAR SEARCH
  void clearSearch() {
    _searchTimer?.cancel();
    isSearchMode = false;
    searchQuery = '';
    searchResults.clear();
    currentSearchPage = 1;
    hasMoreSearch = true;
    searchErrorMessage = null;
    notifyListeners();
  }

  // GETTERS
  List<MovieModel> get currentMovies => isSearchMode ? searchResults : movies;

  bool get isCurrentlyLoading => isSearchMode ? isSearching : isLoading;

  bool get isCurrentlyLoadingMore =>
      isSearchMode ? isSearchingMore : isLoadingMore;

  bool get hasMoreContent => isSearchMode ? hasMoreSearch : hasMore;

  String? get currentErrorMessage =>
      isSearchMode ? searchErrorMessage : errorMessage;

  // UTILITY METHODS
  void resetProvider() {
    movies.clear();
    searchResults.clear();
    currentPage = 1;
    currentSearchPage = 1;
    hasMore = true;
    hasMoreSearch = true;
    errorMessage = null;
    searchErrorMessage = null;
    isSearchMode = false;
    searchQuery = '';
    _searchTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }
}
