import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:popular_people/application/popular_people/providers/home_provider.dart';
import 'package:popular_people/application/popular_people/views/person_detail_screen.dart';
import 'package:popular_people/core/core.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeProvider _homeProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<HomeProvider>(context, listen: false).fetchPeople();
    });
  }

  @override
  Widget build(BuildContext context) {
    _homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      body: Builder(builder: (ctx) {
        if (_homeProvider.peopleResult.status == Status.loading) {
          return Center(
            child: Column(
              children: const [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator.adaptive(),
                ),
                Text("Loading ......")
              ],
            ),
          );
        } else if (_homeProvider.peopleResult.status == Status.error) {
          return Center(
            child: Column(
              children: const [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                ),
                Text("Loading ......")
              ],
            ),
          );
        }

        final peopleList = _homeProvider.peopleResult.data?.results ?? [];
        return ListView.separated(
            itemBuilder: (ctx, index) => ListTile(
                  leading: ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(4), left: Radius.circular(4)),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://image.tmdb.org/t/p/w500${peopleList[index].profilePath!}",
                      width: 60,
                      height: 60,
                      fit: BoxFit.fill,
                    ),
                  ),
                  title: Text(peopleList[index].name ?? ""),
                  subtitle: Text(peopleList[index].knownForDepartment ?? ""),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                PersonDetailScreen(person: peopleList[index])));
                  },
                ),
            separatorBuilder: (ctx, index) => const Divider(
                  color: Colors.grey,
                ),
            itemCount: peopleList.length);
      }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
