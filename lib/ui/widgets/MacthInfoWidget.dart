import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:gazpromconnect/main.dart';
import 'package:gazpromconnect/ui/widgets/MyCard.dart';
import 'package:gazpromconnect/ui/widgets/TableRow.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'RaisedGradientButton.dart';

Widget matchInfoContentOnMain(BuildContext context, String date, String guest,
    String home, String info, String logoGuest, String logoHome,
    {bool qwer = true, bool poiu = false}) {
  return buildMyCardWithPadding(Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: new Image.network(logoHome)),
              Expanded(
                child: new Text(
                  formatDate(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(date) * 1000),
                      ['', dd, '.', mm]),
                  //удалил пробелы из кавычек '' чтобы выровнять дату события
                  style: new TextStyle(
                      fontSize:  MediaQuery.of(context).size.height> 700? 16: 14,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w900,
                      fontFamily: "Roboto"),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(child: new Image.network(logoGuest)),
            ]),
        Container(
          padding: const EdgeInsets.all(6),
          child: new Text(
            translit(home) + " - " + translit(guest),
            style: Theme
                .of(context)
                .textTheme
                .subtitle2,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          child: new Text(
            info,
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .bodyText1,
          ),
        ),


        qwer ? Container(                                                        //это контейнер на главном экране
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 12),
          child: Row(  
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () => _launchWatch(date),
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            image: AssetImage("assets/play.png")
                        )
                    ),
                  ),
                ),
                myGradientButton(context, btnText: "Купить билет", funk: () {
                  _launchURL(date+guest);
                }),
                InkWell(
                  onTap: () => _onTapArrangeIcon(context, date),
                  child: Container(
                    width: 45,
                    height: 40,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            image: AssetImage("assets/arrang.jpg")
                        )
                    ),
                  ),
                ),
              ]),
        )
            :
        Container(),
        poiu ? myGradientButton(context, btnText: "Где смотреть", funk: () {
          Navigator.pushNamed(context, "/watchplace");
        },) : Container(),

      ]));
}

Widget lastMatchInfo(BuildContext context, String date, String guest,
    String home, String info, String logoGuest, String logoHome, String score,
    {bool qwer = true, bool poiu = false}) {
  return buildMyCardWithPadding(Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: new Image.network(logoHome)),
              Expanded(
                child: new Text(
                  formatDate(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(date) * 1000),
                      ['', dd, '.', mm]),
                  //удалил пробелы из кавычек '' чтобы выровнять дату события
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w900,
                      fontFamily: "Roboto"),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(child: new Image.network(logoGuest)),
            ]),
        Container(
          padding: const EdgeInsets.all(8),
          child: new Text(
            translit(home) + " - " + translit(guest),
            style: Theme
                .of(context)
                .textTheme
                .subtitle,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(6),
          child: new Text(
            info,
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .body1,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: new Text(
            score,
            style: Theme
                .of(context)
                .textTheme
                .subtitle,
            textAlign: TextAlign.center,
          ),
        ),


      ]));
}



Widget matchInfoContentOnTickets (List <Widget> list) {
    return Container(
      child: Column(
        children: list,
      ),
    );
}

void _onTapArrangeIcon(BuildContext context, String date) async {
  List<String> documents = new List();
  Firestore firestore = Firestore.instance;
  final QuerySnapshot result = await firestore
      .collection("arrangements")
      .getDocuments();
  result.documents.forEach( (doc) => documents.add(doc.documentID));

  if (documents.contains(date)) {

  } else {
    Fluttertoast.showToast(
        msg: "Для данного матча пока нет тактического построения",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}


  _launchURL(String docname) async {
  const url = 'https://nn.kassir.ru/frame/entry/index/125?type=S&key=ac14366c-0c28-8c69-a8ff-19360914898e';
  String DBurl;
  DocumentSnapshot documentSnapshot = await firestore.collection('macthsurl').document(docname).get();
  if (documentSnapshot.data != null) {
    String DBurl = documentSnapshot.data['url'];

    if (DBurl == null) {
      DBurl = url;
    }
  } else {
    DBurl = url;
  }
  if (await canLaunch(DBurl)) {
    await launch(DBurl);
  } else {
    throw 'Could not launch $DBurl';
  }
}

  _launchWatch(String date) async {
  DocumentSnapshot documentSnapshot = await firestore.collection('macthsurl')
      .document(date)
      .get();
  debugPrint("watchUrl exec" + documentSnapshot.data.toString());
  if (documentSnapshot.data != null) {
    String watchMatchLink = documentSnapshot.data['watch'];
debugPrint("watchUrl " + watchMatchLink);
    if (await canLaunch(watchMatchLink)) {
      await launch(watchMatchLink);
    } else {
      Fluttertoast.showToast(
          msg: "Ещё нет ссылки на трансляцию данного матча",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  } else {
    Fluttertoast.showToast(
    msg: "Ещё нет ссылки на трансляцию данного матча",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIos: 1,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 16.0
    );
  }
}
