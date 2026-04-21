import 'package:flutter/material.dart';
import '../controllers/note_controller.dart';
import '../data/models/note_model.dart';

class NoteFormScreen extends StatefulWidget {
  final NoteModel? note;

  const NoteFormScreen({
    super.key,
    this.note,
  });

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final NoteController _noteController = NoteController();

  bool get isEdit => widget.note != null;

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (isEdit) {
      final updatedNote = widget.note!.copyWith(
        title: title,
        content: content,
      );
      await _noteController.updateNote(updatedNote);
    } else {
      await _noteController.addNote(
        title: title,
        content: content,
      );
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _deleteNote() async {
    if (widget.note?.id == null) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa ghi chú'),
          content: const Text('Bạn có chắc muốn xóa ghi chú này không?'),
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
        );
      },
    );

    if (shouldDelete != true) return;

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
        title: Text(isEdit ? 'Chi tiết ghi chú' : 'Thêm ghi chú'),
        actions: [
          if (isEdit)
            IconButton(
              onPressed: _deleteNote,
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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