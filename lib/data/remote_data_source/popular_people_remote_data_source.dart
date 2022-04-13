import 'dart:io';

import 'package:dio/dio.dart';
import 'package:popular_people/core/core.dart';
import 'package:popular_people/data/models/models.dart';
import 'package:popular_people/domain/use_cases/use_cases.dart';

abstract class PopularPeopleRemoteDataSource {
  Future<PopularPeopleModel> fetchPopularPeople(FetchPopularPeopleParam param);
  Future<PersonImageModel> fetchPersonImage(int personId);
}

class RestPopularPeopleRemoteDataSource
    implements PopularPeopleRemoteDataSource {
  final Dio dio;

  RestPopularPeopleRemoteDataSource({required this.dio});

  final fetchPopularPeopleEndpoint = "/person/popular";
  final getPersonImages = "/person";

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

  @override
  Future<PersonImageModel> fetchPersonImage(int personId) async {
    try {
      final queryParam = {"api_key": Strings.apiKey};
      var response = await dio.post("$getPersonImages/$personId/images",
          queryParameters: queryParam);
      if (response.statusCode == HttpStatus.ok) {
        return PersonImageModel.fromJson(response.data);
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
