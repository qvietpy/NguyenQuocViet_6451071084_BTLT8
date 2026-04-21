import '../../utils/constants.dart';

class TaskModel {
  final int? id;
  final String title;
  final bool isDone;

  TaskModel({
    this.id,
    required this.title,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    return {
      AppConstants.columnId: id,
      AppConstants.columnTitle: title,
      AppConstants.columnIsDone: isDone ? 1 : 0,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map[AppConstants.columnId] as int?,
      title: map[AppConstants.columnTitle] as String? ?? '',
      isDone: (map[AppConstants.columnIsDone] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int?,
      title: json['title'] as String? ?? '',
      isDone: json['isDone'] as bool? ?? false,
    );
  }

  TaskModel copyWith({
    int? id,
    String? title,
    bool? isDone,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}