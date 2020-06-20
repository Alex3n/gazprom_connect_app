import 'package:date_format/date_format.dart';
import 'package:gazpromconnect/core/models/CommentModel.dart';
import 'package:gazpromconnect/core/models/CommentModel.dart';
import 'package:gazpromconnect/main.dart';
import 'package:gazpromconnect/ui/pages/IdeasDetailPage.dart';
import 'package:gazpromconnect/ui/widgets/CommentWidget.dart';
import 'package:gazpromconnect/ui/widgets/MyCard.dart';
import 'package:gazpromconnect/ui/widgets/RaisedGradientButton.dart';
import 'package:gazpromconnect/ui/widgets/myAppBar.dart';
import 'package:gazpromconnect/ui/widgets/myDropdownButton.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:gazpromconnect/ui/widgets/myImageWidget.dart';

import '../AddCommentPage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  int _likes;
  Color _color;

  Map<String, String> _eventsInfo;
  bool commentsBlocked = false;
  Map<String, List<CommentModel>> _commModelMap = new Map();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Container(
            padding: EdgeInsets.all(20),
            child: ListView(
                children: <Widget>[
                  Container(width: 300,
                    child: myGradientButton(context,
                      funk: () {
                        Navigator.of(context).pushNamed('/ideapage');
                      },
                      btnText: 'Добавить идею',
                    ),
                  ),
                  //                funk:() {
//                  Navigator.of(context).pushNamed('/ideapage');
//                },
//                btnText: Text('Добавить идею'),
                  Expanded(child: Container(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: store
                            .collection("ideas")
                            .orderBy("title")
                            .onSnapshot,
                        builder:
                            (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return new Text('Error: ${snapshot.error}');
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return new Text('Loading...');
                            default:
                              return new ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (BuildContext ctx, int index) {
                                    return GestureDetector(
                                      child: buildMYColumn(
                                          document: snapshot.data.docs
                                              .elementAt(index)),
                                      onTap: () {
                                        _handleTap(
                                          snapshot.data.docs.elementAt(index),
                                        );
                                      },
                                    );
                                  });
                          }
                        },
                      )
                  ),)

                ])));
  }


    void _handleTap(DocumentSnapshot document) {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IdeasDetailPage(document),
          ),
        );
      });
      print("taped");
    }



    String getDepsNames(List <dynamic> listDep) {
      String names = "";
      if (listDep != null)
        listDep.forEach((element) {
          names = names + element['title'] + " ";
        });
      if (names == "") names = "все";
      return names;
    }



    Widget buildMYColumn({DocumentSnapshot document}) {
      String imageUrl = document.data()['image'];
      return buildMyCardWithPaddingNotOnTap(Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  height: (imageUrl == null || imageUrl.isEmpty) ? 1.0 : 100,
                  child: (imageUrl == null || imageUrl.isEmpty)
                      ? Container()
                      : MyImageWidget(url: document.data()['image'])),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 1),
              child: new Text(
                document.data()['title'],
                style: new TextStyle(
                    fontSize: 20.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 4),
              child: Text(
                document.data()['description'],
                style: new TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto"),
              ),
            ),
            new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 0, 5),
                    child: new GestureDetector(
                      child: new Icon(Icons.star,
//                          custicon.MyFlutterApp.news,
                          color: Color(0xFFFF0000),
                          size: 22.0),
                      onTap: () {
                        /*_likeHandleTap(document);*/
                      },
                    ),
                  ),
                  new GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 8, 0),
                      child: new Text(
                        document.data()['like'].toString(),
                        style: new TextStyle(
                            fontSize: 14.0,
                            color: Color(0xFFFF0000),
                            fontWeight: FontWeight.w300,
                            fontFamily: "Roboto"),
                      ),
                    ),
                    onTap: () {
                      /*_likeHandleTap(document);*/
                    },
                  ),
                  new Text(
                    formatDate(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(document.data()['date'])),
                        [dd, '.', mm, '.', yyyy]),
                    style: new TextStyle(
                        fontSize: 14.0,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w300,
                        fontFamily: "Roboto"),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: new Text(
                      //todo подгрузка отделов
                      "отделы: " + getDepsNames(document.data()['departments']),
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.w300,
                          fontFamily: "Roboto"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: new Text(
                      document.data()['tags'].toString(),
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFFFF0000),
                          fontWeight: FontWeight.w300,
                          fontFamily: "Roboto"),
                    ),
                  ),
                ]),
            Container(
              height: 300,
              child: StreamBuilder<QuerySnapshot>(
                stream: store
                    .collection("ideas")
                    .doc(document.id)
                    .collection("solutions")
                    .onSnapshot,
                builder:
                    (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Text('Loading...');
                    default:
                      if (!snapshot.hasData) return Container();
                      if (snapshot.data.docs.isEmpty) return Container();
                      Map<String, bool> result = new Map();
                      snapshot.data.docs.forEach((doc) =>
                          result.putIfAbsent(doc.id,
                                  () {
                                if (doc.data()['like'] == null) {
                                  return false;
                                }
                                else
                                  return
                                    List.from(doc.data()['like']).contains(
                                        getUserId());
                              }
                            //     () => debugPrint("likesResultForEach:" + List.from(doc['like']).toString() +" " + _user.uid) as bool
                          ));

                      return new ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return GestureDetector(
                              child: buildSolutions(result,
                                document: snapshot.data.docs.elementAt(index),),
                              onTap: () {

                              },
                            );
                          });
                  }
                },
              )
              ,
            )


          ]));
    }


    Widget buildSolutions(Map<String, bool>
    result, {DocumentSnapshot document}) {
      Map<String, List<CommentModel>> _commModelMap = new Map();
      String imageUrl = document.data()['image'];
      List <String> listlikes = [];
      if (document.data()['like'] != null) {
        listlikes = document.data()['like'];
      }
      return buildMyCardWithPaddingNotOnTap(Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                  height: (imageUrl == null || imageUrl.isEmpty) ? 1.0 : 100,
                  child: (imageUrl == null || imageUrl.isEmpty)
                      ? Container()
                      : MyImageWidget(url: imageUrl)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                document.data()['description'].toString(),
                style: new TextStyle(
                    fontSize: 20.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Roboto"),
              ),
            ),
            new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new GestureDetector(
                    child: new Icon(Icons.favorite,
                        color: result[document.id]
                            ? Color(0xFFFF0000)
                            : Theme
                            .of(context)
                            .tabBarTheme
                            .unselectedLabelColor,
                        size: 24.0),
                    onTap: () {
                      _likeHandleTap(document, result);
                    },
                  ),
                  new GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: new Text(
                        listlikes.length.toString(),
                        style: new TextStyle(
                            fontSize: 14.0,
                            color: result[document.id]
                                ? Color(0xFFFF0000)
                                : Theme
                                .of(context)
                                .tabBarTheme
                                .unselectedLabelColor,
                            fontWeight: FontWeight.w300,
                            fontFamily: "Roboto"),
                      ),
                    ),
                    onTap: () {},
                  ),
//                commentsBlocked
//                    ? Container()
//                    : GestureDetector(
//                  child: Padding(
//                    padding:
//                    const EdgeInsets.fromLTRB(10.0, 10.0, 4.0, 10.0),
//                    child: new Icon(Icons.insert_comment,
//                        color: Theme.of(context)
//                            .tabBarTheme
//                            .unselectedLabelColor,
//                        size: 28.0),
//                  ),
//                  onTap: () {
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) =>
//                            AddCommentPage(document.id),
//                      ),
//                    );
//                  },
//                ),
//                commentsBlocked
//                    ? Container()
//                    : GestureDetector(
//                  child: Padding(
//                    padding: const EdgeInsets.only(right: 12.0),
//                    child: new Text(
//                      _commModelMap[document.id]
//                          .length
//                          .toString(),
//                      style: new TextStyle(
//                          fontSize: 14.0,
//                          color: Theme.of(context)
//                              .tabBarTheme
//                              .unselectedLabelColor,
//                          fontWeight: FontWeight.w300,
//                          fontFamily: "Roboto"),
//                    ),
//                  ),
//                  onTap: () {
//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) =>
//                            AddCommentPage(document.id),
//                      ),
//                    );
//                  },
//                ),
//                new Text(
//                  formatDate(
//                      DateTime.fromMillisecondsSinceEpoch(
//                          int.parse(document.data()['date'])),
//                      [dd, '.', mm, '.', yyyy]),
//                  style: new TextStyle(
//                      fontSize: 14.0,
//                      color: const Color(0xFF000000),
//                      fontWeight: FontWeight.w300,
//                      fontFamily: "Roboto"),
//                )
                ]),
//          _commModelMap[document.id].isNotEmpty
//              ? singleComment(
//              context, _commModelMap[document.id].first, true)
//              : Container(),
//          GestureDetector(
//            onTap: () {
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => CommentWidget(document.id,
//                      commentsBlocked: commentsBlocked),
//                ),
//              );
//            },
//            child: Text("Показать все комментарии (" +
//                _commModelMap[document.id].length.toString() +
//                ")"),
//          ),
          ]));
    }

    void _likeHandleTap(DocumentSnapshot document,
        Map<String, bool> result) async {
      setState(() {
        if (result[document.id]) {
          // уже сделал лайк
          result[document.id] = false;
          store.collection("news").doc(document.id).update(
              data: Map.from({
                "like": FieldValue.arrayRemove(List.unmodifiable([getUserId()]))
              }));
          _color = Color(0xFF000000);
          _likes = _likes - 1;
        } else {
          //не делал лайк
          result[document.id] = true;
          store.collection("news").doc(document.id).update(
              data: Map.from({
                "like": FieldValue.arrayUnion(List.unmodifiable([getUserId()]))
              }));
          _color = Color(0xFFFF0000);
          _likes = _likes + 1;
        }
      });
    }

}