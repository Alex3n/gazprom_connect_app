import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';

import 'MyCard.dart';
import 'MyTexts.dart';

/*Widget buildPlayerBox(String playerPhotoUrlBox, BuildContext context,
    {String playerNameBox = "10",
    String playerCountryBox = "1",
    String playerBornDateBox = "1",
    String playerNumberBox = "10"}) {
  return buildMyCardWithPadding(
      PlayerContentRow(playerPhotoUrlBox,
          playerName: playerNameBox,
          playerCountry: playerCountryBox,
          playerBornDate: playerBornDateBox,
          playerNumber: playerNumberBox),
      padding: EdgeInsets.all(0.0), onTapFunc: () {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PlayerPage(
                  playerNameBox,
                  playerPhotoUrlBox,
                  playerCountryBox,
                  playerNumberBox,
                  "Надо заполнить"
                )));
  });
} */

Widget PlayerContentRow(String playerPhotoUrl,
    {BuildContext context, String playerName = "1",
    String playerCountry = "1 ",
    String playerBornDate = " 1",
    String playerNumber = "1"}) {
  return AspectRatio(
    aspectRatio: 16 / 5,
    child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: 6,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: FirebaseImage(playerPhotoUrl))),
              )),
          //фото игрока
          Expanded(
            flex: 17,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
              child: new Column(
                  //колонка с данными
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildBodyTextMedium(playerName),
                    myBodyTextSmall(playerCountry),
                    myBodyTextSmall(playerBornDate),
                  ]),
            ),
          ),
          Expanded(
            flex: 4,
            child: new Column(
                //колонка с номером и стрелкой
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
//            border: Border.all(width: 10, color: Colors.black38),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: const Radius.circular(21)),
                      color: Color(0xff1B5E9E),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(
                            1.0,
                            1.0,
                          ),
                          blurRadius: 2.0,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
//                margin: const EdgeInsets.fromLTRB(30, 16, 30, 16),
                    child: Text(
                      playerNumber,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: (MediaQuery.of(context).size.width > 320)? 26 : 20,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 28.0,
                    ),
                  )
//                Text(">",style: TextStyle (fontSize:50.0,color: Color(0xFF000000),),)
                ]),
          )
        ]),
  );
}
