import 'package:flutter/material.dart';
import '../controllers/category_controller.dart';
import '../controllers/note_controller.dart';
import '../data/models/category_model.dart';
import '../data/models/note_model.dart';
import 'category_form_screen.dart';
import 'note_form_screen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final NoteController _noteController = NoteController();
  final CategoryController _categoryController = CategoryController();

  List<NoteModel> _notes = [];
  List<CategoryModel> _categories = [];
  int? _selectedCategoryId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() {
      _isLoading = true;
    });

    final categories = await _categoryController.fetchCategories();
    final notes = await _noteController.fetchNotes(
      categoryId: _selectedCategoryId,
    );

    setState(() {
      _categories = categories;
      _notes = notes;
      _isLoading = false;
    });
  }

  Future<void> _filterNotes(int? categoryId) async {
    setState(() {
      _selectedCategoryId = categoryId;
      _isLoading = true;
    });

    final notes = await _noteController.fetchNotes(categoryId: categoryId);

    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  Future<void> _openAddCategory() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const CategoryFormScreen(),
      ),
    );

    if (result == true) {
      _loadAllData();
    }
  }

  Future<void> _openAddNote() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const NoteFormScreen(),
      ),
    );

    if (result == true) {
      _loadAllData();
    }
  }

  Future<void> _openEditNote(NoteModel note) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => NoteFormScreen(note: note),
      ),
    );

    if (result == true) {
      _loadAllData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category - 6451071084'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _openAddCategory,
            icon: const Icon(Icons.category),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<int?>(
              value: _selectedCategoryId,
              decoration: const InputDecoration(
                labelText: 'Lọc theo danh mục',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Tất cả danh mục'),
                ),
                ..._categories.map((category) {
                  return DropdownMenuItem<int?>(
                    value: category.id,
                    child: Text(category.name),
                  );
                }),
              ],
              onChanged: (value) {
                _filterNotes(value);
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _notes.isEmpty
                ? const Center(
              child: Text('Chưa có ghi chú nào'),
            )
                : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];

                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(
                    '${note.categoryName ?? ''}\n${note.content}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  isThreeLine: true,
                  onTap: () => _openEditNote(note),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}