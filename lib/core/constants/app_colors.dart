import 'package:flutter/material.dart';

import '../../domain/entities/task.dart';

class AppColors {
  static const Color primary = Color(0xFF66A6FF);
  static const Color secondary = Color(0xFF89F7FE);
  static const Color accent = Color(0xFF6C63FF);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color textDark = Color(0xFF222222);
  static const Color gray = Colors.grey;


  static Color getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.redAccent;
      case TaskPriority.medium:
        return Colors.orangeAccent;
      case TaskPriority.low:
        return Colors.green;
    }
  }


}
