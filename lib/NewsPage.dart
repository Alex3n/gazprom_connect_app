import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:gazpromconnect/NewsDetailPage.dart';
import 'package:gazpromconnect/core/models/MatchModel.dart';
import 'package:gazpromconnect/core/funcs.dart';
import 'package:gazpromconnect/ui/AddCommentPage.dart';
import 'package:gazpromconnect/ui/widgets/CommentWidget.dart';
import 'package:gazpromconnect/ui/widgets/MacthInfoWidget.dart';
import 'package:gazpromconnect/ui/widgets/MyCard.dart';
import 'package:gazpromconnect/ui/widgets/RaisedGradientButton.dart';
import 'package:gazpromconnect/ui/widgets/TextFieldPadding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'MyScaffold.dart';
import 'SignInPage.dart';
import 'core/models/CommentModel.dart';
import 'main.dart';

class NewsPage extends StatefulWidget {
  String uid;

  NewsPage({Key key, this.uid}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController commentController = new TextEditingController();

  FirebaseUser _user = user;
  int _likes;
  Color _color;
  Map<String, bool> _result;
  Map<String, String> _eventsInfo;
  MatchModel _nearestMatch;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;
  Map<String, List<CommentModel>> _commModelMap = new Map();
  bool commentsBlocked = false;

  @override
  void initState() {
    super.initState();
    _getComments();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
    _fcm.subscribeToTopic('newMatch');

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    getCurrentUser();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void getCurrentUser() async {
    getNearest().then((nearestMatch) {
      setState(() {
        _nearestMatch = nearestMatch;
      });
    });
    _getLikesResult().then((res) {
      setState(() {
        _result = res;
      });
    });
    _saveDeviceToken();
    getEventsInfo();
    firestore.collection("users").document(user.uid).get().then((value) {
      userdata = value.data;
      if (userdata["commentsBlocked"] == null) {
        setState(() {
          commentsBlocked = false;
        });
      } else {
        setState(() {
          commentsBlocked = userdata["commentsBlocked"];
          ;
        });
      }
    });
  }

  void getEventsInfo() async {
    Map<String, String> eventsInfo = await _setEventsInfo();
    setState(() {
      _eventsInfo = eventsInfo;
    });
  }

  get iconButtonPressed => null;

  get buttonPressed => null;

  Widget sponsorWidget(BuildContext context) {
    return buildMyCardWithPadding(
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(image: FirebaseImage(_eventsInfo["imageSponsor"])),
          Align(
              child: new FlatButton(
                  onPressed: () async {
                    String url = _eventsInfo["siteSponsor"];
                    launchUrl(url);
                  },
                  child: Text("Перейти на сайт"),
                  color: Colors.red,
                  textColor: Colors.white))
        ],
      ),
    );
  }

  Widget actionWidget(BuildContext context) {
    return buildMyCardWithPadding(
        Image(image: FirebaseImage(_eventsInfo["imageAction"])));
  }

  Widget mainNews(BuildContext context) {
    return new Container(
        height: MediaQuery.of(context).size.height *
            (MediaQuery.of(context).size.height > 700 ? 0.48 : 0.55),
        child: _eventsInfo == null
            ? new Text('Загрузка...')
            : new Swiper(
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0)
                    return matchInfoContentOnMain(
                        context,
                        _nearestMatch.date,
                        _nearestMatch.awayTeam,
                        _nearestMatch.homeTeam,
                        _nearestMatch.round,
                        _nearestMatch.awayLogo,
                        _nearestMatch.homeLogo);
                  else if (index == 1)
                    return sponsorWidget(context);
                  else
                    return actionWidget(context);
                },
                itemCount: 3,
                viewportFraction: 0.9,
                scale: 0.85,
                pagination: new SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.grey,
                        size: 10,
                        activeSize: 15,
                        activeColor: Colors.red),
                    margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0)),
              ));
  }

  @override
  Widget build(BuildContext context) {
//    расскоментить чтобы работала авторизация
    if (_user == null) {
      return PhoneLogin();
    }

    return buildMyScaffold(context, buildNewsPage(context), "Новости",
        isNeedBottomBar: true);
  }

  void _handleTap(String documentID, String title, String description,
      String image, String date, String like, String comments) {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetailPage(documentID, title, description,
              image, date, like, _result[documentID],
              commentsBlocked: commentsBlocked),
        ),
      );
    });
  }

  void _likeHandleTap(DocumentSnapshot document) async {
    if (_user == null) getCurrentUser();
    setState(() {
      if (_result[document.documentID]) {
        // уже сделал лайк
        _result[document.documentID] = false;
        Firestore.instance
            .collection("news")
            .document(document.documentID)
            .updateData(Map.from({
              "like": FieldValue.arrayRemove(List.unmodifiable([_user.uid]))
            }));
        _color = Color(0xFF000000);
        _likes = _likes - 1;
      } else {
        //не делал лайк
        _result[document.documentID] = true;
        Firestore.instance
            .collection("news")
            .document(document.documentID)
            .updateData(Map.from({
              "like": FieldValue.arrayUnion(List.unmodifiable([_user.uid]))
            }));
        _color = Color(0xFFFF0000);
        _likes = _likes + 1;
      }
    });
  }

  Container buildNewsPage(BuildContext context) {
    return new Container(
      child: new ListView(
        children: <Widget>[
          mainNews(context),
          StreamBuilder<QuerySnapshot>(
            stream: firestore
                .collection("news")
                .orderBy("date", descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Загрузка...');
                default:
                  return new ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        return GestureDetector(
                          child: buildMYColumn(ctx,
                              document:
                                  snapshot.data.documents.elementAt(index)),
                          onTap: () {
                            _handleTap(
                              snapshot.data.documents
                                  .elementAt(index)
                                  .documentID,
                              snapshot.data.documents.elementAt(index)['title'],
                              snapshot.data.documents
                                  .elementAt(index)['description'],
                              snapshot.data.documents.elementAt(index)['image'],
                              snapshot.data.documents.elementAt(index)['date'],
                              List.from(snapshot.data.documents
                                      .elementAt(index)['like'])
                                  .length
                                  .toString(),
                              snapshot.data.documents
                                  .elementAt(index)['commentsCount']
                                  .toString(),

                              //   snapshot.data.documents.elementAt(index)['like'],
                            );
                          },
                        );
                      });
              }
            },
          )
        ],
      ),
    );
  }

  Widget buildMYColumn(BuildContext context, {DocumentSnapshot document}) {
    return buildMyCardWithPaddingNotOnTap(Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image(
            image: FirebaseImage(document['image']),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text(
              document['title'],
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new GestureDetector(
                  child: Padding(
                    padding:  const EdgeInsets.fromLTRB(10.0, 10.0, 4.0, 10.0),
                    child: new Icon(Icons.favorite,
                        color: _result[document.documentID]
                            ? Color(0xFFFF0000)
                            : Theme.of(context).tabBarTheme.unselectedLabelColor,
                        size: 28.0),
                  ),
                  onTap: () {
                    _likeHandleTap(document);
                  },
                ),
                new GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: new Text(
                      List.from(document['like']).length.toString(),
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: _result[document.documentID]
                              ? Color(0xFFFF0000)
                              : Theme.of(context)
                                  .tabBarTheme
                                  .unselectedLabelColor,
                          fontWeight: FontWeight.w300,
                          fontFamily: "Roboto"),
                    ),
                  ),
                  onTap: () {
                    _likeHandleTap(document);
                  },
                ),
                commentsBlocked
                    ? Container()
                    : GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 4.0, 10.0),
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
                                  AddCommentPage(document.documentID),
                            ),
                          );
                        },
                      ),
               commentsBlocked
                    ? Container()
                    : GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: new Text(
                      _commModelMap[document.documentID].length.toString(),
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Theme.of(context)
                              .tabBarTheme
                              .unselectedLabelColor,
                          fontWeight: FontWeight.w300,
                          fontFamily: "Roboto"),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddCommentPage(document.documentID),
                      ),
                    );
                  },
                ),

                new Text(
                  formatDate(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(document['date'])),
                      [dd, '.', mm, '.', yyyy]),
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ]),
          _commModelMap[document.documentID].isNotEmpty
              ? singleComment(
                  context, _commModelMap[document.documentID].first, true)
              : Container(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CommentWidget(document.documentID,
                      commentsBlocked: commentsBlocked),
                ),
              );
            },
            child: Text("Показать все комментарии (" +
                _commModelMap[document.documentID].length.toString() +
                ")"),
          ),
        ]));
  }

  Future<Map<String, bool>> _getLikesResult() async {
    Map<String, bool> result = new Map();
    firestore.collection("news").snapshots().listen((snapshot) {
      snapshot.documents.forEach((doc) => result.putIfAbsent(
          doc.documentID, () => List.from(doc['like']).contains(_user.uid)
          //     () => debugPrint("likesResultForEach:" + List.from(doc['like']).toString() +" " + _user.uid) as bool
          ));
    });
    //кладем результаты foreach в map, выводим все в виджете
    return result;
  }

  Future<Map<String, String>> _setEventsInfo() async {
    Map<String, String> result = new Map();
    DocumentSnapshot documentSnapshot =
        await firestore.collection("events").document("action").get();
    String imageAction = documentSnapshot.data["image"].toString();
    result.putIfAbsent("imageAction", () => imageAction);
    documentSnapshot =
        await firestore.collection("events").document("sponsor").get();
    String imageSponsor = documentSnapshot.data["image"].toString();
    String siteSponsor = documentSnapshot.data["link"].toString();
    result.putIfAbsent("imageSponsor", () => imageSponsor);
    result.putIfAbsent("siteSponsor", () => siteSponsor);
    return result;
  }

  _saveDeviceToken() async {
    String uid = user.uid;
    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
    debugPrint("User: " + uid);
  }

  void _getComments() async {
    Map<String, List<CommentModel>> commModelMap = new Map();
    List<String> docsId = new List();
    final QuerySnapshot result =
        await Firestore.instance.collection("news").getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    setState(() {
      documents.forEach((i) => docsId.add(i.documentID));
      docsId.forEach((element) {
        List<CommentModel> commList = new List();
        Firestore.instance
            .collection("news")
            .document(element)
            .collection("comments")
            .snapshots()
            .listen((snapshot) => snapshot.documents
                .forEach((i) => commList.add(CommentModel.fromMap(i.data))));
        commModelMap.putIfAbsent(element, () => commList);
      });
      _commModelMap = commModelMap;
    });
  }
}

Future<MatchModel> getNearest() async {
  MatchModel result;
  DocumentSnapshot documentSnapshot =
      await firestore.collection("games").document("0").get();
  result = MatchModel.fromMap(documentSnapshot.data);

  if (int.parse(result.date) < DateTime.now().millisecondsSinceEpoch / 1000) {
    DocumentSnapshot anotherDocumentSnapshot =
        await firestore.collection("games").document("1").get();
    result = MatchModel.fromMap(anotherDocumentSnapshot.data);
  }
  return result;
}
