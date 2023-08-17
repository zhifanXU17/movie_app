import 'package:movie_app/model/basic_info_movie.dart';
import 'package:movie_app/model/genre.dart';

class DetailedInfoMovie extends BasicInfoMovie {
  const DetailedInfoMovie({
    required super.id,
    required super.title,
    required super.releaseDate,
    required super.posterPath,
    required super.voteAverage,
    required this.videoDuration,
    required this.overview,
    required this.tagline,
    required this.spokenLanguages,
    required this.boxOffice,
    required this.genres,
  });

  final String videoDuration;
  final String overview;
  final String tagline;
  final String spokenLanguages;
  final int? boxOffice;
  final List<Genre> genres;
}
