import 'package:flutter/material.dart';
import 'package:popular_people/application/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../../../core/core.dart';
import '../popular_people.dart';

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
          return const Center(
            child: LoadingWidget(),
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
          child: ErrorMessageWidget(
            errorMessage: _homeProvider.peopleResult.message,
            onRetry: () {
              _homeProvider.fetchPeople();
            },
          ),
        );
      }),
    );
  }
}
