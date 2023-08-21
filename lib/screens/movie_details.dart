import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:movie_app/model/detailed_info_movie.dart';
import 'package:movie_app/model/genre.dart';
import 'package:movie_app/widgets/MovieDetails/info_table.dart';
import 'package:movie_app/widgets/MovieDetails/credits_list.dart';

const storage = FlutterSecureStorage();
final DateFormat formatter = DateFormat('yyyy-MM-dd');

String handleSpokenLanguages(List arr) {
  var result = "";

  for (var i = 0; i < arr.length; i++) {
    if (i == arr.length - 1) {
      result += '${arr[i]["name"]}';
    } else {
      result += '${arr[i]["name"]},';
    }
  }

  return result;
}

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({
    super.key,
    required this.movieId,
  });

  final int movieId;

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  DetailedInfoMovie? _currentMovieInfo;
  String? _error;
  bool _loading = true;

  void _loadInfo() async {
    final uri = Uri.https(
      'api.themoviedb.org',
      '/3/movie/${widget.movieId}',
      {
        'language': 'zh-CN',
      },
    );
    String? token = await storage.read(key: "token");

    try {
      final response = await http.get(
        uri,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final List<Genre> genreList = [];

      final Map<String, dynamic> result = json.decode(response.body);
      for (final item in result["genres"]) {
        genreList.add(
          Genre(
            id: item["id"],
            name: item["name"],
          ),
        );
      }
      _currentMovieInfo = DetailedInfoMovie(
        id: result["id"],
        title: result["title"],
        releaseDate: formatter.format(DateTime.parse(result["release_date"])),
        posterPath: result["poster_path"],
        voteAverage: result["vote_average"],
        overview: result["overview"],
        tagline: result["tagline"],
        boxOffice: result["revenue"],
        videoDuration: '${result["runtime"]}分钟',
        spokenLanguages: handleSpokenLanguages(result["spoken_languages"]),
        genres: genreList,
      );

      setState(() {
        _loading = false;
      });
    } on Exception catch (error) {
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Text(_error!),
                )
              : SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: _currentMovieInfo!.posterPath == null
                              ? SvgPicture.asset(
                                  'assets/images/no_picture.svg',
                                  width: mediaWidth * 0.8,
                                  height: mediaHeight * 0.5,
                                )
                              : Image.network(
                                  'https://image.tmdb.org/t/p/w500/${_currentMovieInfo!.posterPath}',
                                  width: mediaWidth * 0.6,
                                  height: mediaHeight * 0.4,
                                  fit: BoxFit.fill,
                                ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          _currentMovieInfo!.title,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        if (_currentMovieInfo!.tagline != "")
                          // const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              _currentMovieInfo!.tagline,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color:
                                        const Color.fromRGBO(104, 131, 146, 1),
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (_currentMovieInfo!.voteAverage != null)
                          Text(
                            _currentMovieInfo!.voteAverage!.toStringAsFixed(1),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: const Color.fromRGBO(104, 131, 146, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        const SizedBox(
                          height: 8,
                        ),
                        InfoTable(
                          videoDuration: _currentMovieInfo!.videoDuration,
                          spokenLanguages: _currentMovieInfo!.spokenLanguages,
                          releaseDate: _currentMovieInfo!.releaseDate,
                          boxOffice: _currentMovieInfo!.boxOffice,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "故事梗概",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "\t\t\t\t\t\t\t\t${_currentMovieInfo!.overview}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      height: 1.5,
                                      color: const Color.fromRGBO(
                                          104, 131, 146, 1),
                                      fontWeight: FontWeight.w600,
                                    ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 24.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "演职员表",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                CreditsList(movieId: widget.movieId),
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}
