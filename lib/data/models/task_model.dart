import 'package:hive/hive.dart';
import '../../domain/entities/task.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final TaskPriority priority;

  @HiveField(4)
  final DateTime dueDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
  });

  Task toEntity() => Task(
    id: id,
    title: title,
    description: description,
    priority: priority,
    dueDate: dueDate,
  );

  static TaskModel fromEntity(Task task) => TaskModel(
    id: task.id,
    title: task.title,
    description: task.description,
    priority: task.priority,
    dueDate: task.dueDate,
  );
}
