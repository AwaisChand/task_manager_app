import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_style.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';
import '../screens/add_edit_task_screen.dart';

class TaskCardWidget extends StatelessWidget {
  final Task task;
  final int index;
  final TaskProvider provider;
  final Animation<double> animation;

  const TaskCardWidget({
    super.key,
    required this.task,
    required this.index,
    required this.provider,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.vertical,
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.task_alt, color: AppColors.accent, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title, style: AppTextStyles.taskTitle),
                    const SizedBox(height: 4),
                    Text(task.description, style: AppTextStyles.taskDescription),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.getPriorityColor(task.priority),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            task.priority.name.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Due: ${task.dueDate.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
                    );
                  } else if (value == 'delete') {
                    provider.deleteTask(task.id);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              )
            ],
          ),
        ),
      ).animate().fade(duration: 500.ms).slideY(begin: 0.3, duration: 400.ms),
    );
  }
}
