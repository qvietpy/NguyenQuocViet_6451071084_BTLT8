import '../models/expense_model.dart';
import '../services/database_service.dart';

class ExpenseRepository {
  Future<int> insert(Expense expense) async {
    final db = await DatabaseService.instance.database;
    return db.insert('expenses', expense.toMap());
  }

  Future<int> update(Expense expense) async {
    final db = await DatabaseService.instance.database;
    return db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await DatabaseService.instance.database;
    return db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAllWithCategory({int? categoryId}) async {
    final db = await DatabaseService.instance.database;

    String sql = '''
      SELECT expenses.*, categories.name as categoryName
      FROM expenses
      JOIN categories ON expenses.categoryId = categories.id
    ''';

    List args = [];

    if (categoryId != null) {
      sql += ' WHERE expenses.categoryId = ?';
      args.add(categoryId);
    }

    sql += ' ORDER BY expenses.id DESC';

    return db.rawQuery(sql, args);
  }

  Future<double> getTotal({int? categoryId}) async {
    final db = await DatabaseService.instance.database;

    String sql = 'SELECT SUM(amount) as total FROM expenses';
    List args = [];

    if (categoryId != null) {
      sql += ' WHERE categoryId = ?';
      args.add(categoryId);
    }

    final result = await db.rawQuery(sql, args);

    return result.first['total'] == null
        ? 0
        : (result.first['total'] as num).toDouble();
  }
}