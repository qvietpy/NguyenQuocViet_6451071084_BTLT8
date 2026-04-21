import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../data/models/task_model.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskController _taskController = TaskController();
  final TextEditingController _taskControllerText = TextEditingController();

  List<TaskModel> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    final tasks = await _taskController.fetchTasks();

    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> _showAddTaskDialog() async {
    _taskControllerText.clear();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm task'),
          content: TextField(
            controller: _taskControllerText,
            decoration: const InputDecoration(
              hintText: 'Nhập tên task',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                final title = _taskControllerText.text.trim();
                if (title.isEmpty) return;

                await _taskController.addTask(title);

                if (!mounted) return;
                Navigator.pop(context);
                _loadTasks();
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _toggleTask(TaskModel task) async {
    await _taskController.toggleTask(task);
    _loadTasks();
  }

  Future<void> _deleteTask(int id) async {
    await _taskController.deleteTask(id);
    _loadTasks();
  }

  Future<void> _exportTasks() async {
    try {
      final path = await _taskController.exportTasks();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã export ra: $path')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export lỗi: $e')),
      );
    }
  }

  Future<void> _importTasks() async {
    try {
      await _taskController.importTasks();
      await _loadTasks();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Import thành công')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Import lỗi: $e')),
      );
    }
  }

  @override
  void dispose() {
    _taskControllerText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup JSON - 6451071084'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _exportTasks,
            icon: const Icon(Icons.upload_file),
            tooltip: 'Export',
          ),
          IconButton(
            onPressed: _importTasks,
            icon: const Icon(Icons.download),
            tooltip: 'Import',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _tasks.isEmpty
          ? const Center(
        child: Text('Chưa có task nào'),
      )
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];

          return CheckboxListTile(
            value: task.isDone,
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            secondary: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTask(task.id!),
            ),
            onChanged: (_) => _toggleTask(task),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}