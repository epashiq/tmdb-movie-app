class MovieModel {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String originalLanguage;
  final List<int> genreIds;
  final double popularity;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final bool adult;
  final bool video;
  final String mediaType;

  MovieModel({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.originalLanguage,
    required this.genreIds,
    required this.popularity,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.adult,
    required this.video,
    required this.mediaType,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      originalLanguage: json['original_language'] ?? '',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      popularity: (json['popularity'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      adult: json['adult'] ?? false,
      video: json['video'] ?? false,
      mediaType: json['media_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'original_language': originalLanguage,
      'genre_ids': genreIds,
      'popularity': popularity,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'adult': adult,
      'video': video,
      'media_type': mediaType,
    };
  }
}
