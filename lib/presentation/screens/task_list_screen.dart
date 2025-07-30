import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_style.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'add_edit_task_screen.dart';
import 'calendar_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final tasks = provider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text("📝 Task Manager", style: AppTextStyles.heading),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month, color: AppColors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CalendarScreen()),
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        margin: EdgeInsets.only(top: 12.h),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.secondary, AppColors.primary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white54),
                ),
                child: Row(
                  children: [
                    Icon(Icons.filter_list, color: AppColors.white),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<TaskPriority?>(
                          value: provider.filterPriority,
                          isExpanded: true,
                          hint: const Text(
                            "Filter by Priority",
                            style: TextStyle(color: AppColors.white),
                          ),
                          dropdownColor: Colors.white,
                          style: const TextStyle(color: Colors.black),
                          iconEnabledColor: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text("All"),
                            ),
                            ...TaskPriority.values.map(
                              (priority) => DropdownMenuItem(
                                value: priority,
                                child: Text(priority.name.toUpperCase()),
                              ),
                            ),
                          ],
                          onChanged: provider.filterByPriority,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      tooltip: "Clear Filter",
                      onPressed: provider.clearFilters,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child:
                  tasks.isEmpty
                      ? const Center(
                        child: Text(
                          "You have no tasks yet.",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: tasks.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return TaskCardWidget(
                            task: task,
                            index: index,
                            provider: provider,
                            animation: kAlwaysCompleteAnimation,
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditTaskScreen()),
          );
        },
        child: Icon(Icons.add, color: AppColors.white, size: 22.sp),
      ),
    );
  }

  Widget _buildAnimatedTaskCard(
    BuildContext context,
    Task task,
    int index,
    TaskProvider provider,
    Animation<double> animation,
  ) {
    return SizeTransition(
      sizeFactor: animation,
      axis: Axis.vertical,
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.task_alt, color: AppColors.accent, size: 30),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: AppTextStyles.taskTitle.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      style: AppTextStyles.taskDescription,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.getPriorityColor(task.priority),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            task.priority.name.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Due: ${task.dueDate.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
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
                      MaterialPageRoute(
                        builder: (_) => AddEditTaskScreen(task: task),
                      ),
                    );
                  } else if (value == 'delete') {
                    _removeTaskAnimated(provider, task, index);
                  }
                },
                itemBuilder:
                    (context) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
              ),
            ],
          ),
        ),
      ).animate().fade(duration: 500.ms).slideY(begin: 0.3, duration: 400.ms),
    );
  }

  void _removeTaskAnimated(TaskProvider provider, Task task, int index) {
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => TaskCardWidget(
        task: task,
        index: index,
        provider: provider,
        animation: animation,
      ),
      duration: const Duration(milliseconds: 400),
    );
    provider.deleteTask(task.id);
  }
}
