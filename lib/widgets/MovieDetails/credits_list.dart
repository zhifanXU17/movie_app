import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/model/actor.dart';
import 'package:movie_app/model/credit.dart';

const storage = FlutterSecureStorage();

class CreditsList extends StatefulWidget {
  const CreditsList({
    super.key,
    required this.movieId,
  });

  final int movieId;

  @override
  State<CreditsList> createState() => _CreditsListState();
}

class _CreditsListState extends State<CreditsList> {
  final List<Credit> _credits = [];
  String? _error;
  bool _loading = true;

  void loadCredits() async {
    final uri = Uri.https(
      'api.themoviedb.org',
      '/3/movie/${widget.movieId}/credits',
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

      final Map<String, dynamic> result = json.decode(response.body);
      final List loadedItems = result["cast"];

      for (final item in loadedItems.sublist(0, 10)) {
        _credits.add(
          Credit(
            id: item["id"],
            gender: item["gender"] == "1" ? Gender.female : Gender.male,
            name: item["name"],
            profilePath: item["profile_path"],
            character: item["character"],
          ),
        );
      }

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
    loadCredits();
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;

    return _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
            ? Center(
                child: Text(_error!),
              )
            : SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: _credits.length,
                  itemBuilder: (context, index) => Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    clipBehavior: Clip.hardEdge,
                    elevation: 2,
                    child: SizedBox(
                      width: 120,
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _credits[index].profilePath == null
                                ? SvgPicture.asset(
                                    _credits[index].gender == Gender.female
                                        ? 'assets/images/no_avatar_female.svg'
                                        : 'assets/images/no_avatar_male.svg',
                                    width: mediaWidth * 0.5,
                                    height: 160,
                                  )
                                : Image.network(
                                    'https://image.tmdb.org/t/p/w500/${_credits[index].profilePath}',
                                    width: mediaWidth * 0.5,
                                    height: 160,
                                    fit: BoxFit.cover,
                                  ),
                            const SizedBox(height: 6.0),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _credits[index].name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      _credits[index].character,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
  }
}
