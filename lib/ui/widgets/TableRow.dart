import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TableRowWidget extends StatefulWidget {
  String plase = " ";
  String clubicon;
  String nameteam;
  String games;
  String wins;
  String draws;
  String defeats;
  String scores;
  String image;

  TableRowWidget(
      {this.plase = " ",
      this.clubicon,
      this.nameteam,
      this.games,
      this.wins,
      this.draws,
      this.defeats,
      this.scores,
      this.image});

  @override
  _TableRowState createState() => _TableRowState(
      plase, clubicon, nameteam, games, wins, draws, defeats, scores, image);
}

class _TableRowState extends State<TableRowWidget> {
  String plase = " ";
  String clubicon;
  String nameteam;
  String games;
  String wins;
  String draws;
  String defeats;
  String scores;
  String image;

  _TableRowState(this.plase, this.clubicon, this.nameteam, this.games,
      this.wins, this.draws, this.defeats, this.scores, this.image);

  @override
  void initState() {
    super.initState();
    Firestore.instance
        .collection("teamsPhotos")
        .document(nameteam)
        .get()
        .then((snap) {
      String _image = snap.data["image"];
      setState(() {
        image = _image;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                child: Text(
                  plase,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: (image != null && image.length > 0)
                    ? Image(
                        image: FirebaseImage(image),
                      )
                    : Image.network(clubicon),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  translit(nameteam),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(games),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(wins),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(draws),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(defeats),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(scores),
              ),
            )
          ],
        ),
        Divider()
      ],
    );
  }
}

String translit(String s) {
  if (s == 'Rotor Volgograd') return 'Ротор';
  if (s == 'Torpedo Moskva') return 'Торпедо Москва';
  if (s == 'Khimki') return 'Химки';
  if (s == 'Chertanovo Moscow') return 'Чертаново';
  if (s == 'FK Neftekhimik') return 'Нефтехимик';
  if (s == 'Shinnik Yaroslavl') return 'Шинник';
  if (s == 'Baltika') return 'Балтика';
  if (s == 'Ska-khabarovsk') return 'СКА Хабаровск';
  if (s == 'Chayka') return 'Чайка';
  if (s == 'TOM Tomsk') return 'Томь Томск';
  if (s == 'Nizhny Novgorod') return 'Нижний Новгород';
  if (s == 'Krasnodar 2') return 'Краснодар 2';
  if (s == 'FC Armavir') return 'Армавир';
  if (s == 'Avangard Kursk') return 'Авангард Курск';
  if (s == 'Luch-Energiya') return 'Луч Энергия';
  if (s == 'Spartak Moscow 2') return 'Спартак 2';
  if (s == 'Enisey') return 'Енисей';
  if (s == 'Mordovia Saransk') return 'Мордовия';
  if (s == 'Tekstilshchik') return 'Текстильщик';
  if (s == 'Fakel Voronezh')
    return 'Факел';
  else
    return s;
}
