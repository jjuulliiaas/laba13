import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'note_model.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Note> get notes => _notes;

  NoteProvider() {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    _notes = await _dbHelper.getNotes();
    notifyListeners();
  }

  Future<void> addNote(String content) async {
    final newNote = Note(
      content: content,
      date: DateTime.now().toIso8601String(),
    );
    await _dbHelper.addNote(newNote);
    _loadNotes();
  }
}
