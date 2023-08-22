import 'package:movie_app/model/actor.dart';
import 'package:movie_app/model/basic_info_movie.dart';

class DetailedActor extends Actor {
  const DetailedActor({
    required this.personIntroduction,
    required this.masterpieces,
    required this.birthday,
    required this.placeOfBirth,
    required super.id,
    required super.gender,
    required super.name,
    required super.profilePath,
  });

  final String personIntroduction;
  final List<BasicInfoMovie> masterpieces;
  final DateTime birthday;
  final String placeOfBirth;
}
