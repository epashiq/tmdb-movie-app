import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:tmdb_movie_app/model/movie_model.dart';

class MovieService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = '44646802f6a4e937abffdb53712e04b5';

  Future<List<MovieModel>> fetchTrendingMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/trending/movie/day',
        queryParameters: {
          'language': 'en-US',
          'page': page,
          'api_key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        List results = response.data['results'];
        return results.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        log('Error fetching trending movies: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log('Error fetching trending movies: $e');
      throw Exception('Failed to fetch trending movies: $e');
    }
  }

  Future<List<MovieModel>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/search/movie',
        queryParameters: {
          'query': query,
          'language': 'en-US',
          'page': page,
          'include_adult': false,
          'api_key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        List results = response.data['results'];
        return results.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        log('Error searching movies: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log('Error searching movies: $e');
      throw Exception('Failed to search movies: $e');
    }
  }

  Future<List<MovieModel>> fetchUpcomingMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/movie/upcoming',
        queryParameters: {
          'language': 'en-US',
          'page': page,
          'api_key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        List results = response.data['results'];
        return results.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        log('Error fetching upcoming movies: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log('Error fetching upcoming movies: $e');
      throw Exception('Failed to fetch upcoming movies: $e');
    }
  }

  Future<MovieModel?> fetchMovieDetails(int movieId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/movie/$movieId',
        queryParameters: {
          'language': 'en-US',
          'api_key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        return MovieModel.fromJson(response.data);
      } else {
        log('Error fetching movie details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error fetching movie details: $e');
      throw Exception('Failed to fetch movie details: $e');
    }
  }
}
