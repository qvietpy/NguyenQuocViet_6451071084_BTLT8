import '../data/models/task_model.dart';
import '../data/repository/task_repository.dart';

class TaskController {
  final TaskRepository _repository = TaskRepository();

  Future<List<TaskModel>> fetchTasks() async {
    return await _repository.getTasks();
  }

  Future<void> addTask(String title) async {
    final task = TaskModel(
      title: title,
      isDone: false,
    );

    await _repository.insertTask(task);
  }

  Future<void> toggleTask(TaskModel task) async {
    final updatedTask = task.copyWith(isDone: !task.isDone);
    await _repository.updateTask(updatedTask);
  }

  Future<void> deleteTask(int id) async {
    await _repository.deleteTask(id);
  }

  Future<String> exportTasks() async {
    return await _repository.exportTasks();
  }

  Future<void> importTasks() async {
    await _repository.importTasks();
  }
}