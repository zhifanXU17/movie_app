import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:movie_app/model/genre.dart';

const storage = FlutterSecureStorage();

class HotGenres extends StatefulWidget {
  const HotGenres({super.key});

  @override
  State<HotGenres> createState() => _HotGenresState();
}

class _HotGenresState extends State<HotGenres> {
  List<Genre> _genres = [];
  String? _error;
  bool _loading = true;

  void _loadGenres() async {
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

      setState(() {
        _genres = [...loadedItems];
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
    _loadGenres();
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;

    return _loading
        ? const CircularProgressIndicator()
        : _error != null
            ? Center(
                child: Text(_error!),
              )
            : SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: _genres
                      .sublist(0, 4)
                      .map(
                        (genre) => ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(mediaWidth * 0.35, 55),
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
              );
  }
}
