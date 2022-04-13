import 'package:popular_people/core/core.dart';
import 'package:popular_people/domain/domain.dart';

class FetchPersonImageUseCase implements UseCase<PersonImageEntity, int> {
  final PopularPeopleRepository repository;

  FetchPersonImageUseCase({required this.repository});

  @override
  Future<Result<PersonImageEntity>> call(int personId) {
    return repository.fetchPersonImage(personId);
  }
}
