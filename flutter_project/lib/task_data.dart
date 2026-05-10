class TaskModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String date;
  final String uid;
  final bool isCompleted;
  final String status;
  final String priority;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.uid,
    this.isCompleted = false,
    this.status = "To Do",
    this.priority = "Medium",
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "category": category,
      "date": date,
      "uid": uid,
      "isCompleted": isCompleted,
      "status": status,
      "priority": priority,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map["id"] ?? "",
      title: map["title"] ?? "",
      description: map["description"] ?? "",
      category: map["category"] ?? "",
      date: map["date"] ?? "",
      uid: map["uid"] ?? "",
      isCompleted: map["isCompleted"] ?? false,
      status: map["status"] ?? "To Do",
      priority: map["priority"] ?? "Medium",
    );
  }
}

List<TaskModel> allTasks = [];
