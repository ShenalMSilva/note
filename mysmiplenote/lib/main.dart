import 'package:flutter/material.dart';
import 'note.dart';
import 'note_database.dart';

void main() {
  runApp(NoteTakingApp());
}

class NoteTakingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Taking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesListPage(),
    );
  }
}

class NotesListPage extends StatefulWidget {
  @override
  _NotesListPageState createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  Future<void> _refreshNotes() async {
    notes = await NoteDatabase.instance.readAllNotes();
    setState(() {});
  }

  void _addNote() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteEditPage(
          onSave: (note) async {
            await NoteDatabase.instance.create(note);
            _refreshNotes();
          },
        ),
      ),
    );
  }

  void _editNote(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteEditPage(
          note: notes[index],
          onSave: (note) async {
            await NoteDatabase.instance.update(note);
            _refreshNotes();
          },
        ),
      ),
    );
  }

  void _deleteNote(int index) async {
    await NoteDatabase.instance.delete(notes[index].id!);
    _refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addNote,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notes[index].title),
            subtitle: Text(notes[index].content),
            onTap: () => _editNote(index),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteNote(index),
            ),
          );
        },
      ),
    );
  }
}

class NoteEditPage extends StatefulWidget {
  final Note? note;
  final Function(Note) onSave;

  NoteEditPage({this.note, required this.onSave});

  @override
  _NoteEditPageState createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController =
        TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final note = Note(
      id: widget.note?.id,
      title: _titleController.text,
      content: _contentController.text,
      createdTime: DateTime.now(),
    );
    widget.onSave(note);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
