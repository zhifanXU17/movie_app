import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:movie_app/model/genre.dart';

const storage = FlutterSecureStorage();

class Genres extends StatefulWidget {
  const Genres({super.key});

  @override
  State<Genres> createState() => _GenresState();
}

class _GenresState extends State<Genres> {
  late Future<List<Genre>> _dataFuture;

  Future<List<Genre>> _loadGenres() async {
    final uri = Uri.https(
      'api.themoviedb.org',
      '/3/genre/movie/list',
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

      final List listData = json.decode(response.body)['genres'];
      final List<Genre> loadedItems = [];
      for (final item in listData) {
        loadedItems.add(
          Genre(
            id: item["id"],
            name: item["name"],
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
    _dataFuture = _loadGenres();
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<List<Genre>>(
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
                      "正在热映",
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
                  child: Wrap(
                    alignment: WrapAlignment.spaceAround,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16.0,
                    runSpacing: 16.0,
                    children: snapshot.data!
                        .sublist(0, 6)
                        .map(
                          (genre) => ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(mediaWidth * 0.25, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            child: Text(
                              genre.name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        )
                        .toList(),
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
