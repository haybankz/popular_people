import 'package:popular_people/domain/entities/entites.dart';

class PersonModel extends PersonEntity {
  const PersonModel(
      {required bool? adult,
      required int? gender,
      required int? id,
      required String? knownForDepartment,
      required String? name,
      required double? popularity,
      required String? profilePath})
      : super(
            adult: adult,
            gender: gender,
            id: id,
            knownForDepartment: knownForDepartment,
            name: name,
            popularity: popularity,
            profilePath: profilePath);

  factory PersonModel.fromJson(dynamic json) {
    return PersonModel(
        adult: json['adult'],
        gender: json['gender'],
        id: json['id'],
        knownForDepartment: json['known_for_department'],
        name: json['name'],
        popularity: json['popularity'],
        profilePath: json['profile_path']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['adult'] = adult;
    map['gender'] = gender;
    map['id'] = id;
    map['known_for_department'] = knownForDepartment;
    map['name'] = name;
    map['popularity'] = popularity;
    map['profile_path'] = profilePath;
    return map;
  }
}
