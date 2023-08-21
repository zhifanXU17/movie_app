enum Gender {
  male,
  female,
}

class Actor {
  const Actor({
    required this.id,
    required this.gender,
    required this.name,
    required this.profilePath,
  });

  final int id;
  final Gender gender;
  final String name;
  final String? profilePath;
}
