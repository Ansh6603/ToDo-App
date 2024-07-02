class Task {
  String title;
  String description;
  DateTime date;
  int priority;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        'priority': priority,
        'isCompleted': isCompleted,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json['title'],
        description: json['description'],
        date: DateTime.parse(json['date']),
        priority: json['priority'],
        isCompleted: json['isCompleted'],
      );
}
