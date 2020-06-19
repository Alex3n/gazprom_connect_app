import 'dart:core';

import 'package:gazpromconnect/MyScaffold.dart';
import 'package:gazpromconnect/ui/widgets/MyCard.dart';
import 'package:gazpromconnect/ui/widgets/RaisedGradientButton.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  String title;
  String photoUrl = "";
  String infoText;
  String size;
  String price;
  String sizeName;
  String group;
  int id;

  CheckoutPage(
      {Key key,
      this.title = "Футболка",
      this.infoText = "ФК НН",
      this.size = "S/M/L",
      this.sizeName = "Размер",
      this.price = "900 р",
      this.photoUrl,
      this.id,
      this.group})
      : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState(
      title, photoUrl, infoText, size, sizeName, price, id, group);
}

class _CheckoutState extends State<CheckoutPage> {
  int sizeResult = 0;
  String title;
  String photoUrl = "";
  String infoText;
  String size;
  String sizeName;
  String price;
  int _radioValue1 = 0;
  int id;
  String group;

  _CheckoutState(this.title, this.photoUrl, this.infoText, this.size,
      this.sizeName, this.price, this.id, this.group);

  @override
  Widget build(BuildContext context) {
    return buildMyScaffold(context, buildGoodInfoContent(context), "Билеты",
        bottomItemIndex: 2, isAppbar: false, indexdrawer: 3);
  }

  void _handleRadioValueChange1(value) {
    setState(() {
      _radioValue1 = value;
    });
  }

  Widget buildGoodInfoContent(BuildContext context) {
    return ListView(children: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Оформление заказа",
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ),
      buildMyCardWithPadding(
          new Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                    child: Text(''),
                    flex: 3,
                  ),
                  Flexible(
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/logonn.png",
                      image: photoUrl,
                      alignment: Alignment.centerRight,
                    ),
                    flex: 1,
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 8.0),
                    child: new Text(
                      title + " " + infoText,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 8.0),
                    child: new Text(
                      sizeName + " " + size,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 8.0),
                    child: new Text(
                      "Стоимость " + price,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 8.0),
                    child: new Text(
                      "Доставка",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Radio(
                        value: 0,
                        groupValue: _radioValue1,
                        onChanged: _handleRadioValueChange1,
                      ),
                      new Text(
                        'Самовывоз',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      new Radio(
                        value: 1,
                        groupValue: _radioValue1,
                        onChanged: _handleRadioValueChange1,
                      ),
                      new Text(
                        'Доставка курьером',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 8.0),
                    child: new Text(
                      "Оплата",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          new Radio(
                            value: 0,
                            groupValue: _radioValue1,
                            onChanged: _handleRadioValueChange1,
                          ),
                          new Text(
                            'При получении',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          new Radio(
                            value: 1,
                            groupValue: _radioValue1,
                            onChanged: _handleRadioValueChange1,
                          ),
                          new Text(
                            'Онлайн картой',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 8.0),
                    child: new Text(
                      "Итого",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
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
                      myGradientButton(context, btnText: "Продолжить",
                          funk: () {}),
                    ],
                  ),
                ],
              )
            ],
          ),
          onTapFunc: () {}),
    ]);
  }
}
