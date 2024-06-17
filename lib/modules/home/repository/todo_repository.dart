import 'package:fpdart/fpdart.dart';
import 'package:task_crud/constants/helpers/api_config.dart';
import 'package:task_crud/constants/helpers/database_constant.dart';
import 'package:task_crud/modules/home/model/crud_model.dart';

abstract interface class ITodoRepository {
  TaskEither<String, Unit> addToDB(CrudModel model);
}

class TodoRepository implements ITodoRepository {
  const TodoRepository();

  @override
  TaskEither<String, Unit> addToDB(CrudModel model) {
    final db = ApiConfig.dbService;
    return TaskEither.tryCatch(
      () async {
        await db.insertTable(
          DatabaseConstant.todoTable,
          model.toJson(),
        );
        return unit;
      },
      (o, s) {
        return o.toString();
      },
    );
  }
}
