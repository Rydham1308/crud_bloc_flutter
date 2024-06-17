part of 'crud_bloc.dart';

@immutable
class CrudState{
  final String? errorMessage;
  final Status? addStatus;
  final Status? editStatus;
  final Status? getStatus;
  final Status? deleteStatus;
  final List<CrudModel>? crudModel;

  const CrudState({
    this.errorMessage,
    this.crudModel,
    this.getStatus = Status.isInitial,
    this.editStatus = Status.isInitial,
    this.addStatus = Status.isInitial,
    this.deleteStatus = Status.isInitial,
  });

  CrudState copyWith({
    String? errorMessage,
    List<CrudModel>? crudModel,
    Status? addStatus,
    Status? editStatus,
    Status? getStatus,
    Status? deleteStatus,
  }) {
    return CrudState(
      addStatus: addStatus ??  this.addStatus,
      editStatus: editStatus ??  this.editStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      getStatus: getStatus ?? this.getStatus,
      deleteStatus: deleteStatus ?? this.deleteStatus,
      crudModel: crudModel ?? this.crudModel,
    );
  }
}
