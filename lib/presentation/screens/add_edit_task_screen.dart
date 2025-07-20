import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_style.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/priority_dropdown.dart';
import '../widgets/text_input_field.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title, _description;
  TaskPriority _priority = TaskPriority.low;
  DateTime _dueDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _priority = widget.task!.priority;
      _dueDate = widget.task!.dueDate;
    } else {
      _title = '';
      _description = '';
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final task = Task(
        id: widget.task?.id ?? const Uuid().v4(),
        title: _title,
        description: _description,
        priority: _priority,
        dueDate: _dueDate,
      );

      final provider = context.read<TaskProvider>();
      widget.task == null ? provider.addTask(task) : provider.updateTask(task);

      Navigator.pop(context, task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          widget.task == null ? '➕ Add Task' : '✏️ Edit Task',
          style: AppTextStyles.heading.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.secondary, AppColors.primary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.task == null
                          ? "Create a New Task"
                          : "Update Your Task",
                      style: AppTextStyles.heading.copyWith(
                        fontSize: 20.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),

                  ///For reusability if needed
                  CustomTextInput(
                    label: 'Title',
                    icon: Icons.title,
                    initialValue: _title,
                    onSaved: (val) => _title = val!,
                    validator:
                        (val) =>
                            val == null || val.isEmpty
                                ? 'Title cannot be empty'
                                : null,
                  ),

                  SizedBox(height: 17.sp),
                  CustomTextInput(
                    label: 'Description',
                    icon: Icons.description,
                    initialValue: _description,
                    onSaved: (val) => _description = val!,
                    maxLines: 3,
                  ),
                  SizedBox(height: 17.sp),

                  ///For reusability if needed
                  PriorityDropdown(
                    selected: _priority,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _priority = val);
                      }
                    },
                  ),

                  SizedBox(height: 17.sp),
                  Row(
                    children: [
                      Text(
                        "Due Date: ${_dueDate.toLocal().toString().split(' ')[0]}",
                        style: AppTextStyles.taskDescription.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _dueDate,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              _dueDate = picked;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.calendar_today,
                          size: 18.sp,
                          color: AppColors.white,
                        ),
                        label: Text("Pick Date", style: AppTextStyles.button),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  CustomButton(
                    label: widget.task == null ? "Add Task" : "Update Task",
                    icon: Icons.save,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
