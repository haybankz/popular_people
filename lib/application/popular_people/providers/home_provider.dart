import 'package:flutter/material.dart';
import 'package:popular_people/core/core.dart';
import 'package:popular_people/domain/domain.dart';

class HomeProvider extends ChangeNotifier {
  final FetchPopularPeopleUseCase _fetchPopularPeopleUseCase;

  HomeProvider(this._fetchPopularPeopleUseCase);

  Result<PopularPeopleEntity> peopleResult =
      Result<PopularPeopleEntity>.completed(null);

  Future<void> fetchPeople() async {
    peopleResult = Result<PopularPeopleEntity>.loading("");
    notifyListeners();

    peopleResult = await _fetchPopularPeopleUseCase
        .call(FetchPopularPeopleParam(1, "en-US"));
    notifyListeners();
  }
}
