import 'package:flutter/cupertino.dart';

class News {
  String id;
  String title;
  String description;
  String date;
  List<String> like;


  News(this.id, this.title, this.description, this.date, this.like);

  News.fromMap(Map snapshot, String id)
      :
        id = id ?? '',
        title = snapshot['title'] ?? '',
        description = snapshot['description'] ?? '',
        date = snapshot['date'] ?? '',
        like = List.from(snapshot['like']) ?? '';

  toJson() {
      return {
        "title": title,
        "description": description,
        "date": date,
        "like": like,
      };
    }

}