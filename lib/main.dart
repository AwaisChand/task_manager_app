import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'data/models/task_model.dart';
import 'domain/entities/task.dart';
import 'presentation/providers/task_provider.dart';
import 'presentation/screens/task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  Hive.registerAdapter(TaskPriorityAdapter());

  final taskBox = await Hive.openBox<TaskModel>('tasks');



  runApp(MyApp(taskBox: taskBox));
}

class MyApp extends StatelessWidget {
  final Box<TaskModel> taskBox;

  const MyApp({Key? key, required this.taskBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(taskBox)..loadTasks(),
      child: Sizer(
        builder: (context, orientation, screenType){
          return  MaterialApp(
            title: 'Task Manager',
            theme: ThemeData(
              textTheme: GoogleFonts.poppinsTextTheme(),
            ),
            home: TaskListScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
