import '../models/course_model.dart';
import '../services/database_service.dart';

class CourseRepository {
  Future<int> insert(Course course) async {
    final db = await DatabaseService.instance.database;
    return db.insert('courses', course.toMap());
  }

  Future<List<Course>> getAll() async {
    final db = await DatabaseService.instance.database;
    final result = await db.query(
      'courses',
      orderBy: 'id DESC',
    );

    return result.map((e) => Course.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    final db = await DatabaseService.instance.database;
    return db.delete(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}