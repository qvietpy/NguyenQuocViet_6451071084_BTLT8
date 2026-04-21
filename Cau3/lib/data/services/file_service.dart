import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../utils/constants.dart';
import '../models/task_model.dart';

class FileService {
  Future<File> _getBackupFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/${AppConstants.backupFileName}');
  }

  Future<String> exportTasksToJson(List<TaskModel> tasks) async {
    final file = await _getBackupFile();
    final jsonString = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await file.writeAsString(jsonString);
    return file.path;
  }

  Future<List<TaskModel>> importTasksFromJson() async {
    final file = await _getBackupFile();

    if (!await file.exists()) {
      throw Exception('Không tìm thấy file backup');
    }

    final content = await file.readAsString();
    final List<dynamic> jsonData = jsonDecode(content);

    return jsonData
        .map((item) => TaskModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}