import 'package:flutter/material.dart';

import 'package:movie_app/model/trending_movie.dart';

class TrendingMovieItem extends StatelessWidget {
  const TrendingMovieItem({
    super.key,
    required this.trendingMovie,
  });

  final TrendingMovie trendingMovie;

  @override
  Widget build(BuildContext context) {
    String imageUrl =
        'https://image.tmdb.org/t/p/w500/${trendingMovie.posterPath}';

    double mediaWidth = MediaQuery.of(context).size.width;

    return Container(
      width: mediaWidth * 0.55,
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.network(
              imageUrl,
              width: mediaWidth * 0.55,
              height: 280,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trendingMovie.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      trendingMovie.releaseDate,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Color.fromRGBO(255, 211, 1, 1),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          trendingMovie.voteAverage.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
