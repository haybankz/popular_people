import 'package:flutter/material.dart';
import 'package:popular_people/core/core.dart';
import 'package:popular_people/domain/domain.dart';

class PersonDetailProvider extends ChangeNotifier {
  final FetchPersonImageUseCase _fetchPersonImageUseCase;

  PersonDetailProvider(this._fetchPersonImageUseCase);

  Result<PersonImageEntity> personImageResult =
      Result<PersonImageEntity>.completed(null);

  Future<void> getPersonImage(int personId) async {
    personImageResult = Result<PersonImageEntity>.loading("");
    notifyListeners();

    personImageResult = await _fetchPersonImageUseCase.call(personId);
    notifyListeners();
  }
}
