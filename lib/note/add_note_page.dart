import 'package:NoteFlutterApp/note/add_note_page_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'note.dart';
import 'package:intl/intl.dart';
import 'note_list_model.dart';

class AddNotePage extends StatelessWidget {

  final Note note;

  final NoteListModel model;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleTextEditingController = TextEditingController();
  final TextEditingController _contentTextEditingController = TextEditingController();

  final AddNotePageModel addNotePageModel = AddNotePageModel();

  AddNotePage({Key key, @required this.model, this.note}) : super(key: key) {
    if (note != null) {
      _titleTextEditingController.text = note.title;
      _contentTextEditingController.text = note.content;
      addNotePageModel.addDateTime = note.datetimeLimitations;
    }
  }

  @override
  Widget build(BuildContext context) {

    Future<String> _selectTimeDate(BuildContext context) async {
      final DateTime pickedDate = await showDatePicker(context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.utc(2000, 0, 0), 
          lastDate: DateTime.now().add(Duration(days: 50)));
      final TimeOfDay pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());

      return "${DateFormat('yyyy-MM-dd').format(pickedDate)} ${pickedTime.hour}:${pickedTime.minute}";
    }

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
              ),
              ScopedModel<AddNotePageModel>(
                model: addNotePageModel,
                child: ScopedModelDescendant<AddNotePageModel>(
                  builder: (BuildContext context, Widget child, AddNotePageModel model) {
                    return ListTile(
                      leading: Icon(Icons.access_time),
                      tileColor: (model.isDateTimePicked()) ? Colors.lightGreen : Colors.white,
                      title: Builder(
                        builder: (BuildContext context) {
                          if (!model.isDateTimePicked()) {
                            return Row(
                              children: [
                                FlatButton(
                                  child: Text('Set a time limits'),
                                  onPressed: () async {
                                    model.addDateTime = await _selectTimeDate(context);
                                  },
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              children: [
                                FlatButton(
                                  child: Text('${model.dateTime}'),
                                  onPressed: () async {
                                    model.addDateTime = await _selectTimeDate(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text('Delete'),
                                  onPressed: () async {
                                    return await showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Remove picked date and time ?'),
                                          content: Text('Are you sure about removing date and time ?'),
                                          actions: [
                                            FlatButton(
                                              child: Text('Cancel!'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            FlatButton(
                                              child: Text('Delete'),
                                              onPressed: () {
                                                model.addDateTime = null;
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                )
                              ],
                            );
                          }
                        },
                      ),
                    );
                  },
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
                              content: _contentTextEditingController.text, id: note.id, datetimeLimitations: addNotePageModel.dateTime));
                        } else {
                          model.add(
                              Note(title: _titleTextEditingController.text,
                                  content: _contentTextEditingController.text, datetimeLimitations: addNotePageModel.dateTime));
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