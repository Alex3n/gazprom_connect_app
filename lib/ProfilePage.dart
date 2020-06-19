import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazpromconnect/MyScaffold.dart';
import 'package:gazpromconnect/ui/widgets/MyCard.dart';
import 'package:gazpromconnect/ui/widgets/ProfileBox.dart';
import 'package:gazpromconnect/ui/widgets/RaisedGradientButton.dart';
import 'package:gazpromconnect/ui/widgets/TextFieldPadding.dart';
import 'package:gazpromconnect/ui/widgets/ToastWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:sticky_headers/sticky_headers.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Isolate isolate;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  String photoURL;

  //FirebaseUser user;
  DocumentSnapshot dsuser;
  Map map;

  void getCurrentUser() async {
    FirebaseUser _user = await _firebaseAuth.currentUser();
    Firestore.instance
        .collection("users")
        .document(_user.uid)
        .snapshots()
        .listen((data) {
      setState(() {
        user = _user;
        dsuser = data;
        map = dsuser.data;
        if (map != null) {
          photoURL = map["photoURL"];
        } else {
          map = {
            'name': "не указано",
            'email': 'не указано',
            'phone': 'не указано',
            'bornDate': 'не указано'
          };
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Widget buildProfilePageBody(BuildContext context) {
    return ListView(children: <Widget>[
      buildMyCardWithPadding(profileContentColumn(
        context,
        photoURL != null
            ? "gs://fcnn-8e0f7.appspot.com/" + photoURL
            : 'https://st3.depositphotos.com/4111759/13425/v/450/depositphotos_134255588-stock-illustration-empty-photo-of-male-profile.jpg',
        user.uid, isolate,
        profileName: map['name'] != null ? map['name'] : "не указано",
        profilePhone: map['phone'] != null ? map['phone'] : "не указано",
        profileBornDate:
            map['bornDate'] != null ? map['bornDate'] : "не указано",
        profileMail: map['email'] != null ? map['email'] : "не указано",
      )),
      buildMyCardWithPaddingBlue(
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Купить Билеты",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(child: Image(image: AssetImage('assets/tickets.png')))
              ]), funk: () {
        Navigator.pushNamed(context, '/shop');
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return buildMyScaffold(context, buildProfilePageBody(context), "Профиль",
        bottomItemIndex: 3);
  }

}
