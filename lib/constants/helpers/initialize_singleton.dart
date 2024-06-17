import 'package:task_crud/constants/helpers/db_helper.dart';
import 'package:task_crud/constants/helpers/injection.dart';

void initializeSingletons() {
  getIt.registerSingleton<DbHelper>(DbHelper());
}
