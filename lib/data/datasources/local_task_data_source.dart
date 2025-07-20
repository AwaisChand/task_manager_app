import 'package:hive/hive.dart';

import '../models/task_model.dart';

class LocalTaskDataSource {
  final Box<TaskModel> box;

  LocalTaskDataSource(this.box);

  Future<void> addTask(TaskModel task) async => await box.put(task.id, task);
  Future<void> updateTask(TaskModel task) async => await box.put(task.id, task);
  Future<void> deleteTask(String id) async => await box.delete(id);
  List<TaskModel> getAllTasks() => box.values.toList();
}
