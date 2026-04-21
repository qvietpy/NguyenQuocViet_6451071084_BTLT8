import '../../utils/constants.dart';

class CategoryModel {
  final int? id;
  final String name;

  CategoryModel({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      AppConstants.columnCategoryId: id,
      AppConstants.columnCategoryName: name,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map[AppConstants.columnCategoryId] as int?,
      name: map[AppConstants.columnCategoryName] as String? ?? '',
    );
  }
}