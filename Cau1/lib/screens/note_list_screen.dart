import 'package:flutter/material.dart';
import '../controllers/note_controller.dart';
import '../data/models/note_model.dart';
import 'note_form_screen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final NoteController _noteController = NoteController();

  List<NoteModel> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
    });

    final notes = await _noteController.fetchNotes();

    setState(() {
      _notes = notes;
      _isLoading = false;
    });
  }

  Future<void> _openAddScreen() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const NoteFormScreen(),
      ),
    );

    if (result == true) {
      _loadNotes();
    }
  }

  Future<void> _openEditScreen(NoteModel note) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => NoteFormScreen(note: note),
      ),
    );

    if (result == true) {
      _loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes - 6451071084'),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
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
              note.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => _openEditScreen(note),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}