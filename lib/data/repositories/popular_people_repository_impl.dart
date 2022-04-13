import 'package:popular_people/core/core.dart';
import 'package:popular_people/core/network/network.dart';
import 'package:popular_people/data/data.dart';
import 'package:popular_people/domain/domain.dart';

class PopularPeopleRepositoryImpl implements PopularPeopleRepository {
  final NetworkInfo networkInfo;
  final PopularPeopleRemoteDataSource remoteDataSource;

  PopularPeopleRepositoryImpl(this.networkInfo, this.remoteDataSource);

  @override
  Future<Result<PopularPeopleEntity>> fetchPopularPeople(
      FetchPopularPeopleParam param) async {
    try {
      if (await networkInfo.isConnected) {
        final response = await remoteDataSource.fetchPopularPeople(param);
        return Result<PopularPeopleModel>.completed(response);
      } else {
        //TODO return popular people list from local datasource
        return Result<PopularPeopleEntity>.error(Strings.noInternet);
      }
    } on ServerException catch (e) {
      return Result<PopularPeopleEntity>.error(e.message);
    } catch (e) {
      return Result<PopularPeopleEntity>.error(e.toString());
    }
  }
}
