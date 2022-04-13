import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:popular_people/application/popular_people/providers/home_provider.dart';
import 'package:popular_people/application/popular_people/providers/person_detail_provider.dart';
import 'package:popular_people/dependency_container.dart';
import 'package:provider/provider.dart';

import 'application/application.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  initDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(
            create: (_) => GetIt.I<HomeProvider>()),
        ChangeNotifierProvider<PersonDetailProvider>(
            create: (_) => GetIt.I<PersonDetailProvider>()),
      ],
      child: MaterialApp(
        title: 'Popular People',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
