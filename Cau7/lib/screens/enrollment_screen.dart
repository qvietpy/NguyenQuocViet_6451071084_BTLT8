import 'package:flutter/material.dart';
import '../data/models/course_model.dart';
import '../data/models/enrollment_model.dart';
import '../data/models/student_model.dart';
import '../data/repository/course_repository.dart';
import '../data/repository/enrollment_repository.dart';

class EnrollmentScreen extends StatefulWidget {
  final Student student;

  const EnrollmentScreen({
    super.key,
    required this.student,
  });

  @override
  State<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen> {
  final CourseRepository _courseRepository = CourseRepository();
  final EnrollmentRepository _enrollmentRepository = EnrollmentRepository();

  List<Course> _courses = [];
  List<int> _selectedCourseIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    final courses = await _courseRepository.getAll();
    final selectedIds =
    await _enrollmentRepository.getCourseIdsByStudent(widget.student.id!);

    setState(() {
      _courses = courses;
      _selectedCourseIds = selectedIds;
      _isLoading = false;
    });
  }

  Future<void> _toggleEnrollment(int courseId, bool checked) async {
    if (checked) {
      await _enrollmentRepository.insert(
        Enrollment(
          studentId: widget.student.id!,
          courseId: courseId,
        ),
      );
    } else {
      await _enrollmentRepository.deleteByStudentAndCourse(
        widget.student.id!,
        courseId,
      );
    }

    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.student.name} - 6451071084'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _courses.isEmpty
          ? const Center(child: Text('Chưa có môn học nào'))
          : ListView.builder(
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];
          final isChecked = _selectedCourseIds.contains(course.id);

          return CheckboxListTile(
            title: Text(course.name),
            value: isChecked,
            onChanged: (value) {
              _toggleEnrollment(course.id!, value ?? false);
            },
          );
        },
      ),
    );
  }
}