import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:gazpromconnect/MyScaffold.dart';
import 'package:gazpromconnect/core/models/CommentModel.dart';
import 'package:gazpromconnect/ui/AddCommentPage.dart';
import 'package:gazpromconnect/ui/widgets/CommentWidget.dart';
import 'package:gazpromconnect/ui/widgets/RaisedGradientButton.dart';
import 'package:gazpromconnect/ui/widgets/topTabBarSilver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

class NewsDetailPage extends StatefulWidget {
  String _title;
  String _description;
  String _image;
  String _date;
  String _likes;
  String _documentID;
  bool _liked;
  bool commentsBlocked;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NewsDetailState(
        _documentID, _title, _description, _image, _date, _likes, _liked);
  }

  NewsDetailPage(this._documentID, this._title, this._description, this._image,
      this._date, this._likes, this._liked,
      {this.commentsBlocked = false});
}

class NewsDetailState extends State<NewsDetailPage>
    with AutomaticKeepAliveClientMixin<NewsDetailPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _title;
  String _description;
  String _image;
  String _date;
  String _likes;
  String _documentID;
  bool _liked;
  Color _color;
  TextStyle textStyle;

  String _userId;
  bool _result;
  TabController tabController;
  List<CommentModel> _commentList = new List();

  NewsDetailState(this._documentID, this._title, this._description, this._image,
      this._date, this._likes, this._liked);

  void _getCurrentUser() async {
    debugPrint("setstate exec");
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    setState(() {
      _userId = firebaseUser.uid;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getComments(_documentID);
  }

  void _handleTap(String documentID) async {
    await _getCurrentUser();
    bool result = await _retrieveItems(Firestore.instance, documentID);
    setState(() {
      _result = result;
      if (result) {
        // уже сделал лайк
        _result = false;
        Firestore.instance
            .collection("news")
            .document(documentID)
            .updateData(Map.from({
              "like": FieldValue.arrayRemove(List.unmodifiable([_userId]))
            }));
        _color = Theme.of(context).tabBarTheme.unselectedLabelColor;
        _likes = (int.parse(_likes) - 1).toString();
      } else {
        //не делал лайк
        _result = true;
        Firestore.instance
            .collection("news")
            .document(documentID)
            .updateData(Map.from({
              "like": FieldValue.arrayUnion(List.unmodifiable([_userId]))
            }));
        _color = Color(0xFFFF0000);
        _likes = (int.parse(_likes) + 1).toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_liked != null && _liked) {
      textStyle = Theme.of(context).textTheme.caption;
      _color = Color(0xFFFF0000);
      _liked = null;
    } else if (_liked != null && !_liked) {
      textStyle = Theme.of(context).textTheme.bodyText2;
      _color = Theme.of(context).tabBarTheme.unselectedLabelColor;
      _liked = null;
    }
    // TODO: implement build
    return buildMyScaffold(
        context,
        MainCollapsingToolbar(
          pages: <Widget>[
            buildDateAndLikes(_documentID, _title, _description, _date, _likes)
          ],
          titleMain: "Новости",
          headers: [""],
          imageHeader: Image(
            image: FirebaseImage(_image),
            fit: BoxFit.fitWidth,
            width: 100,
          ),
        ),
        "Новости",
        bottomItemIndex: 0,
        isAppbar: false,
        indexdrawer: 1);
  }

  Widget buildDateAndLikes(String documentID, String title, String description,
      String date, String likes) {
    return SingleChildScrollView(
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                title,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                description,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 4.0, 10.0),
                      child: new Icon(Icons.access_alarms,
                          color: _color, size: 28.0),
                    ),
                    onTap: () {
                      _handleTap(documentID);
                    },
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: new Text(
                        likes,
                        style: textStyle,
                      ),
                    ),
                    onTap: () {
                      _handleTap(documentID);
                    },
                  ),
                  widget.commentsBlocked
                      ? Container()
                      : GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 4.0, 10.0),
                            child: new Icon(Icons.insert_comment,
                                color: Theme.of(context)
                                    .tabBarTheme
                                    .unselectedLabelColor,
                                size: 28.0),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddCommentPage(_documentID),
                              ),
                            );
                          },
                        ),
                  widget.commentsBlocked
                      ? Container()
                      : GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: new Text(
                              _commentList.length.toString(),
                              style: textStyle,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddCommentPage(_documentID),
                              ),
                            );
                          },
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      formatDate(
                          DateTime.fromMillisecondsSinceEpoch(int.parse(date)),
                          [dd, '.', mm, '.', yyyy]),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ]),
            _commentList.isNotEmpty
                ? singleComment(context, _commentList.first, false)
                : Container(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommentWidget(
                      _documentID,
                      commentsBlocked: widget.commentsBlocked,
                    ),
                  ),
                );
              },
              child: Text("Показать все комментарии (" +
                  _commentList.length.toString() +
                  ")"),
            ),
            widget.commentsBlocked
                ? Container()
                : Padding(
                    padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                    child: myGradientButton(context,
                        btnText: "Оставить комментарий", funk: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCommentPage(_documentID),
                        ),
                      );
                    }),
                  )
          ]),
    );
  }

  Future<bool> _retrieveItems(Firestore firestore, String newsId) async {
    var snapshot = await firestore.collection("news").document(newsId).get();
    List<String> likes = List.from(snapshot['like']);
    if (likes.contains(_userId)) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<CommentModel>> _getComments(String newsId) async {
    List<CommentModel> commModelList = new List();
    await Firestore.instance
        .collection("news")
        .document(_documentID)
        .collection("comments")
        .snapshots()
        .listen((snapshot) => snapshot.documents
            .forEach((i) => commModelList.add(CommentModel.fromMap(i.data))));
    debugPrint("comms:" + commModelList.toString());
    setState(() {
      _commentList = commModelList;
    });
    return commModelList;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
