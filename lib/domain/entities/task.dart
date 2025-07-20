import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
enum TaskPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}

class Task {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final DateTime dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
  });
}
