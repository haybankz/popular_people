import 'package:equatable/equatable.dart';

import 'movie_entity.dart';

class PersonEntity extends Equatable {
  const PersonEntity({
    this.adult,
    this.gender,
    this.id,
    this.knownFor,
    this.knownForDepartment,
    this.name,
    this.popularity,
    this.profilePath,
  });

  final bool? adult;
  final int? gender;
  final int? id;
  final List<MoviesEntity>? knownFor;
  final String? knownForDepartment;
  final String? name;
  final double? popularity;
  final String? profilePath;

  @override
  List<Object?> get props => [
        adult,
        gender,
        id,
        knownFor,
        knownForDepartment,
        name,
        popularity,
        profilePath
      ];
}
