import 'package:frontend/core/service/event_service.dart';
import 'package:get_it/get_it.dart';
final getIt = GetIt.instance;
void setupLocator() {
  getIt.registerLazySingleton(() => EventService());
}