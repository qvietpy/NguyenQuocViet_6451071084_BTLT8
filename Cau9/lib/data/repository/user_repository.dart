import '../services/database_service.dart';
import '../models/user_model.dart';

class UserRepository {
  final DatabaseService _dbService = DatabaseService();

  Future<UserModel?> login(String email, String password) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }
}