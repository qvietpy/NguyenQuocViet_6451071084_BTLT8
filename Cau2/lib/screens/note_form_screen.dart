import 'package:flutter/material.dart';
import '../controllers/category_controller.dart';
import '../controllers/note_controller.dart';
import '../data/models/category_model.dart';
import '../data/models/note_model.dart';

class NoteFormScreen extends StatefulWidget {
  final NoteModel? note;

  const NoteFormScreen({super.key, this.note});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _noteController = NoteController();
  final _categoryController = CategoryController();
  final _formKey = GlobalKey<FormState>();

  List<CategoryModel> _categories = [];
  int? _selectedCategoryId;

  bool get isEdit => widget.note != null;

  @override
  void initState() {
    super.initState();
    _loadCategories();

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedCategoryId = widget.note!.categoryId;
    }
  }

  Future<void> _loadCategories() async {
    final categories = await _categoryController.fetchCategories();

    setState(() {
      _categories = categories;
      if (_selectedCategoryId == null && categories.isNotEmpty) {
        _selectedCategoryId = categories.first.id;
      }
    });
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) return;

    if (isEdit) {
      final updatedNote = widget.note!.copyWith(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        categoryId: _selectedCategoryId,
      );
      await _noteController.updateNote(updatedNote);
    } else {
      await _noteController.addNote(
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        categoryId: _selectedCategoryId!,
      );
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _deleteNote() async {
    if (widget.note?.id == null) return;

    await _noteController.deleteNote(widget.note!.id!);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category - 6451071084'),
        centerTitle: true,
        actions: [
          if (isEdit)
            IconButton(
              onPressed: _deleteNote,
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: _categories.isEmpty
          ? const Center(
        child: Text('Hãy tạo danh mục trước'),
      )
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                items: _categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Chọn danh mục',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    labelText: 'Nội dung',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập nội dung';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveNote,
                  child: Text(isEdit ? 'Cập nhật' : 'Lưu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}