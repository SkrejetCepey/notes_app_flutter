import 'package:scoped_model/scoped_model.dart';

class AddNotePageModel extends Model {

  String _dateTime;

  String get dateTime => _dateTime;

  bool isDateTimePicked() => _dateTime != null;

  set addDateTime(String dt) {
    _dateTime = dt;
    notifyListeners();
  }
}