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
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, AppConstants.databaseName);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${AppConstants.tableNotes}(
            ${AppConstants.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${AppConstants.columnTitle} TEXT NOT NULL,
            ${AppConstants.columnContent} TEXT NOT NULL
          )
        ''');
      },
    );
  }
}