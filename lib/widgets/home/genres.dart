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
    return FutureBuilder<List<Genre>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error;
            return Center(child: Text('😢 $error'));
          } else if {}
          else {
            return  const Center(child: CircularProgressIndicator());
          }
        });
  }
}
