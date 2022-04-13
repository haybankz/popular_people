import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/core.dart';

final di = GetIt.instance;

void initDI() {
  _registerUseCases();
  _registerRepositories();
  _registerRemoteDataSources();
  _registerLocalDataSources();
  _registerOthers();
  _registerProviders();
}

//* use cases
_registerUseCases() {
  //TODO register use cases
}
// * Repositories
_registerRepositories() {
  //TODO register repositories
}
// * Network data sources
_registerRemoteDataSources() {
  //TODO register remote data sources
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
  di.registerFactory<ApiBaseHelper>(() => ApiBaseHelper());

  di.registerSingleton<InternetConnectionChecker>(InternetConnectionChecker());

  di.registerFactory<NetworkInfo>(
      () => NetworkInfoImpl(di<InternetConnectionChecker>()));
}
