import 'package:popular_people/domain/domain.dart';

import '../../core/core.dart';
import '../entities/entites.dart';

class FetchPopularPeopleUseCase
    implements UseCase<PopularPeopleEntity, FetchPopularPeopleParam> {
  final PopularPeopleRepository repository;

  FetchPopularPeopleUseCase({required this.repository});

  @override
  Future<Result<PopularPeopleEntity>> call(FetchPopularPeopleParam params) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

class FetchPopularPeopleParam {
  final int page;
  final String language;

  FetchPopularPeopleParam(this.page, this.language);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map["page"] = page;
    map["language"] = language;
    return map;
  }
}
