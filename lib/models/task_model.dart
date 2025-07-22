class OfflineTaskModel {
  static const String tableName = 'OfflineTaskTable';

  // Column names
  static const String columnId = 'id';
  static const String columnTitle = 'title';
  static const String columnDescription = 'description';
  static const String columnDueDate = 'dueDate';
  static const String columnIsCompleted = 'isCompleted';

  int? id;
  String title;
  String description;
  DateTime? dueDate;
  bool isCompleted;

  OfflineTaskModel({
    this.id,
    required this.title,
    required this.description,
    this.dueDate,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      columnId: id,
      columnTitle: title,
      columnDescription: description,
      columnDueDate: dueDate?.millisecondsSinceEpoch,
      columnIsCompleted: isCompleted ? 1 : 0,
    };
  }

  factory OfflineTaskModel.fromMap(Map<String, dynamic> map) {
    return OfflineTaskModel(
      id: map[columnId],
      title: map[columnTitle],
      description: map[columnDescription],
      dueDate: map[columnDueDate] != null
          ? DateTime.fromMillisecondsSinceEpoch(map[columnDueDate])
          : null,
      isCompleted: map[columnIsCompleted] == 1,
    );
  }
}
