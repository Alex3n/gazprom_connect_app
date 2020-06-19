

import 'package:gazpromconnect/ui/views/mainDrawer.dart';
import 'package:flutter/material.dart';

class ProfilePlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Профиль игрока')),
      ),
      backgroundColor: const Color.fromARGB(245, 234, 234, 234),
      drawer: mainDrawer(),
      body: Stack(children: <Widget>[
        //сделать 2 ячейки в соотношении 2:3, одна с градиентом другая без
        // поместить их в один элемент стэка
        // поверх них поместить контейнер с текстом


        Container (
          child: Row (
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                  ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  width: 250.0,
                  height: 250.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      alignment: Alignment.topRight,
                      fit: BoxFit.none,
                      image: AssetImage(
                        'assets/player_profile.png',
                      ),
                    ),
                  ),
                ),
              ]
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.0),
                    Colors.white,
                  ],
                  stops: [
                    0.0,
                    1.0
                  ])
          ),
        ),
        Container(
          child : new Text(
            "Анисимов Артур",
            textAlign: TextAlign.right,
            style: new TextStyle(fontSize:22.0,
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w400,
                fontFamily: "Roboto"),
          ),
        ),
      ]),
    );
  }

}