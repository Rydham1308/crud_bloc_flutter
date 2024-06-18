import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_crud/constants/enum/status.dart';
import 'package:task_crud/constants/routes/app_router.gr.dart';
import 'package:task_crud/modules/home/bloc/crud_bloc.dart';
import 'package:task_crud/modules/home/model/crud_model.dart';
import 'package:task_crud/modules/home/repository/todo_repository.dart';

@RoutePage()
class HomeScreen extends StatefulWidget implements AutoRouteWrapper {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(providers: [
      RepositoryProvider(
        create: (context) => const TodoRepository(),
      ),
      BlocProvider(
        create: (context) {
          return CrudBloc(todoRepository: context.read<TodoRepository>())..add(GetEvent());
        },
      ),
    ], child: this);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  bool onlyFav = false;
  TextEditingController txtSearch = TextEditingController();
  final MethodChannel platformChannel = const MethodChannel('my_channel');

  int _batteryLevel = 0;

  @override
  void initState() {
    fetchDataFromNative();
    _getBatteryLevel();
    super.initState();
  }

  @override
  void dispose() {
    txtSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = context.router;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.purple.shade100,
        title: const Text('BLoC Crud'),
        actions: [
          Text('$_batteryLevel'),
          IconButton(
            onPressed: () {
              router.push(const MyPainter());
            },
            icon: const Icon(Icons.draw),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                context.read<CrudBloc>().add(SearchEvent(searchData: txtSearch.text));
              },
              controller: txtSearch,
              cursorColor: Colors.black,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.purple.shade50,
                focusColor: Colors.purple.shade50,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50),
                ),
                hintText: "Search",
                hintStyle: const TextStyle(color: Colors.deepPurple),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(
                    Icons.search_rounded,
                    color: Colors.deepPurple,
                  ),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                const Text('Show Favourites'),
                StatefulBuilder(
                  builder: (context, setSwitch) {
                    return Switch(
                      value: onlyFav,
                      onChanged: (value) {
                        onlyFav = !onlyFav;
                        context.read<CrudBloc>().add(FilterEvent(isFav: onlyFav));
                        setSwitch(() {});
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          BlocBuilder<CrudBloc, CrudState>(
            builder: (context, state) {
              if (state.getStatus == Status.isLoaded) {
                if (state.crudModel?.isNotEmpty ?? false) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.crudModel?.length ?? 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shadowColor: Colors.purple.shade400,
                          elevation: 8,
                          child: ListTile(
                            onTap: () {
                              router.push(
                                AddRoute(
                                  crudBloc: context.read<CrudBloc>(),
                                  crudModelEdit: state.crudModel?[index],
                                ),
                              );
                            },
                            title: Text(
                              state.crudModel?[index].title ?? '',
                              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
                            ),
                            subtitle: Text(
                              state.crudModel?[index].description ?? '',
                              style: const TextStyle(fontSize: 13),
                            ),
                            trailing: IconButton(
                              highlightColor: Colors.purple.withAlpha(120),
                              splashColor: Colors.purple,
                              onPressed: () {
                                HapticFeedback.heavyImpact();
                                context.read<CrudBloc>().add(
                                      EditEvent(
                                        crudModel: state.crudModel?[index].copyWith(
                                              fav: !(state.crudModel?[index].fav ?? false),
                                            ) ??
                                            const CrudModel(),
                                      ),
                                    );
                              },
                              icon: state.crudModel?[index].fav ?? false
                                  ? const Icon(
                                      CupertinoIcons.suit_heart_fill,
                                      color: Colors.purple,
                                    )
                                  : const Icon(
                                      CupertinoIcons.suit_heart,
                                      color: Colors.purple,
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Expanded(
                    child: Center(
                      child: Text('No Data'),
                    ),
                  );
                }
              } else {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          router.push(AddRoute(crudBloc: context.read<CrudBloc>()));
        },
        // isExtended: true,
        // shape: RoundedRectangleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void fetchDataFromNative() async {
    try {
      final String result = await platformChannel.invokeMethod('getDataFromNative');
      print('Result from Native::::::::::::::::::::::::::::::::::::: $result');
    } on PlatformException catch (e) {
      print('Error::::::::::::::::::::::::::::::: ${e.message}');
    }
  }

  Future<void> _getBatteryLevel() async {
    try {
      final int result = await platformChannel.invokeMethod('getBatteryLevel');
      setState(() {
        _batteryLevel = result;
      });
      print('Battery level at :::::::::::::::::::::::::: $result % .');
    } on PlatformException catch (e) {
      print('Failed to get battery level:::::::::::::::::: ${e.message}');
    }
  }
}
