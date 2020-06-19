

import 'package:flutter/material.dart';

Widget myBodyTextSmall(String text) {
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: new Text(text,
      style: new TextStyle(fontSize:14.0,
//          color: const Color(0xFF000000),
//          fontWeight: FontWeight.w300,
          fontFamily: "Roboto"),
    ),
  );
}

Padding buildBodyTextMedium(String text) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: new Text(text,
      style: new TextStyle(fontSize:16.0,
//          color: const Color(0xFF000000),
//          fontWeight: FontWeight.w400,
          fontFamily: "Roboto"),
    ),
  );
}

