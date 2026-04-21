import '../models/student_model.dart';
import '../services/database_service.dart';

class StudentRepository {
  Future<int> insert(Student student) async {
    final db = await DatabaseService.instance.database;
    return db.insert('students', student.toMap());
  }

  Future<List<Student>> getAll() async {
    final db = await DatabaseService.instance.database;
    final result = await db.query(
      'students',
      orderBy: 'id DESC',
    );

    return result.map((e) => Student.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    final db = await DatabaseService.instance.database;
    return db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}