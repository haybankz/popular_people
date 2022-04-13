import 'package:equatable/equatable.dart';

import 'person_entity.dart';

class PopularPeopleEntity extends Equatable {
  const PopularPeopleEntity({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  final int? page;
  final List<PersonEntity>? results;
  final int? totalPages;
  final int? totalResults;

  @override
  List<Object?> get props => [page, results, totalPages, totalResults];
}
