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
        log('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log('Error fetching trending movies: $e');
      return [];
    }
  }
}

