import 'package:hive/hive.dart';
import '../../domain/entities/task.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
enum TaskPriorityModel {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}

@HiveType(typeId: 2)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  TaskPriorityModel priority;

  @HiveField(4)
  DateTime dueDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
  });

  // Convert to Domain Entity
  Task toEntity() {
    return Task(
      id: id,
      title: title,
      description: description,
      priority: TaskPriority.values[priority.index],
      dueDate: dueDate,
    );
  }

  // Convert from Domain Entity
  static TaskModel fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: TaskPriorityModel.values[task.priority.index],
      dueDate: task.dueDate,
    );
  }
}
