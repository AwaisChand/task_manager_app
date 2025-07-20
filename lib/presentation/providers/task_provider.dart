import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../data/datasources/local_task_data_source.dart';
import '../../data/models/task_model.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../../data/repositories/task_repository_impl.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _repo;

  TaskProvider(Box<TaskModel> box)
      : _repo = TaskRepositoryImpl(LocalTaskDataSource(box));

  List<Task> _allTasks = [];
  List<Task> _filteredTasks = [];

  TaskPriority? _filterPriority;
  DateTime? _filterDate;

  List<Task> get tasks => _filteredTasks;
  TaskPriority? get filterPriority => _filterPriority;

  Future<void> loadTasks() async {
    _allTasks = await _repo.getAllTasks();
    applyFilters();
  }

  void addTask(Task task) async {
    await _repo.addTask(task);
    _allTasks.add(task);
    applyFilters();
  }

  void updateTask(Task task) async {
    await _repo.updateTask(task);
    final index = _allTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _allTasks[index] = task;
    }
    applyFilters();
  }

  void deleteTask(String id) async {
    await _repo.deleteTask(id);
    _allTasks.removeWhere((t) => t.id == id);
    applyFilters();
  }

  void filterByPriority(TaskPriority? priority) {
    _filterPriority = priority;
    applyFilters();
  }

  void filterByDate(DateTime? date) {
    _filterDate = date;
    applyFilters();
  }

  void clearFilters() {
    _filterPriority = null;
    _filterDate = null;
    applyFilters();
  }

  void applyFilters() {
    _filteredTasks = _allTasks.where((task) {
      final matchPriority = _filterPriority == null || task.priority == _filterPriority;
      final matchDate = _filterDate == null ||
          (task.dueDate.year == _filterDate!.year &&
              task.dueDate.month == _filterDate!.month &&
              task.dueDate.day == _filterDate!.day);
      return matchPriority && matchDate;
    }).toList();

    notifyListeners();
  }
}
