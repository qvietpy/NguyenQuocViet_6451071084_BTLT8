import '../data/models/category_model.dart';
import '../data/repository/category_repository.dart';

class CategoryController {
  final CategoryRepository _repository = CategoryRepository();

  Future<List<CategoryModel>> fetchCategories() async {
    return await _repository.getCategories();
  }

  Future<void> addCategory(String name) async {
    final category = CategoryModel(name: name);
    await _repository.insertCategory(category);
  }
}