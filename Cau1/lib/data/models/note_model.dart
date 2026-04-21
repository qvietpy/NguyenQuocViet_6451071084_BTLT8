import '../../utils/constants.dart';

class NoteModel {
  final int? id;
  final String title;
  final String content;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      AppConstants.columnId: id,
      AppConstants.columnTitle: title,
      AppConstants.columnContent: content,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map[AppConstants.columnId] as int?,
      title: map[AppConstants.columnTitle] as String? ?? '',
      content: map[AppConstants.columnContent] as String? ?? '',
    );
  }

  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}