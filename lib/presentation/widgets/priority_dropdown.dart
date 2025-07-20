import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';

class PriorityDropdown extends StatelessWidget {
  final TaskPriority selected;
  final ValueChanged<TaskPriority?> onChanged;

  const PriorityDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.redAccent;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<TaskPriority>(
      value: selected,
      icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
      decoration: InputDecoration(
        labelText: "Priority",
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.priority_high, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black),
      items: TaskPriority.values.map((e) {
        return DropdownMenuItem<TaskPriority>(
          value: e,
          child: Row(
            children: [
              CircleAvatar(
                radius: 6,
                backgroundColor: _getPriorityColor(e),
              ),
              const SizedBox(width: 10),
              Text(
                e.name.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
