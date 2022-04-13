import 'package:equatable/equatable.dart';

class PersonEntity extends Equatable {
  const PersonEntity({
    this.adult,
    this.gender,
    this.id,
    this.knownForDepartment,
    this.name,
    this.popularity,
    this.profilePath,
  });

  final bool? adult;
  final int? gender;
  final int? id;
  final String? knownForDepartment;
  final String? name;
  final double? popularity;
  final String? profilePath;

  @override
  List<Object?> get props =>
      [adult, gender, id, knownForDepartment, name, popularity, profilePath];
}
