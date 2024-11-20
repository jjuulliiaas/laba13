import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'note_model.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _dbHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  Future<void> _addNote() async {
    if (_formKey.currentState!.validate()) {
      final newNote = Note(
        content: _noteController.text.trim(),
        date: DateTime.now().toIso8601String(),
      );
      await _dbHelper.addNote(newNote);
      _noteController.clear();
      _loadNotes();
    }
  }

  String formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    return DateFormat('dd.MM.yyyy, HH:mm:ss').format(dateTime);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text(
          'Notes App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _noteController,
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        labelText: 'Add note here...',
                        labelStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 11,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Note cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _addNote,
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _notes.isEmpty
                ? Center(child: Text('No notes yet'))
                : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 1.0,
                    horizontal: 20.0,
                  ),
                  child: Card(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(
                        note.content,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        formatDateTime(note.date),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Colors.lightGreen[800],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
