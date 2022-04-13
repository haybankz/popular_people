import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:popular_people/data/data.dart';
import 'package:popular_people/domain/domain.dart';
import 'package:popular_people/domain/use_cases/fetch_person_image_use_case.dart';

import 'core/core.dart';

final di = GetIt.instance;

void initDI() {
  _registerOthers();
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
          di<NetworkInfo>(), di<PopularPeopleRemoteDataSource>()));
}

// * Network data sources
_registerRemoteDataSources() {
  di.registerFactory<PopularPeopleRemoteDataSource>(
      () => RestPopularPeopleRemoteDataSource(dio: di<Dio>()));
}

// * Local data sources
_registerLocalDataSources() {
  //TODO register remote local sources
}

//  * Providers
_registerProviders() {
  //TODO register change notifiers
}

// * External
_registerOthers() {
  //TODO register external packages
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

  di.registerSingleton<InternetConnectionChecker>(InternetConnectionChecker());

  di.registerFactory<NetworkInfo>(
      () => NetworkInfoImpl(di<InternetConnectionChecker>()));
}
