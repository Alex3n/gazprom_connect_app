import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:gazpromconnect/core/models/CommentModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../NewsPage.dart';
import '../AddCommentPage.dart';
import 'RaisedGradientButton.dart';

class CommentWidget extends StatefulWidget {
  String _documentID;

  bool commentsBlocked;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CommentWidgetState(_documentID);
  }

  CommentWidget(this._documentID, {this.commentsBlocked = false});
}

class CommentWidgetState extends State<CommentWidget> {
  List<Widget> _commentWidgetList = new List();
  String _documentID;

  CommentWidgetState(this._documentID);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _commentWidgetList = new List();
    setCommentsList();
  }

  void setCommentsList() async {
    Firestore.instance
        .collection("news")
        .document(_documentID)
        .collection("comments")
        .snapshots()
        .listen((snapshot) {
      List<Widget> commentWidgetList = new List();
      _commentWidgetList = new List();
      snapshot.documents.forEach((comment) {
        CommentModel commentModel = CommentModel.fromMap(comment.data);
        commentModel.id = comment.documentID;
        commentModel.subcomments.forEach((element) => commentModel
            .subcommentsWidgets
            .add(singleSubComment(context, CommentModel.fromMap(element))));
        Widget onTapWidget = new GestureDetector(
          child: Icon(Icons.access_alarm, color: Colors.red, size: 15),
          onTap: () => {tapLike(_documentID, commentModel.id)},
        );
        commentWidgetList.add(singleComment(context, commentModel, false,
            documentId: _documentID, onTapWidget: onTapWidget, enableAnswer: true, commentsBlocked: widget.commentsBlocked));
      });
      setState(() {
        _commentWidgetList = commentWidgetList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Padding addCommButton = Padding(
      padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      child:
      widget.commentsBlocked? Container() :  myGradientButton(context, btnText: "Оставить комментарий", funk: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => AddCommentPage(_documentID),
            ),
            (Route<dynamic> route) => false);
      }),
    );

    return Scaffold(
        body: Column(
          children: <Widget>[
             Expanded(
               child: Container(
                child: ListView(
                  children: _commentWidgetList,
                ),
            ),
             ),
            addCommButton
          ],
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Комментарии",
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
        ));
  }

  Widget singleSubComment(BuildContext context, CommentModel commentModel) {
    debugPrint("SUBCOMCOMMMODLOG" + commentModel.toString());
    return new Container(
      padding: EdgeInsets.fromLTRB(18.0, 5.0, 10.0, 5.0),
      child: new Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 20.0,
                backgroundImage: FirebaseImage(commentModel.avatar),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          commentModel.author + "   ",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          commentModel.date,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(commentModel.comment),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  GestureDetector(
                    child:
                        Icon(Icons.access_alarms, color: Colors.red, size: 15),
                    onTap: () => {
                      setState(() {
                        tapLike(_documentID, commentModel.parent,
                            subcommentId: commentModel.id);
                      })
                    },
                  ),
                  Text(commentModel.likesArr.length.toString(),
                      style: TextStyle(fontSize: 10))
                ],
              )
            ],
          ),
          Divider()
        ],
      ),
    );
  }

  void tapLike(String newsId, String commentId,
      {String subcommentId = ""}) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await firebaseAuth.currentUser();
    bool exist = false;
    exist = await existLike(newsId, commentId, subcommentId: subcommentId);
    debugPrint("EXISTS" + exist.toString());
    if (subcommentId != "") {
      DocumentSnapshot documentSnapshot = await Firestore.instance
          .collection("news")
          .document(newsId)
          .collection("comments")
          .document(commentId)
          .get();
      int i = 0;
      List<dynamic> listToUpdate = new List();
      List<dynamic> subCommsMap = documentSnapshot.data["subcomms"];
      debugPrint("documentSnapshot.data[subcomms]" +
          documentSnapshot.data["subcomms"].toString());
      subCommsMap.forEach((element) {
        CommentModel commentModel = CommentModel.fromMap(element);
        if (commentModel.id == subcommentId) {
          setState(() {
            exist
                ? commentModel.likesArr.remove(user.uid)
                : commentModel.likesArr.add(user.uid);
          });
        }
        listToUpdate.add(commentModel.toJson());
        i++;
      });
      Firestore.instance
          .collection("news")
          .document(newsId)
          .collection("comments")
          .document(commentId)
          .updateData(Map.from({"subcomms": listToUpdate}));
    } else {
      Firestore.instance
          .collection("news")
          .document(newsId)
          .collection("comments")
          .document(commentId)
          .updateData(Map.from({
            "likes": exist
                ? FieldValue.arrayRemove(List.unmodifiable([user.uid]))
                : FieldValue.arrayUnion(List.unmodifiable([user.uid]))
          }));
    }
    setCommentsList();
  }

  Future<bool> existLike(String newsId, String commentId,
      {String subcommentId = ""}) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    List likesList;
    FirebaseUser user = await firebaseAuth.currentUser();
    debugPrint("subcommentId" + subcommentId);
    debugPrint("user.uid " + user.uid);
    bool exist = false;
    if (subcommentId == "") {
      DocumentSnapshot documentSnapshot = await Firestore.instance
          .collection("news")
          .document(newsId)
          .collection("comments")
          .document(commentId)
          .get();
      if (documentSnapshot.data["likes"] != null)
        likesList = List.from(documentSnapshot.data["likes"]);

      if (likesList != null && likesList.contains(user.uid))
        exist = true;
      else
        exist = false;
    } else {
      DocumentSnapshot documentSnapshot = await Firestore.instance
          .collection("news")
          .document(newsId)
          .collection("comments")
          .document(commentId)
          .get();
      List.from(documentSnapshot.data["subcomms"]).forEach((element) {
        //     debugPrint("EXISTS?" + CommentModel.getLikesList(element).contains(user.uid).toString());
        if (CommentModel.getLikesList(element).contains(user.uid) &&
            CommentModel.fromMap(element).id == subcommentId) {
          exist = true;
          return;
        }
      });
    }
    return exist;
  }
}

Widget singleComment(
    BuildContext context, CommentModel commentModel, bool onMain,
    {String documentId, Widget onTapWidget, bool enableAnswer= false, bool commentsBlocked = false}) {
  debugPrint("COMMMODLOG" + commentModel.toString());


  return new Container(
    padding: onMain
        ? EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0)
        : EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
    child: new Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 30.0,
              backgroundImage: FirebaseImage(commentModel.avatar),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.0, 5.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        commentModel.author + "   ",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        commentModel.date,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(commentModel.comment),
                  ),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                onTapWidget != null
                    ? onTapWidget
                    : Icon(Icons.access_alarms, color: Colors.red, size: 15),
                Text(commentModel.likes.toString())
              ],
            )
          ],
        ),
        commentModel.subcommentsWidgets.isNotEmpty
            ? Column(
                children: commentModel.subcommentsWidgets,
              )
            : Container(),
        (enableAnswer && !commentsBlocked)
            ? answerButton(context, btnText: "Ответить", funk: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCommentPage(documentId,
                          commentId: commentModel.id),
                    ),
                    (Route<dynamic> route) => false);
              })
            : Container(),
        Divider()
      ],
    ),
  );
}

Widget answerButton(BuildContext context,
    {String btnText = " ", void Function() funk}) {
  return RaisedButton(
    onPressed: funk,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
    padding: const EdgeInsets.all(0.0),
    child: Ink(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        width: MediaQuery.of(context).size.width * 0.2,
//        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0, maxWidth: 123),
        // min sizes for Material buttons
        alignment: Alignment.center,
        child: Text(
          btnText,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 10),
        ),
      ),
    ),
  );
}
