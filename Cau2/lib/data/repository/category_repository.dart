import 'package:sqflite/sqflite.dart';
import '../../utils/constants.dart';
import '../models/category_model.dart';
import '../services/database_service.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getCategories() async {
    final Database db = await DatabaseService.instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.tableCategories,
      orderBy: '${AppConstants.columnCategoryId} DESC',
    );

    return maps.map(CategoryModel.fromMap).toList();
  }

  Future<int> insertCategory(CategoryModel category) async {
    final Database db = await DatabaseService.instance.database;
    return db.insert(AppConstants.tableCategories, category.toMap());
  }
}