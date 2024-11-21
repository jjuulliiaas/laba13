import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/note_provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.green[800],
        title: Text(
          'Notes App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<NoteProvider>(context, listen: false)
                            .addNote(_noteController.text.trim());
                        _noteController.clear();
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<NoteProvider>(
              builder: (context, noteProvider, child) {
                final notes = noteProvider.notes;
                if (notes.isEmpty) {
                  return Center(child: Text('No notes yet'));
                }
                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1.0, horizontal: 20.0),
                      child: Card(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            note.content,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            DateFormat('dd.MM.yyyy, HH:mm:ss').format(
                                DateTime.parse(note.date).toLocal()),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Colors.lightGreen[800]),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
