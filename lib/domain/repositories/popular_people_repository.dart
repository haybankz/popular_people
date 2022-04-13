import '../../core/core.dart';
import '../entities/entites.dart';
import '../use_cases/use_cases.dart';

abstract class PopularPeopleRepository {
  Future<Result<PopularPeopleEntity>> fetchPopularPeople(
      FetchPopularPeopleParam param);
}
