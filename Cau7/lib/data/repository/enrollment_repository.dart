import '../models/enrollment_model.dart';
import '../services/database_service.dart';

class EnrollmentRepository {
  Future<int> insert(Enrollment enrollment) async {
    final db = await DatabaseService.instance.database;

    final existing = await db.query(
      'enrollments',
      where: 'studentId = ? AND courseId = ?',
      whereArgs: [enrollment.studentId, enrollment.courseId],
    );

    if (existing.isNotEmpty) {
      return 0;
    }

    return db.insert('enrollments', enrollment.toMap());
  }

  Future<int> deleteByStudentAndCourse(int studentId, int courseId) async {
    final db = await DatabaseService.instance.database;
    return db.delete(
      'enrollments',
      where: 'studentId = ? AND courseId = ?',
      whereArgs: [studentId, courseId],
    );
  }

  Future<List<int>> getCourseIdsByStudent(int studentId) async {
    final db = await DatabaseService.instance.database;

    final result = await db.query(
      'enrollments',
      where: 'studentId = ?',
      whereArgs: [studentId],
    );

    return result.map((e) => e['courseId'] as int).toList();
  }

  Future<List<String>> getCourseNamesByStudent(int studentId) async {
    final db = await DatabaseService.instance.database;

    final result = await db.rawQuery('''
      SELECT courses.name
      FROM enrollments
      JOIN courses ON enrollments.courseId = courses.id
      WHERE enrollments.studentId = ?
      ORDER BY courses.name ASC
    ''', [studentId]);

    return result.map((e) => e['name'] as String).toList();
  }
}