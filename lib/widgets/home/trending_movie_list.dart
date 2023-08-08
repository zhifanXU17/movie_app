import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:movie_app/model/basic_info_movie.dart';
import 'package:movie_app/widgets/home/movie_list_item.dart';

const storage = FlutterSecureStorage();

final DateFormat formatter = DateFormat('yyyy-MM-dd');

class TrendingMovieList extends StatefulWidget {
  const TrendingMovieList({super.key});

  @override
  State<TrendingMovieList> createState() => _TrendingMovieListState();
}

class _TrendingMovieListState extends State<TrendingMovieList> {
  List<BasicInfoMovie> _trendingMovies = [];
  bool _loading = true;
  String? _error;

  void _loadedItems() async {
    final nowTime = DateTime.now();
    final lastMonth = nowTime.subtract(const Duration(days: 30));

    final params = {
      'language': 'zh-CN',
      'region': 'CN',
      'release_date.gte': formatter.format(lastMonth),
      'release_date.lte': formatter.format(nowTime),
      'with_release_type': 3,
    };

    final uri = Uri.https(
      'api.themoviedb.org',
      '/3/discover/movie',
      params.map((key, value) => MapEntry(key, value.toString())),
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

      final List listData = json.decode(response.body)['results'];
      final List<BasicInfoMovie> loadedItems = [];
      for (final item in listData.sublist(0, 5)) {
        loadedItems.add(
          BasicInfoMovie(
            id: item["id"],
            title: item["title"],
            releaseDate: formatter.format(DateTime.parse(item["release_date"])),
            posterPath: item["poster_path"],
            voteAverage: item["vote_average"],
          ),
        );
      }

      setState(() {
        _trendingMovies = [...loadedItems];
        _loading = false;
      });
    } on Exception catch (error) {
      setState(() {
        _loading = false;
        _error = "$error";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadedItems();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
            ? Center(
                child: Text(_error!),
              )
            : SizedBox(
                width: double.infinity,
                height: 320,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _trendingMovies.length,
                  itemBuilder: (context, index) => MovieListItem(
                    trendingMovie: _trendingMovies[index],
                  ),
                ),
              );
  }
}
