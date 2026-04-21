import '../data/models/note_model.dart';
import '../data/repository/note_repository.dart';

class NoteController {
  final NoteRepository _repository = NoteRepository();

  Future<List<NoteModel>> fetchNotes() async {
    return await _repository.getNotes();
  }

  Future<void> addNote({
    required String title,
    required String content,
  }) async {
    final note = NoteModel(
      title: title,
      content: content,
    );

    await _repository.insertNote(note);
  }

  Future<void> updateNote(NoteModel note) async {
    await _repository.updateNote(note);
  }

  Future<void> deleteNote(int id) async {
    await _repository.deleteNote(id);
  }
}