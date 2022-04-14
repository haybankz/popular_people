import 'package:flutter/material.dart';
import 'package:popular_people/core/core.dart';
import 'package:popular_people/domain/domain.dart';

class HomeProvider extends ChangeNotifier {
  final FetchPopularPeopleUseCase _fetchPopularPeopleUseCase;

  HomeProvider(this._fetchPopularPeopleUseCase);

  Result<PopularPeopleEntity> peopleResult =
      Result<PopularPeopleEntity>.completed(null);

  int currentPage = 0, totalPage = 1;
  List<PersonEntity> peopleList = [];
  bool isLoading = false;
  bool isLoadingMore = false;

  Future<void> fetchPeople() async {
    // check if we are at last page
    if (currentPage == totalPage) {
      return;
    }

    // check if it's initial fetch or not
    if (currentPage == 0) {
      isLoading = true;
    } else {
      isLoadingMore = true;
    }
    notifyListeners();

    peopleResult = await _fetchPopularPeopleUseCase
        .call(FetchPopularPeopleParam(currentPage + 1, "en-US"));

    isLoading = false;
    isLoadingMore = false;
    _addPeople();
    notifyListeners();
  }

  void _addPeople() {
    // only add to people list if api call is successful
    if (peopleResult.status == Status.completed) {
      peopleList.addAll(peopleResult.data?.results ?? []);

      _removeDuplicatePerson();
      _setPagination();
    }
  }

  // remove duplicate person object
  void _removeDuplicatePerson() {
    final existing = <PersonEntity>{};
    final unique = peopleList.where((e) => existing.add(e)).toList();
    peopleList.clear();
    peopleList.addAll(unique);
  }

  // update paginate value
  void _setPagination() {
    currentPage = peopleResult.data?.page ?? 0;
    totalPage = peopleResult.data?.totalPages ?? 1;
  }
}
