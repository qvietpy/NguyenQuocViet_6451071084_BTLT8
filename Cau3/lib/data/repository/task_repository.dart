import 'package:sqflite/sqflite.dart';
import '../../utils/constants.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';
import '../services/file_service.dart';

class TaskRepository {
  final FileService _fileService = FileService();

  Future<List<TaskModel>> getTasks() async {
    final Database db = await DatabaseService.instance.database;

    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.tableTasks,
      orderBy: '${AppConstants.columnId} DESC',
    );

    return maps.map(TaskModel.fromMap).toList();
  }

  Future<int> insertTask(TaskModel task) async {
    final Database db = await DatabaseService.instance.database;
    return db.insert(AppConstants.tableTasks, task.toMap());
  }

  Future<int> updateTask(TaskModel task) async {
    final Database db = await DatabaseService.instance.database;
    return db.update(
      AppConstants.tableTasks,
      task.toMap(),
      where: '${AppConstants.columnId} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final Database db = await DatabaseService.instance.database;
    return db.delete(
      AppConstants.tableTasks,
      where: '${AppConstants.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearTasks() async {
    final Database db = await DatabaseService.instance.database;
    await db.delete(AppConstants.tableTasks);
  }

  Future<String> exportTasks() async {
    final tasks = await getTasks();
    return _fileService.exportTasksToJson(tasks);
  }

  Future<void> importTasks() async {
    final tasks = await _fileService.importTasksFromJson();

    await clearTasks();

    for (final task in tasks) {
      await insertTask(
        TaskModel(
          title: task.title,
          isDone: task.isDone,
        ),
      );
    }
  }
}