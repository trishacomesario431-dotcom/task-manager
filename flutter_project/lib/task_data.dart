class TaskModel {
  final String title;
  final String description;
  final String category;
  final String date;

  TaskModel({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
  });
}

// GLOBAL TASK LIST
List<TaskModel> allTasks = [];