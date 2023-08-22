import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:movie_app/model/basic_info_movie.dart';
import 'package:movie_app/widgets/home/movie_list_item.dart';

const storage = FlutterSecureStorage();
final DateFormat formatter = DateFormat('yyyy-MM-dd');

class UpcomingMovies extends StatefulWidget {
  const UpcomingMovies({super.key});

  @override
  State<UpcomingMovies> createState() => _UpcomingMoviesState();
}

class _UpcomingMoviesState extends State<UpcomingMovies> {
  late Future<List<BasicInfoMovie>> _dataFuture;

  Future<List<BasicInfoMovie>> _loadUpcomingMovies() async {
    final params = {
      'language': 'zh-CN',
      'region': 'CN',
    };

    final uri = Uri.https(
      'api.themoviedb.org',
      '/3/movie/upcoming',
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
            voteAverage: null,
          ),
        );
      }
      return loadedItems;
    } on Exception catch (error) {
      return Future.error(error);
    }
  }

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadUpcomingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BasicInfoMovie>?>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(child: Text('😢 $error'));
          } else if (snapshot.hasData) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "即将上映",
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: const Text('查看所有'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 320,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) => MovieListItem(
                      basicMovieInfo: snapshot.data![index],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
