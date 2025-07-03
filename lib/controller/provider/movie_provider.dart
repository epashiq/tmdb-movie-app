import 'package:flutter/widgets.dart';
import 'package:tmdb_movie_app/controller/services/movie_services.dart';
import 'package:tmdb_movie_app/model/movie_model.dart';

class MovieProvider with ChangeNotifier {
  List<MovieModel> movies = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  int currentPage = 1;
  String? errorMessage;

  MovieService movieService = MovieService();

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
      errorMessage = 'Failed to load movies. Please try again.';
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  void resetProvider() {
    movies.clear();
    currentPage = 1;
    hasMore = true;
    errorMessage = null;
    notifyListeners();
  }
}
