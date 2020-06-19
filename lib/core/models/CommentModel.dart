import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CommentModel {
  String id;
  String comment;
  String author;
  String date;
  String avatar;
  String parent;
  int likes;
  List<Widget> subcommentsWidgets = new List();
  List<Map> subcomments = new List();
  List<String> likesArr = new List();



  CommentModel.fromMap(Map snapshot)
      :
        comment = snapshot['comment'] ?? '',
        date = snapshot['date'] ?? '',
        author = snapshot['author'] ?? '',
        avatar = snapshot['avatar']!=null? "gs://fcnn-8e0f7.appspot.com/" + snapshot['avatar'] : '',

        likes = snapshot.containsKey('likes') ? List.from(snapshot['likes']).length : 0,
        id = snapshot.containsKey('id') ? snapshot['id'] : "",
        parent = snapshot.containsKey('parent') ? snapshot['parent'] : "",
        subcomments = snapshot.containsKey('subcomms') ? List.from(snapshot['subcomms']) : List(),
        likesArr = snapshot.containsKey('likes') ? List.from(snapshot['likes']) : List();


  static List<String> getLikesList (Map snapshot) {
    List <String> likesList =  snapshot.containsKey('likes') ? List.from(snapshot['likes']) : List();
    return likesList;
  }




  toJson() {
    return {
      "comment": comment,
      "author": author,
      "date": date,
      "avatar" : avatar,
      "id" : id,
      "likes" : likesArr,
      "parent" : parent
    };
  }

  @override
  String toString() {
    return 'CommentModel{comment: $comment, author: $author, date: $date, avatar: $avatar, subcommentsWidgets: $subcommentsWidgets}';
  }


}