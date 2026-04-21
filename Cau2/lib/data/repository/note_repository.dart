import 'package:sqflite/sqflite.dart';
import '../../utils/constants.dart';
import '../models/note_model.dart';
import '../services/database_service.dart';

class NoteRepository {
  Future<List<NoteModel>> getNotes({int? categoryId}) async {
    final Database db = await DatabaseService.instance.database;

    String sql = '''
      SELECT n.${AppConstants.columnNoteId},
             n.${AppConstants.columnNoteTitle},
             n.${AppConstants.columnNoteContent},
             n.${AppConstants.columnNoteCategoryId},
             c.${AppConstants.columnCategoryName} AS categoryName
      FROM ${AppConstants.tableNotes} n
      INNER JOIN ${AppConstants.tableCategories} c
      ON n.${AppConstants.columnNoteCategoryId} = c.${AppConstants.columnCategoryId}
    ''';

    List<dynamic> args = [];

    if (categoryId != null) {
      sql += ' WHERE n.${AppConstants.columnNoteCategoryId} = ?';
      args.add(categoryId);
    }

    sql += ' ORDER BY n.${AppConstants.columnNoteId} DESC';

    final List<Map<String, dynamic>> maps = await db.rawQuery(sql, args);
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
      where: '${AppConstants.columnNoteId} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final Database db = await DatabaseService.instance.database;
    return db.delete(
      AppConstants.tableNotes,
      where: '${AppConstants.columnNoteId} = ?',
      whereArgs: [id],
    );
  }
}