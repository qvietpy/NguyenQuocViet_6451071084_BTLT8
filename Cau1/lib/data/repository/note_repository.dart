import 'package:sqflite/sqflite.dart';
import '../../utils/constants.dart';
import '../models/note_model.dart';
import '../services/database_service.dart';

class NoteRepository {
  Future<List<NoteModel>> getNotes() async {
    final Database db = await DatabaseService.instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.tableNotes,
      orderBy: '${AppConstants.columnId} DESC',
    );

    return maps.map(NoteModel.fromMap).toList();
  }

  Future<int> insertNote(NoteModel note) async {
    final Database db = await DatabaseService.instance.database;
    return db.insert(AppConstants.tableNotes, note.toMap());
  }

  Future<int> updateNote(NoteModel note) async {
    final Database db = await DatabaseService.instance.database;
    return db.update(
      AppConstants.tableNotes,
      note.toMap(),
      where: '${AppConstants.columnId} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final Database db = await DatabaseService.instance.database;
    return db.delete(
      AppConstants.tableNotes,
      where: '${AppConstants.columnId} = ?',
      whereArgs: [id],
    );
  }
}