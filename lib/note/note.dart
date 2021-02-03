import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Note {

  int id;
  String title;
  String content;

  Note({this.id, @required this.title, @required this.content});

  @override
  String toString() => '{id: $id, title: $title, content: $content}';

}







