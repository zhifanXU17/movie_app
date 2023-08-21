import 'package:movie_app/model/actor.dart';

class Credit extends Actor {
  const Credit({
    required super.id,
    required super.gender,
    required super.name,
    required super.profilePath,
    required this.character,
  });

  final String character;
}
