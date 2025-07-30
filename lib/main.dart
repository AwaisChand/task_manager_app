import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:task_manager_app/presentation/screens/task_list_screen.dart';

import 'core/constants/providers.dart';
import 'data/models/task_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register only required adapters
  Hive.registerAdapter(TaskPriorityModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());

  // Open the Hive box
  final taskBox = await Hive.openBox<TaskModel>('tasks');

  // Run the app
  runApp(MyApp(taskBox: taskBox));
}

class MyApp extends StatelessWidget {
  final Box<TaskModel> taskBox;

  const MyApp({super.key, required this.taskBox});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildProviders(taskBox),
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            title: 'Task Manager',
            theme: ThemeData(
              textTheme: GoogleFonts.poppinsTextTheme(),
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle.light,
              ),
            ),
            home: TaskListScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
