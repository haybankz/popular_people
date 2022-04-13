import 'dart:io';

import 'package:dio/dio.dart';
import 'package:popular_people/core/constants/constants.dart';
import 'package:popular_people/core/core.dart';
import 'package:popular_people/data/models/models.dart';
import 'package:popular_people/domain/use_cases/use_cases.dart';

abstract class PopularPeopleRemoteDataSource {
  Future<PopularPeopleModel> fetchPopularPeople(FetchPopularPeopleParam param);
}

class RestPopularPeopleRemoteDataSource
    implements PopularPeopleRemoteDataSource {
  final Dio dio;

  RestPopularPeopleRemoteDataSource({required this.dio});

  final fetchPopularPeopleEndpoint = "/person/popular";

  @override
  Future<PopularPeopleModel> fetchPopularPeople(
      FetchPopularPeopleParam param) async {
    try {
      final queryParam = param.toJson();
      queryParam['api_key'] = Strings.apiKey;
      var response = await dio.post(fetchPopularPeopleEndpoint,
          queryParameters: queryParam);
      if (response.statusCode == HttpStatus.ok) {
        return PopularPeopleModel.fromJson(response.data);
      } else {
        throw ServerException(Strings.unableToFetch);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(Strings.parsing);
    }
  }
}
