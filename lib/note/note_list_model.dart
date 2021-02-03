import 'package:scoped_model/scoped_model.dart';
import 'note_db_driver.dart';
import 'note.dart';

class NoteListModel extends Model {

  Future<List> get noteList {
    return NoteDBDriver.db.getAll();
  }

  Future<void> add(Note note) async {
    await NoteDBDriver.db.create(note);
    notifyListeners();
  }

  Future<void> update(Note note) async {
    await NoteDBDriver.db.update(note);
    notifyListeners();
  }

  Future<void> delete(Note note) async {
    await NoteDBDriver.db.delete(note.id);
    notifyListeners();
  }

}