import '../models/image_model.dart';
import '../services/database_service.dart';

class ImageRepository {
  Future<int> insert(ImageModel image) async {
    final db = await DatabaseService.instance.database;
    return db.insert('images', image.toMap());
  }

  Future<List<ImageModel>> getAll() async {
    final db = await DatabaseService.instance.database;
    final result = await db.query('images', orderBy: 'id DESC');
    return result.map((e) => ImageModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    final db = await DatabaseService.instance.database;
    return db.delete('images', where: 'id = ?', whereArgs: [id]);
  }
}