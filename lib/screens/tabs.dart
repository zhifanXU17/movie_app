import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/screens/home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:movie_app/widgets/custom_navigation_bar.dart';

const storage = FlutterSecureStorage();

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int currentPageIndex = 0;

  void _initToken() async {
    await dotenv.load(fileName: ".env");

    await storage.write(
      key: "token",
      value: dotenv.env["TOKEN"],
    );
  }

  @override
  void initState() {
    super.initState();
    _initToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_outlined)),
        ],
      ),
      body: const SingleChildScrollView(child: HomeScreen()),
      bottomNavigationBar: const CustomNavigationBar(),
    );
  }
}
