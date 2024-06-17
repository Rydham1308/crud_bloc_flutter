// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:task_crud/modules/home/bloc/crud_bloc.dart' as _i6;
import 'package:task_crud/modules/home/model/crud_model.dart' as _i7;
import 'package:task_crud/modules/home/screens/add_screen.dart' as _i1;
import 'package:task_crud/modules/home/screens/home_screen.dart' as _i2;
import 'package:task_crud/modules/paint/my_painter.dart' as _i3;

abstract class $AppRouter extends _i4.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    AddRoute.name: (routeData) {
      final args = routeData.argsAs<AddRouteArgs>();
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.WrappedRoute(
            child: _i1.AddScreen(
          key: args.key,
          crudBloc: args.crudBloc,
          crudModelEdit: args.crudModelEdit,
        )),
      );
    },
    HomeRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.WrappedRoute(child: const _i2.HomeScreen()),
      );
    },
    MyPainter.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.MyPainter(),
      );
    },
  };
}

/// generated route for
/// [_i1.AddScreen]
class AddRoute extends _i4.PageRouteInfo<AddRouteArgs> {
  AddRoute({
    _i5.Key? key,
    required _i6.CrudBloc crudBloc,
    _i7.CrudModel? crudModelEdit,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          AddRoute.name,
          args: AddRouteArgs(
            key: key,
            crudBloc: crudBloc,
            crudModelEdit: crudModelEdit,
          ),
          initialChildren: children,
        );

  static const String name = 'AddRoute';

  static const _i4.PageInfo<AddRouteArgs> page =
      _i4.PageInfo<AddRouteArgs>(name);
}

class AddRouteArgs {
  const AddRouteArgs({
    this.key,
    required this.crudBloc,
    this.crudModelEdit,
  });

  final _i5.Key? key;

  final _i6.CrudBloc crudBloc;

  final _i7.CrudModel? crudModelEdit;

  @override
  String toString() {
    return 'AddRouteArgs{key: $key, crudBloc: $crudBloc, crudModelEdit: $crudModelEdit}';
  }
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute({List<_i4.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i3.MyPainter]
class MyPainter extends _i4.PageRouteInfo<void> {
  const MyPainter({List<_i4.PageRouteInfo>? children})
      : super(
          MyPainter.name,
          initialChildren: children,
        );

  static const String name = 'MyPainter';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}
