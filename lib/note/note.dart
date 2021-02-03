import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Note {

  int id;
  String title;
  String content;
  String datetime;
  String datetimeLimitations;

  Note({this.id, @required this.title, @required this.content, this.datetime, this.datetimeLimitations});

  @override
  String toString() => '{id: $id, title: $title, content: $content, datetime: $datetime, limit: $datetimeLimitations}\n';

}







