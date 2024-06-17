import 'package:flutter/material.dart';
import 'package:task_crud/constants/helpers/app_constants.dart';
import 'package:task_crud/constants/helpers/db_helper.dart';
import 'package:task_crud/constants/helpers/injection.dart';
import 'package:task_crud/constants/routes/app_router.dart';

import 'constants/helpers/initialize_singleton.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeSingletons();
  await getIt<DbHelper>().initializeDb(await AppConstants.getDbPath());
  await getIt<DbHelper>().checkAndInitializeTable();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BLoC CRUD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _appRouter.config(),
    );
  }
}
