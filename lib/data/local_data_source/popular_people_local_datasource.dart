import 'dart:convert';

import 'package:popular_people/core/core.dart';
import 'package:popular_people/data/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PopularPeopleLocalDataSource {
  Future<List<PersonModel>> fetchPopularPeople();
  Future<void> cachePopularPeople(List<PersonModel> people);
}

class CachedPopularPeopleDataSource implements PopularPeopleLocalDataSource {
  final SharedPreferences _preferences;

  CachedPopularPeopleDataSource(this._preferences);

  static const peopleKey = "popular_people";

  @override
  Future<void> cachePopularPeople(List<PersonModel> people) async {
    try {
      final peopleList = people.map((e) => e.toJson()).toList();
      final peopleJsonString = json.encode(peopleList);
      await _preferences.setString(peopleKey, peopleJsonString);
    } catch (e) {
      throw CacheException(Strings.cacheError);
    }
  }

  @override
  Future<List<PersonModel>> fetchPopularPeople() async {
    try {
      final peopleString = _preferences.getString(peopleKey);
      if (!(peopleString == null || peopleString.isEmpty)) {
        final peopleList = json.decode(peopleString);
        final List<PersonModel> people = [];
        for (final personJson in peopleList) {
          people.add(PersonModel.fromJson(personJson));
        }
        return people;
      } else {
        throw CacheException(Strings.cacheNoDataError);
      }
    } catch (e) {
      throw CacheException(Strings.cacheReadError);
    }
  }
}
