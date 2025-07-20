import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local_task_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalTaskDataSource localDataSource;

  TaskRepositoryImpl(this.localDataSource);

  @override
  Future<void> addTask(Task task) async {
    await localDataSource.addTask(TaskModel.fromEntity(task));
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDataSource.deleteTask(id);
  }

  @override
  Future<List<Task>> getAllTasks() async {
    final models = await localDataSource.getAllTasks();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> updateTask(Task task) async {
    await localDataSource.updateTask(TaskModel.fromEntity(task));
  }
}
