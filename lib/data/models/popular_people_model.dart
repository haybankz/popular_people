import 'package:popular_people/domain/entities/entites.dart';

import 'person_model.dart';

class PopularPeopleModel extends PopularPeopleEntity {
  const PopularPeopleModel(
      {required int? page,
      required List<PersonModel> results,
      required int? totalPages,
      required int? totalResults})
      : super(
            page: page,
            results: results,
            totalPages: totalPages,
            totalResults: totalResults);

  factory PopularPeopleModel.fromJson(dynamic json) {
    final List<PersonModel> resultList = [];
    if (json['results'] != null) {
      for (final res in json["results"]) {
        resultList.add(PersonModel.fromJson(res));
      }
    }
    return PopularPeopleModel(
        page: json['page'],
        results: resultList,
        totalPages: json['total_pages'],
        totalResults: json['total_results']);
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    if (results != null) {
      map['results'] =
          results?.map((v) => (v as PersonModel).toJson()).toList();
    }
    map['total_pages'] = totalPages;
    map['total_results'] = totalResults;
    return map;
  }
}
