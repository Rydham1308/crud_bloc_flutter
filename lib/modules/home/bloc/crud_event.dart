part of 'crud_bloc.dart';

@immutable
abstract class CrudEvent {}

class AddEvent extends CrudEvent {
  final CrudModel crudModel;

  AddEvent({required this.crudModel});
}

class EditEvent extends CrudEvent {
  final CrudModel crudModel;

  EditEvent({required this.crudModel});
}

class GetEvent extends CrudEvent {}

class DeleteEvent extends CrudEvent {
  final int id;

  DeleteEvent({required this.id});
}

class FilterEvent extends CrudEvent{
  final bool isFav;

  FilterEvent({required this.isFav});
}

class SearchEvent extends CrudEvent{
  final String searchData;

  SearchEvent({required this.searchData});
}