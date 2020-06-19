import 'dart:isolate';

import 'package:gazpromconnect/core/fireStorage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

import 'RaisedGradientButton.dart';

Widget profileContentColumn(
  BuildContext context,
  String profilePhotoUrl,
  String userUID, Isolate isolate, {
  String profileName = " ",
  String profilePhone = "телефон не указан ",
  String profileBornDate = " дата не указана",
  String profileMail = " имэйл не указан",
}) {
  return new Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, "/signin");
                },
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(Icons.exit_to_app,
                        size: 40.0,
                        color: Theme.of(context)
                            .tabBarTheme
                            .unselectedLabelColor)))
          ],
        ),
        GestureDetector(
          onTap: () {
            uploadUserAvatar(userUID, isolate);
          },
          child: Container(
            margin: EdgeInsets.all(20),
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                image: FirebaseImage(profilePhotoUrl, shouldCache: false),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 18),
          child: new Text(
            profileName,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Row(
          //строка с телефоном
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(14.0),
                child: Icon(
                  Icons.phone,
                  size: 30.0,
                  color: Color(0xff6C6C6C),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  profilePhone,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
          ],
        ),
        Row(
          //строка с датой рождения
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(14.0),
                child: Icon(
                  Icons.event,
                  size: 30.0,
                  color: Color(0xff6C6C6C),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: new Text(
                  profileBornDate,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
          ],
        ),
        Row(
          //строка с имэйлом
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(14.0),
                child: Icon(
                  Icons.mail,
                  size: 30.0,
                  color: Color(0xff6C6C6C),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: new Text(
                  profileMail,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
          ],
        ),
        new Padding(
          padding: EdgeInsets.all(24),
          child: myGradientButton(context, btnText: "Редактировать", funk: () {
            Navigator.pushNamed(context, "/editprofile");
          }),
        )
      ]);
}
