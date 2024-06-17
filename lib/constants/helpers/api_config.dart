import 'package:task_crud/constants/helpers/db_helper.dart';
import 'package:task_crud/constants/helpers/injection.dart';

abstract class ApiConfig {
  static DbHelper dbService = getIt<DbHelper>();
}
