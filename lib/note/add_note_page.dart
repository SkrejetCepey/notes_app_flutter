import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'note.dart';
import 'note_list_model.dart';

class AddNotePage extends StatelessWidget {

  final Note note;

  final NoteListModel model;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleTextEditingController = TextEditingController();
  final TextEditingController _contentTextEditingController = TextEditingController();

  AddNotePage({Key key, @required this.model, this.note}) : super(key: key) {
    if (note != null) {
      _titleTextEditingController.text = note.title;
      _contentTextEditingController.text = note.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<NoteListModel>(
      model: this.model,
      child: Scaffold(
        appBar: AppBar(
          title: note == null ? Text('Adding new note') : Text('Editing note'),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.title),
                title: TextFormField(
                  controller: _titleTextEditingController,
                  decoration: InputDecoration(hintText: 'title'),
                  validator: (String str) => str.isEmpty ? 'Insert title' : null,
                ),
              ),
              ListTile(
                leading: Icon(Icons.content_paste),
                title: TextFormField(
                  controller: _contentTextEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 8,
                  decoration: InputDecoration(hintText: 'content'),
                  validator: (String str) => str.isEmpty ? 'Insert content' : null,
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          child: Row(
            children: [
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
              Spacer(),
              ScopedModelDescendant<NoteListModel>(
                builder: (BuildContext context, Widget child, NoteListModel model) {
                  return FlatButton(
                    child: Text('Save'),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        if (note != null) {
                          model.update(Note(title: _titleTextEditingController.text,
                              content: _contentTextEditingController.text, id: note.id));
                        } else {
                          model.add(
                              Note(title: _titleTextEditingController.text,
                                  content: _contentTextEditingController.text));
                        }
                        Navigator.pop(context);
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}