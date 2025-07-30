import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/get_all_tasks.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';

class TaskProvider extends ChangeNotifier {
  final GetAllTasks _getAllTasks;
  final AddTask _addTask;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;

  TaskProvider({
    required GetAllTasks getAllTasks,
    required AddTask addTask,
    required UpdateTask updateTask,
    required DeleteTask deleteTask,
  })  : _getAllTasks = getAllTasks,
        _addTask = addTask,
        _updateTask = updateTask,
        _deleteTask = deleteTask;

  List<Task> _allTasks = [];
  List<Task> _filteredTasks = [];

  TaskPriority? _filterPriority;
  DateTime? _filterDate;

  List<Task> get tasks => _filteredTasks;
  TaskPriority? get filterPriority => _filterPriority;

  Future<void> loadTasks() async {
    _allTasks = await _getAllTasks();
    applyFilters();
  }

  Future<void> addTask(Task task) async {
    await _addTask(task);
    _allTasks.add(task);
    applyFilters();
  }

  Future<void> updateTask(Task task) async {
    await _updateTask(task);
    final index = _allTasks.indexWhere((t) => t.id == task.id);
    if (index != -1) _allTasks[index] = task;
    applyFilters();
  }

  Future<void> deleteTask(String id) async {
    await _deleteTask(id);
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
