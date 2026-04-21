import '../models/category_model.dart';
import '../services/database_service.dart';

class CategoryRepository {
  Future<int> insert(Category category) async {
    final db = await DatabaseService.instance.database;
    return db.insert('categories', category.toMap());
  }

  Future<List<Category>> getAll() async {
    final db = await DatabaseService.instance.database;
    final result = await db.query('categories');
    return result.map((e) => Category.fromMap(e)).toList();
  }
}