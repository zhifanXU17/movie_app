import 'package:flutter/material.dart';

import 'package:movie_app/widgets/home/trending_movies.dart';
import 'package:movie_app/widgets/home/upcoming_movies.dart';
import 'package:movie_app/widgets/home/genres.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          TrendingMovies(),
          SizedBox(height: 8),
          UpcomingMovies(),
          SizedBox(height: 8),
          Genres(),
        ],
      ),
    );
  }
}
