import 'package:fpdart/fpdart.dart';
import 'package:task_crud/constants/helpers/api_config.dart';
import 'package:task_crud/constants/helpers/database_constant.dart';
import 'package:task_crud/modules/home/model/crud_model.dart';

abstract class ITodoRepository {
  TaskEither<String, Unit> addToDB(CrudModel model);

  TaskEither<String, List<CrudModel>> getFromDB();
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

  @override
  TaskEither<String, List<CrudModel>> getFromDB() {
    final db = ApiConfig.dbService;
    List<CrudModel> finalDataList = [];
    CrudModel crudModel = const CrudModel();
    return TaskEither.tryCatch(
      () async {
        final data = await db.fetchDataFromDb(
          DatabaseConstant.todoTable,
        );
        List<CrudModel> dataModelList = data.map((e) => CrudModel.fromJson(e)).toList();
        for (int i = 0; i < dataModelList.length; i++) {
          finalDataList.add(crudModel.copyWith(
            title: db.decryptData(dataModelList[i].title ?? ''),
            id: dataModelList[i].id,
            description: dataModelList[i].description,
            fav: dataModelList[i].fav,
          ));
        }
        return finalDataList;
      },
      (o, s) {
        print(o.toString());
        return o.toString();
      },
    );
  }
}
