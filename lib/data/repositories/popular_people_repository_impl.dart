import 'package:popular_people/core/core.dart';
import 'package:popular_people/data/data.dart';
import 'package:popular_people/domain/domain.dart';

class PopularPeopleRepositoryImpl implements PopularPeopleRepository {
  final NetworkInfo networkInfo;
  final PopularPeopleRemoteDataSource remoteDataSource;
  final PopularPeopleLocalDataSource localDataSource;

  PopularPeopleRepositoryImpl(
      this.networkInfo, this.remoteDataSource, this.localDataSource);

  @override
  Future<Result<PopularPeopleModel>> fetchPopularPeople(
      FetchPopularPeopleParam param) async {
    try {
      if (await networkInfo.isConnected) {
        final response = await remoteDataSource.fetchPopularPeople(param);
        await localDataSource
            .cachePopularPeople(response.results as List<PersonModel>);

        return Result<PopularPeopleModel>.completed(response);
      } else {
        if (param.page == 1) {
          final popularPeopleModel = await _fetchCachedPopularPeople();
          return Result<PopularPeopleModel>.completed(popularPeopleModel);
        }
        return Result<PopularPeopleModel>.error(Strings.noInternet);
      }
    } on ServerException catch (e) {
      return Result<PopularPeopleModel>.error(e.message);
    } on CacheException catch (e) {
      return Result<PopularPeopleModel>.error(e.message);
    } catch (e) {
      return Result<PopularPeopleModel>.error(e.toString());
    }
  }

  @override
  Future<Result<PersonImageModel>> fetchPersonImage(int personId) async {
    try {
      if (await networkInfo.isConnected) {
        final response = await remoteDataSource.fetchPersonImage(personId);
        return Result<PersonImageModel>.completed(response);
      } else {
        return Result<PersonImageModel>.error(Strings.noInternet);
      }
    } on ServerException catch (e) {
      return Result<PersonImageModel>.error(e.message);
    } catch (e) {
      return Result<PersonImageModel>.error(e.toString());
    }
  }

  Future<PopularPeopleModel> _fetchCachedPopularPeople() async {
    final people = await localDataSource.fetchPopularPeople();
    final popularPeopleModel = PopularPeopleModel(
        page: 1, results: people, totalPages: 2, totalResults: people.length);
    return popularPeopleModel;
  }
}
