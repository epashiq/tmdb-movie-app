import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:tmdb_movie_app/controller/services/movie_services.dart';
import 'package:tmdb_movie_app/model/movie_model.dart';

class MovieProvider with ChangeNotifier {
  List<MovieModel> movies = [];

  bool isLoading = false;

  MovieService movieService = MovieService();

  Future<void> fetchTrendingMovies({int page = 10}) async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await movieService.fetchTrendingMovies(page: page);
      movies.addAll(result);
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
