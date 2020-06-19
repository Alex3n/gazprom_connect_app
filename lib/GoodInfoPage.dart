import 'dart:core';

import 'package:gazpromconnect/MyScaffold.dart';
import 'package:gazpromconnect/ui/widgets/MyCard.dart';
import 'package:gazpromconnect/ui/widgets/RaisedGradientButton.dart';
import 'package:flutter/material.dart';

import 'CheckoutPage.dart';

class GoodInfoPage extends StatefulWidget {
  String title;
  String photoUrl = "";
  String infoText;
  String size;
  String sizeName;
  String price;
  int id;
  String group;

  GoodInfoPage(
      {Key key,
      this.title = "Футболка",
      this.infoText = "ФК НН",
      this.size = "S/M/L",
      this.price = "900 р",
      this.sizeName = "Размер",
      this.photoUrl,
      this.id,
      this.group})
      : super(key: key);

  @override
  _GoodInfoState createState() => _GoodInfoState(
      title, photoUrl, infoText, size, sizeName, price, id, group);
}

class _GoodInfoState extends State<GoodInfoPage> {
  String sizeResult;
  String title;
  String photoUrl = "";
  String infoText;
  String size;
  String sizeName;
  String price;
  int id;
  String group;

  _GoodInfoState(this.title, this.photoUrl, this.infoText, this.size,
      this.sizeName, this.price, this.id, this.group);

  @override
  Widget build(BuildContext context) {
    return buildMyScaffold(context, buildGoodInfoContent(context), "Билеты",
        bottomItemIndex: 2, isAppbar: false, indexdrawer: 3);
  }

  Widget buildGoodInfoContent(BuildContext context) {
    return ListView(children: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ),
      buildMyCardWithPadding(
          new Column(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  getChips(size),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(0, 10, 10, 8.0),
                    child: FadeInImage.assetNetwork(
                        placeholder: "assets/logonn.png", image: photoUrl),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 8.0),
                        child: new Text(price,
                            style: Theme.of(context).textTheme.subtitle2),
                      ),
                      myGradientButton(context, btnText: "Заказать", funk: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                    title: title,
                                    infoText: infoText,
                                    price: price,
                                    size: sizeResult,
                                    sizeName: sizeName,
                                    photoUrl: photoUrl,
                                    id: id,
                                    group: group)));
                      }),
                    ],
                  ),
                ],
              )
            ],
          ),
          onTapFunc: () {}),
    ]);
  }

  Widget getChips(String data) {
    List<String> parts = data.split("/");
    if (sizeResult == null && parts.length > 0) {
      sizeResult = parts[0];
    }
    return Wrap(
      children: List<Widget>.generate(
        parts.length,
        (int index) {
          return ChoiceChip(
              selectedColor: Theme.of(context).toggleableActiveColor,
              label: Text(parts[index]),
              labelStyle: Theme.of(context).textTheme.subtitle2,
              selected: sizeResult == parts[index],
              onSelected: (bool selected) {
                setState(() {
                  sizeResult = parts[index];
                });
              });
        },
      ).toList(),
      spacing: 12,
    );
  }
}
