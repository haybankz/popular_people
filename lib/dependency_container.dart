import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:popular_people/application/popular_people/providers/home_provider.dart';
import 'package:popular_people/application/popular_people/providers/person_detail_provider.dart';
import 'package:popular_people/data/data.dart';
import 'package:popular_people/domain/domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/core.dart';

final di = GetIt.instance;

Future<void> initDI() async {
  await _registerOthers();
  _registerRepositories();
  _registerRemoteDataSources();
  _registerLocalDataSources();
  _registerProviders();
  _registerUseCases();
}

//* use cases
_registerUseCases() {
  di.registerFactory(() =>
      FetchPopularPeopleUseCase(repository: di<PopularPeopleRepository>()));

  di.registerFactory(
      () => FetchPersonImageUseCase(repository: di<PopularPeopleRepository>()));
}

// * Repositories
_registerRepositories() {
  di.registerLazySingleton<PopularPeopleRepository>(() =>
      PopularPeopleRepositoryImpl(
          di<NetworkInfo>(),
          di<PopularPeopleRemoteDataSource>(),
          di<PopularPeopleLocalDataSource>()));
}

// * Network data sources
_registerRemoteDataSources() {
  di.registerFactory<PopularPeopleRemoteDataSource>(
      () => RestPopularPeopleRemoteDataSource(dio: di<Dio>()));
}

// * Local data sources
_registerLocalDataSources() {
  di.registerFactory<PopularPeopleLocalDataSource>(
      () => CachedPopularPeopleDataSource(di<SharedPreferences>()));
}

//  * Providers
_registerProviders() {
  di.registerFactory(() => HomeProvider(di<FetchPopularPeopleUseCase>()));
  di.registerFactory(() => PersonDetailProvider(di<FetchPersonImageUseCase>()));
}

// * External
_registerOthers() async {
  Dio dio = Dio(BaseOptions(
    baseUrl: Strings.baseUrl,
    connectTimeout: 1000 * 60, //60sec
    receiveTimeout: 1000 * 60, //60sec
  ));
  if (kDebugMode) {
    dio.interceptors.add(LogInterceptor(
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
        request: true,
        requestBody: true));
  }
  di.registerFactory<Dio>(() => dio);

  final prefs = await SharedPreferences.getInstance();
  di.registerFactory<SharedPreferences>(() => prefs);

  di.registerSingleton<InternetConnectionChecker>(InternetConnectionChecker());

  di.registerFactory<NetworkInfo>(
      () => NetworkInfoImpl(di<InternetConnectionChecker>()));
}
