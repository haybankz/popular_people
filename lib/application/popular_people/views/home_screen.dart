import 'package:flutter/material.dart';
import 'package:popular_people/application/popular_people/providers/home_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Provider.of<HomeProvider>(context, listen: false).fetchPeople();
        },
      ),
      body:
          Container(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
