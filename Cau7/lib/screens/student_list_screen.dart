import 'package:flutter/material.dart';
import '../data/models/course_model.dart';
import '../data/models/student_model.dart';
import '../data/repository/course_repository.dart';
import '../data/repository/enrollment_repository.dart';
import '../data/repository/student_repository.dart';
import 'enrollment_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final StudentRepository _studentRepository = StudentRepository();
  final CourseRepository _courseRepository = CourseRepository();
  final EnrollmentRepository _enrollmentRepository = EnrollmentRepository();

  List<Student> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
    });

    final students = await _studentRepository.getAll();

    setState(() {
      _students = students;
      _isLoading = false;
    });
  }

  Future<void> _showAddStudentDialog() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm sinh viên'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Nhập tên sinh viên',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isEmpty) return;

                await _studentRepository.insert(Student(name: name));

                if (!mounted) return;
                Navigator.pop(context);
                _loadStudents();
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddCourseDialog() async {
    final controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm môn học'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Nhập tên môn học',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isEmpty) return;

                await _courseRepository.insert(Course(name: name));

                if (!mounted) return;
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã thêm môn học')),
                );
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openEnrollmentScreen(Student student) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EnrollmentScreen(student: student),
      ),
    );

    _loadStudents();
  }

  Future<void> _deleteStudent(int id) async {
    await _studentRepository.delete(id);
    await _loadStudents();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã xóa sinh viên')),
    );
  }

  Future<void> _confirmDeleteStudent(int id) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa sinh viên'),
        content: const Text('Bạn có chắc muốn xóa sinh viên này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    ) ??
        false;

    if (shouldDelete) {
      _deleteStudent(id);
    }
  }

  Future<String> _getStudentCoursesText(int studentId) async {
    final courses = await _enrollmentRepository.getCourseNamesByStudent(studentId);

    if (courses.isEmpty) {
      return 'Chưa đăng ký môn học';
    }

    return courses.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sinh viên - môn học - 6451071084'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showAddCourseDialog,
            icon: const Icon(Icons.menu_book),
            tooltip: 'Thêm môn học',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _students.isEmpty
          ? const Center(child: Text('Chưa có sinh viên nào'))
          : ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];

          return FutureBuilder<String>(
            future: _getStudentCoursesText(student.id!),
            builder: (context, snapshot) {
              final subtitle = snapshot.data ?? 'Đang tải...';

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  title: Text(
                    student.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(subtitle),
                  onTap: () => _openEnrollmentScreen(student),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDeleteStudent(student.id!),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStudentDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}