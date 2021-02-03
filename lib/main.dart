import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'note/note_list.dart';
import 'note/add_note_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage()
    );
  }

}

class HomePage extends StatelessWidget {

  final NoteListModel noteListModel = NoteListModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<NoteListModel>(
      model: noteListModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Scoped model notes app'),
        ),
        body: Center(
            child: NoteList(model: noteListModel)
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddNotePage(model: noteListModel)));
          },
        ),
      ),
    );
  }
}