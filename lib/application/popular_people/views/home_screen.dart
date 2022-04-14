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
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Popular People"),
      ),
      body: Builder(builder: (ctx) {
        if (_homeProvider.peopleResult.status == Status.loading) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator.adaptive(),
              ),
              Text("Loading ......")
            ],
          );
        } else if (_homeProvider.peopleResult.status == Status.error) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              TextButton(
                child: const Text(
                  "Error.\n Click to retry",
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  _homeProvider.fetchPeople();
                },
              )
            ],
          );
        }

        final peopleList = _homeProvider.peopleResult.data?.results ?? [];
        return ListView.separated(
            itemBuilder: (ctx, index) => Material(
                  child: ListTile(
                    leading: Hero(
                      tag: "person_${peopleList[index].id}",
                      child: _PersonImage(
                          imageUrl: peopleList[index].profilePath ?? ""),
                    ),
                    title: Text(
                      peopleList[index].name ?? "",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(peopleList[index].knownForDepartment ?? ""),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              transitionDuration: const Duration(seconds: 1),
                              pageBuilder: (_, __, ___) => PersonDetailScreen(
                                  person: peopleList[index])));
                    },
                  ),
                ),
            separatorBuilder: (ctx, index) => const Divider(
                  color: Colors.grey,
                ),
            itemCount: peopleList.length);
      }), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _PersonImage extends StatelessWidget {
  const _PersonImage({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(
          right: Radius.circular(4), left: Radius.circular(4)),
      child: CachedNetworkImage(
        imageUrl: "${Strings.imageStorageUrl}$imageUrl",
        width: 60,
        height: 60,
        fit: BoxFit.fill,
      ),
    );
  }
}
