import 'package:flutter/material.dart';
import 'package:popular_people/application/popular_people/providers/home_provider.dart';
import 'package:popular_people/application/popular_people/views/person_detail_screen.dart';
import 'package:popular_people/core/core.dart';
import 'package:popular_people/domain/entities/person_entity.dart';
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
        if (_homeProvider.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
        } else if (_homeProvider.peopleResult.status == Status.completed ||
            _homeProvider.peopleList.isNotEmpty) {
          final peopleList = _homeProvider.peopleList;
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!_homeProvider.isLoadingMore &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  scrollInfo.metrics.pixels > 0) {
                _homeProvider.fetchPeople();
              }

              return true;
            },
            child: ListView.separated(
                key: const Key("peopleListViewKey"),
                itemBuilder: (ctx, index) {
                  if (index == peopleList.length - 1) {
                    return Column(
                      children: [
                        PersonWidget(person: peopleList[index]),
                        const SizedBox(
                          height: 10,
                        ),
                        _homeProvider.isLoadingMore
                            ? const Text("Loading more.....")
                            : const SizedBox.shrink(),
                        SizedBox(
                          height: _homeProvider.isLoadingMore ? 50 : 0,
                        ),
                      ],
                    );
                  }

                  return PersonWidget(person: peopleList[index]);
                },
                separatorBuilder: (ctx, index) => const Divider(
                      color: Colors.grey,
                    ),
                itemCount: peopleList.length),
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              Text(_homeProvider.peopleResult.message),
              TextButton(
                child: const Text(
                  "Click to retry",
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  _homeProvider.fetchPeople();
                },
              )
            ],
          ),
        );
      }),
    );
  }
}

class PersonWidget extends StatelessWidget {
  const PersonWidget({
    Key? key,
    required this.person,
  }) : super(key: key);

  final PersonEntity person;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: "person_${person.id}",
        child: _PersonImage(imageUrl: person.profilePath ?? ""),
      ),
      title: Text(
        person.name ?? "",
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Text(person.knownForDepartment ?? ""),
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: const Duration(seconds: 1),
                pageBuilder: (_, __, ___) =>
                    PersonDetailScreen(person: person)));
      },
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
      child: Image.network(
        "${Strings.imageStorageUrl}$imageUrl",
        width: 60,
        height: 60,
        fit: BoxFit.fill,
      ),
    );
  }
}
