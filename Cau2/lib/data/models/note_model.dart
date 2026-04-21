import '../../utils/constants.dart';

class NoteModel {
  final int? id;
  final String title;
  final String content;
  final int categoryId;
  final String? categoryName;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.categoryId,
    this.categoryName,
  });

  Map<String, dynamic> toMap() {
    return {
      AppConstants.columnNoteId: id,
      AppConstants.columnNoteTitle: title,
      AppConstants.columnNoteContent: content,
      AppConstants.columnNoteCategoryId: categoryId,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map[AppConstants.columnNoteId] as int?,
      title: map[AppConstants.columnNoteTitle] as String? ?? '',
      content: map[AppConstants.columnNoteContent] as String? ?? '',
      categoryId: map[AppConstants.columnNoteCategoryId] as int? ?? 0,
      categoryName: map['categoryName'] as String?,
    );
  }

  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    int? categoryId,
    String? categoryName,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}