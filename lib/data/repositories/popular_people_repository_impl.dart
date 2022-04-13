import 'package:popular_people/core/core.dart';
import 'package:popular_people/core/network/network.dart';
import 'package:popular_people/data/data.dart';
import 'package:popular_people/domain/domain.dart';

class PopularPeopleRepositoryImpl implements PopularPeopleRepository {
  final NetworkInfo networkInfo;
  final PopularPeopleRemoteDataSource remoteDataSource;

  PopularPeopleRepositoryImpl(this.networkInfo, this.remoteDataSource);

  @override
  Future<Result<PopularPeopleModel>> fetchPopularPeople(
      FetchPopularPeopleParam param) async {
    try {
      if (await networkInfo.isConnected) {
        final response = await remoteDataSource.fetchPopularPeople(param);
        return Result<PopularPeopleModel>.completed(response);
      } else {
        //TODO return popular people list from local datasource
        return Result<PopularPeopleModel>.error(Strings.noInternet);
      }
    } on ServerException catch (e) {
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
}
