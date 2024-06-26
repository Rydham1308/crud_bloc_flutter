import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:task_crud/constants/enum/status.dart';
import 'package:task_crud/constants/helpers/api_config.dart';
import 'package:task_crud/modules/home/model/crud_model.dart';
import 'package:task_crud/modules/home/repository/todo_repository.dart';

part 'crud_event.dart';
part 'crud_state.dart';

class CrudBloc extends Bloc<CrudEvent, CrudState> {
  CrudBloc({required TodoRepository todoRepository})
      : _todoRepository = todoRepository,
        super(const CrudState()) {
    on<AddEvent>(addToList, transformer: droppable());
    on<EditEvent>(editList, transformer: droppable());
    on<DeleteEvent>(deleteFromList, transformer: droppable());
    on<GetEvent>(getList, transformer: droppable());
    on<FilterEvent>(filterList, transformer: droppable());
    on<SearchEvent>(searchList, transformer: droppable());
  }

  final ITodoRepository _todoRepository;
  List<CrudModel>? dataList = [];
  CrudModel crudModel = const CrudModel();

  Future<Unit> addToList(AddEvent event, Emitter<CrudState> emit) async {
    // final db = ApiConfig.dbService;
    //
    // final data = await _todoRepository
    //     .addToDB(crudModel.copyWith(
    //       title: db.encryptData(event.crudModel.title ?? ''),
    //       id: event.crudModel.id,
    //       description: event.crudModel.description,
    //       fav: event.crudModel.fav,
    //     ))
    //     .run();
    // data.fold(
    //   (l) {
    //     emit(state.copyWith(editStatus: Status.isError, errorMessage: l));
    //   },
    //   (r) {
    //     add(GetEvent());
    //     emit(state.copyWith(editStatus: Status.isLoaded));
    //   },
    // );

    Either.tryCatch(
      () {
        dataList?.add(event.crudModel);
        emit(state.copyWith(editStatus: Status.isLoaded));
      },
      (o, s) {
        emit(state.copyWith(editStatus: Status.isError, errorMessage: o.toString()));
      },
    );
    return unit;
  }

  Future<void> editList(EditEvent event, Emitter<CrudState> emit) async {
    Either.tryCatch(
      () {
        int index = dataList?.indexWhere((element) => element.id == event.crudModel.id) ?? -1;
        dataList?[index] = event.crudModel;
        emit(state.copyWith(editStatus: Status.isLoaded));
      },
      (o, s) {
        emit(state.copyWith(editStatus: Status.isError, errorMessage: o.toString()));
      },
    );
  }

  Future<void> deleteFromList(DeleteEvent event, Emitter<CrudState> emit) async {
    Either.tryCatch(
      () {
        dataList?.removeWhere(
          (element) => element.id == event.id,
        );
        emit(state.copyWith(deleteStatus: Status.isLoaded));
      },
      (o, s) {
        emit(state.copyWith(deleteStatus: Status.isError, errorMessage: o.toString()));
      },
    );
  }

  Future<Unit> getList(GetEvent event, Emitter<CrudState> emit) async {
    // final data = await _todoRepository.getFromDB().run();
    // data.fold(
    //   (l) {
    //     emit(state.copyWith(getStatus: Status.isError, errorMessage: l.toString()));
    //   },
    //   (r) {
    //     emit(state.copyWith(getStatus: Status.isLoaded, crudModel: r));
    //   },
    // );
    Either.tryCatch(
      () {
        emit(state.copyWith(getStatus: Status.isLoaded, crudModel: dataList));
      },
      (o, s) {
        emit(state.copyWith(getStatus: Status.isError, errorMessage: o.toString()));
      },
    );
    return unit;
  }

  Future<Unit> filterList(FilterEvent event, Emitter<CrudState> emit) async {
    Either.tryCatch(
      () {
        if (event.isFav) {
          final filteredList = state.crudModel?.where((element) => element.fav == true).toList();
          emit(state.copyWith(getStatus: Status.isLoaded, crudModel: filteredList));
        } else {
          emit(state.copyWith(getStatus: Status.isLoaded, crudModel: dataList));
        }
      },
      (o, s) {
        emit(state.copyWith(getStatus: Status.isError, errorMessage: o.toString()));
      },
    );
    return unit;
  }

  Future<Unit> searchList(SearchEvent event, Emitter<CrudState> emit) async {
    Either.tryCatch(
      () {
        List<CrudModel> searchList = [];
        if (event.searchData.isNotEmpty) {
          for (int i = 0; i < (state.crudModel?.length ?? 0); i++) {
            if ((state.crudModel?[i].title ?? '').toLowerCase().contains(event.searchData)) {
              searchList.add(state.crudModel?[i] ?? const CrudModel());
            }
          }
          emit(state.copyWith(getStatus: Status.isLoaded, crudModel: searchList));
        } else {
          emit(state.copyWith(getStatus: Status.isLoaded, crudModel: dataList));
        }
      },
      (o, s) {
        emit(state.copyWith(getStatus: Status.isError, errorMessage: o.toString()));
      },
    );

    return unit;
  }
}
