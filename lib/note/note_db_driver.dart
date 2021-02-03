import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDBDriver {

  //singleton
  NoteDBDriver._();
  static final NoteDBDriver db = NoteDBDriver._();

  Database _db;

  Future get database async {
    if (_db == null) {
      _db = await init();
    }
    return _db;
  }

  Future<Database> init() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    String path = p.join(docsDir.path, 'notes.db');
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS notes ('
              'id INTEGER PRIMARY KEY,'
              'title VARCHAR(200),'
              'content TEXT'
              ')'
        );
      },
    );
    return db;
  }

  Note noteFromMap(Map map) => Note(
    id: map['id'],
    title: map['title'],
    content: map['content']
  );

  Map<String, dynamic> noteToMap(Note note) => <String, dynamic>{
    'id' : note.id,
    'title' : note.title,
    'content' : note.content
  };

  Future<void> create(Note note) async {
    Database db = await database;

    int id = (await db.rawQuery('SELECT MAX(id) + 1 AS id FROM notes')).first['id'] ?? 1;

    print('Insert!');

    return await db.rawInsert(
      'INSERT INTO notes (id, title, content) VALUES (?, ?, ?)', [id, note.title, note.content]
    );
  }

  Future<Note> get(int id) async {
    Database db = await database;

    var n = await db.rawQuery('SELECT * FROM notes WHERE id = $id');

    return noteFromMap(n.single);
  }

  Future<List> getAll() async {
    Database db = await database;

    var notes = await db.rawQuery('SELECT * FROM notes');

    print(notes);

    return notes.isNotEmpty ? notes.map((e) => noteFromMap(e)).toList() : [];
  }

  Future<void> update(Note note) async {
    Database db = await database;

    return await db.update('notes', noteToMap(note), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> delete(int id) async {
    Database db = await database;

    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

}