import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:movie_app/model/basic_info_movie.dart';

class MovieListItem extends StatelessWidget {
  const MovieListItem({
    super.key,
    required this.trendingMovie,
  });

  final BasicInfoMovie trendingMovie;

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;

    return Container(
      width: mediaWidth * 0.5,
      margin: const EdgeInsets.only(right: 20),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: trendingMovie.posterPath == null
                ? SvgPicture.asset(
                    'assets/images/no_picture.svg',
                    width: mediaWidth * 0.5,
                    height: 250,
                  )
                : Image.network(
                    'https://image.tmdb.org/t/p/w500/${trendingMovie.posterPath}',
                    width: mediaWidth * 0.5,
                    height: 250,
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
                    if (trendingMovie.voteAverage != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Color.fromRGBO(255, 211, 1, 1),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            trendingMovie.voteAverage!.toStringAsFixed(1),
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
