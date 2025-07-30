import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

import '../../data/datasources/local_task_data_source.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/get_all_tasks.dart';
import '../../domain/usecases/update_task.dart';
import '../../presentation/providers/task_provider.dart';


List<ChangeNotifierProvider> buildProviders(Box<TaskModel> taskBox) {
  final localDataSource = LocalTaskDataSource(taskBox);
  final taskRepo = TaskRepositoryImpl(localDataSource);

  return [
    ChangeNotifierProvider<TaskProvider>(
      create: (_) => TaskProvider(
        getAllTasks: GetAllTasks(taskRepo),
        addTask: AddTask(taskRepo),
        updateTask: UpdateTask(taskRepo),
        deleteTask: DeleteTask(taskRepo),
      )..loadTasks(),
    ),
  ];
}
