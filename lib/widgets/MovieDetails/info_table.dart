import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InfoTable extends StatelessWidget {
  const InfoTable({
    super.key,
    required this.videoDuration,
    required this.spokenLanguages,
    required this.releaseDate,
    required this.boxOffice,
  });

  final String videoDuration;
  final String spokenLanguages;
  final String releaseDate;
  final int? boxOffice;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "影片长度",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: const Color.fromRGBO(104, 131, 146, 1),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      videoDuration,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "语言",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: const Color.fromRGBO(104, 131, 146, 1),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      spokenLanguages,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "票房",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: const Color.fromRGBO(104, 131, 146, 1),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      boxOffice != 0
                          ? NumberFormat.compactSimpleCurrency()
                              .format(boxOffice)
                          : "即将上映",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "上映时间",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: const Color.fromRGBO(104, 131, 146, 1),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      releaseDate,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
