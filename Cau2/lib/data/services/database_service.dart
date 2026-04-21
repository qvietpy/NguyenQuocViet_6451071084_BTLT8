import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../utils/constants.dart';

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
    final path = join(dbPath, AppConstants.databaseName);

    return openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${AppConstants.tableCategories}(
            ${AppConstants.columnCategoryId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${AppConstants.columnCategoryName} TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE ${AppConstants.tableNotes}(
            ${AppConstants.columnNoteId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${AppConstants.columnNoteTitle} TEXT NOT NULL,
            ${AppConstants.columnNoteContent} TEXT NOT NULL,
            ${AppConstants.columnNoteCategoryId} INTEGER NOT NULL,
            FOREIGN KEY (${AppConstants.columnNoteCategoryId})
              REFERENCES ${AppConstants.tableCategories}(${AppConstants.columnCategoryId})
              ON DELETE CASCADE
          )
        ''');
      },
    );
  }
}