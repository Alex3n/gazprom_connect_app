import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:gazpromconnect/MyScaffold.dart';
import 'package:gazpromconnect/NewsPage.dart';
import 'package:gazpromconnect/core/models/newsModel.dart';
import 'package:gazpromconnect/main.dart';
import 'package:gazpromconnect/ui/widgets/CommentWidget.dart';
import 'package:gazpromconnect/ui/widgets/MyCard.dart';
import 'package:gazpromconnect/ui/widgets/RaisedGradientButton.dart';
import 'package:gazpromconnect/ui/widgets/TextFieldPadding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


//import 'package:sticky_headers/sticky_headers.dart';

class AddCommentPage extends StatefulWidget {
  String newsId;
  String commentId;
  AddCommentPage (this.newsId, {this.commentId});

  @override
  _AddCommentPageState createState() => _AddCommentPageState(newsId, commentId: commentId);
}

class _AddCommentPageState extends State<AddCommentPage> {
  String newsId;
  String commentId;
  _AddCommentPageState (this.newsId, {this.commentId});

  TextEditingController commentController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  FirebaseUser user;
  Map dBuser;
  String photoURL;


  bool isNameValid = false;
  bool isEmailValid = false;

  Future getCurrentUser() async {
    firebaseAuth.currentUser().then((_user) {
      setState(() {
        user = _user;
      });
      Firestore.instance
          .collection("users")
          .document(_user.uid)
          .snapshots()
          .listen((data) {
        setState(() {
          user = _user;
        });
      }); }
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }



  Widget commentColumn(BuildContext context) {
    return Column(
      children: <Widget>[
        textFieldComment(fieldname: "Оставьте комментарий", controller: commentController),
        new Padding(
            padding: EdgeInsets.all(24),
            child: myGradientButton( context,
                btnText: "Написать",
                funk: () {
                  setState(() {
                    addComment(commentController.text, newsId);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentWidget(newsId),
                      ),
                            (Route<dynamic> route) => false
                    );
                  });
                })
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body:commentColumn(context),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text("Напишите комментарий",
            style: Theme.of(context).textTheme.headline6,
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsPage()),
              );
            },
          ),
      )
    );
  }


  void addComment(String comment, String newsId) async {

    String avatar =userdata["photoURL"] != null ? userdata["photoURL"] : "";
    String name = userdata["name"] != null ? userdata["name"] : "";
    String id = user.uid;
    commentId == null ? await firestore
        .collection("news")
        .document(newsId)
        .collection("comments")
        .document(DateTime.now().millisecondsSinceEpoch.toString())
        .setData(Map.from({
      "comment" : comment,
      "author" : name,
      "authorId" : id,
      "avatar" : avatar,
      "date" : formatDate(DateTime.now(), [  hh, ':', mm, ':', ss, ' ', dd, '.', mm, '.', yyyy]),
        }
      )
    ) : await firestore
        .collection("news")
        .document(newsId)
        .collection("comments")
        .document(commentId)
        .updateData(Map.from({
      "subcomms" : FieldValue.arrayUnion(List.unmodifiable([Map.from({
        "comment" : comment,
        "author" : name,
        "authorId" : id,
        "avatar" : avatar,
        "parent" : commentId,
        "id" : DateTime.now().millisecondsSinceEpoch.toString(),
        "date" : formatDate(DateTime.now(), [  hh, ':', mm, ':', ss, ' ', dd, '.', mm, '.', yyyy]
                      ),
                    }
                )
              ]
            )
          )
        })
    );
  }

  void buttonPressed() {}
}
