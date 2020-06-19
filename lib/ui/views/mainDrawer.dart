import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazpromconnect/ui/widgets/MyCard.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gazpromconnect/core/funcs.dart';

import '../../main.dart';

class mainDrawer extends StatefulWidget {
  mainDrawer({Key key, this.index}) : super(key: key);

  int index;



  @override
  State<StatefulWidget> createState() => _mainDrawerState(index);
}

class _mainDrawerState extends State<mainDrawer> with  AutomaticKeepAliveClientMixin<mainDrawer> {

  int index = 0;
  String imageOnDrawerTop= prefs.getString("onDrawerTop");
  String imageOnDrawerDown = prefs.getString("onDrawerDown");
  String url;

  Map _photos;

  _mainDrawerState(int index) {
    this.index = index;
  }

  @override
   initState() {
    super.initState();
    Firestore.instance
        .collection("stylephotos").document("onDrawerTop").get().then((snap) {
      String _imageOnDrawerTop = snap.data["image"];
      setState(() {
        url =  snap.data["link"];
        imageOnDrawerTop= _imageOnDrawerTop;
        prefs.setString("onDrawerTop", _imageOnDrawerTop);
      });
    });
    Firestore.instance
        .collection("stylephotos").document("onDrawerDown").get().then((snap) {
      String _imageOnDrawerDown = snap.data["image"];
      setState(() {
        imageOnDrawerDown= _imageOnDrawerDown;
        prefs.setString("onDrawerDown", _imageOnDrawerDown);
      });
    });
  }

  ListTile buildListTile(BuildContext context,
      {indexnumber = 0, direction = '/', IconData mIcon, title = "Главная"}) {
    bool selected = index == indexnumber ? true : false;
    Color _iconColor = selected
        ? Theme.of(context).textTheme.headline3.color
        : Theme.of(context).textTheme.headline4.color;
    TextStyle _textStyle = selected
        ? Theme.of(context).textTheme.headline3
        : Theme.of(context).textTheme.headline4;

    return ListTile(
      selected: selected,
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Icon(
                  mIcon,
                  color: _iconColor,
                )),
            Expanded(
              flex: 6,
              child: Container(
                padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                child: Text(
                  title,
                  style: _textStyle,
                ),
              ),
            )
          ]),
      onTap: () {
        Navigator.pushNamed(context, direction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(

            flex: 4,
            child: imageOnDrawerTop==null ? Text('Загрузка...') :
            DrawerHeader(
              decoration: new BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    image: FirebaseImage(imageOnDrawerTop)), //
              ),
              child: Container(),
            ),
          ),
          Expanded(flex: 8 ,child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              buildListTile(context,
                  title: "Главная",
                  direction: "/",
                  mIcon: Icons.access_alarms,
                  indexnumber: 0),
              buildListTile(context,
                  title: "Команда",
                  direction: "/team",
                  mIcon: Icons.people,
                  indexnumber: 1),
              buildListTile(context,
                  title: "Стадион",
                  direction: "/stadium",
                  mIcon: Icons.access_alarms,
                  indexnumber: 2),
              buildListTile(context,
                  title: "Билеты",
                  direction: "/tickets",
                  mIcon: Icons.access_alarms,
                  indexnumber: 3),
              buildListTile(context,
                  title: "Магазин",
                  direction: "/shop",
                  mIcon: Icons.shopping_cart,
                  indexnumber: 4),
              buildListTile(context,
                  title: "Акции партнеров",
                  direction: "/partnerpromotions",
                  mIcon: Icons.beenhere,
                  indexnumber: 5),
              buildListTile(context,
                  title: "Настройки",
                  direction: "/settings",
                  mIcon: Icons.settings,
                  indexnumber: 6),
//              buildListTile(context,
//                  title: "О приложении",
//                  direction: "/about",
//                  mIcon: Icons.info,
//                  indexnumber: 7),

             
            ],
          ),),
          Expanded(flex: 3,
              child: FlatButton(
                onPressed: () {
                  if (url!=null) {
                    launchUrl(url);
                  }
                },
                child: Center(
                  child: buildMyCardWithPadding(imageOnDrawerDown==null? Text('Загрузка...') :
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: FirebaseImage(imageOnDrawerDown)), //
                            ),
                          ),
                    onTapFunc: () {
                      if (url!=null) {
                        launchUrl(url);
                      }
                    },
                  ),
                ),
              ) )
        ],
      ),
    );
  }

  Future<Map<String, String>> _getMenuPhotos() async {
    Map<String, String> result = new Map();
    DocumentSnapshot documentSnapshot = await firestore
        .collection("stylephotos")
        .document("onDrawerDown")
        .get();
    String imageOnDrawerDown = documentSnapshot.data["image"].toString();
    documentSnapshot =
        await firestore.collection("stylephotos").document("onDrawerTop").get();
    String imageOnDrawerTop = documentSnapshot.data["image"].toString();
    result.putIfAbsent("imageOnDrawerDown", () => imageOnDrawerDown);
    result.putIfAbsent("imageOnDrawerTop", () => imageOnDrawerTop);
    debugPrint("getDrawerPhotos result: " + result.toString());
    return result;
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


}
