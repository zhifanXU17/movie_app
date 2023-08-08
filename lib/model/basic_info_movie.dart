class BasicInfoMovie {
  const BasicInfoMovie({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.posterPath,
    required this.voteAverage,
  });

  final int id;
  final String title;
  final String releaseDate;
  final String? posterPath;
  final double? voteAverage;
}
