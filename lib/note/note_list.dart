import 'package:flutter/material.dart';
import 'add_note_page.dart';
import 'note.dart';
import 'note_list_model.dart';
import 'package:scoped_model/scoped_model.dart';

//exports statement
export 'note_list_model.dart';

enum NoteState {
  delete,
  edit
}

class NoteList extends StatelessWidget {

  final NoteListModel model;

  NoteList({Key key, this.model}) : super(key: key);

  Future<void> _deleteNote(BuildContext context, Note note) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete note ?'),
          content: Text('Are you sure about deleting ${note.content} ?'),
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
                model.delete(note);
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Icon switchIcon(Note note) {
    if (note.datetimeLimitations != null)
      return Icon(Icons.watch_later);
    else
      return Icon(Icons.note);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<NoteListModel>(
      model: model,
      child: ScopedModelDescendant<NoteListModel>(
        builder: (BuildContext context, Widget child, NoteListModel model) {
          return FutureBuilder<List>(
            future: model.noteList,
            builder: (context, snapshot) {
              Widget children;
              if (snapshot.hasData) {
                children = ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    Note note = snapshot.data[index];
                    return Container(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                      child: Card(
                        color: (note.datetimeLimitations == null) ? Colors.white : Colors.lightBlue,
                        elevation: 8.0,
                        child: ListTile(
                          title: Container(
                            child: Row(
                              children: [
                                switchIcon(note),
                                Text('${note.title}'),
                                Spacer(),
                                Text('${note.datetime}')
                              ],
                            ),
                          ),
                          subtitle: Text('${note.content}'),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                AddNotePage(model: model, note: note)));
                          },
                          onLongPress: () async {
                            var choose = await showMenu(context: context,
                                position: RelativeRect.fromLTRB(0, MediaQuery.of(context).size.height, MediaQuery.of(context).size.width, 0),
                                items: [
                                  PopupMenuItem(
                                    value: NoteState.delete,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.delete),
                                        Text("Delete"),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: NoteState.edit,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.edit),
                                        Text("Edit"),
                                      ],
                                    ),
                                  )
                                ]
                            );
                            switch (choose) {
                              case NoteState.edit:
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                    AddNotePage(model: model, note: note)));
                                break;
                              case NoteState.delete:
                                _deleteNote(context, note);
                                break;
                            }
                            print(choose);
                          },
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                children = Text('Sorry, something goes wrong!');
              }
              else {
                children = Column(
                    children: [
                      SizedBox(
                        child: CircularProgressIndicator(),
                        height: 60.0,
                        width: 60.0,
                      ),
                      Text('Connecting to database...')
                    ],
                );
              }
              return children;
            },
          );
        },
      ),
    );
  }
}