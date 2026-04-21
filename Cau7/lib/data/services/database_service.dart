import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._internal();
  static final DatabaseService instance = DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'student_course.db');

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE students(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE courses(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE enrollments(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            studentId INTEGER,
            courseId INTEGER,
            FOREIGN KEY(studentId) REFERENCES students(id) ON DELETE CASCADE,
            FOREIGN KEY(courseId) REFERENCES courses(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }
}