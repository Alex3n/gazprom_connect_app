

import 'package:flutter/material.dart';

Container buildMyContainer(Widget child) {
  return new Container(decoration: BoxDecoration(
//                      border: Border.all(width: 10, color: Colors.black38),
    borderRadius: const BorderRadius.all(const Radius.circular(8)),
    boxShadow: <BoxShadow>[
      BoxShadow(

        offset: Offset(1.0, 1.0,),
        blurRadius: 2.0,
      ),
    ],

  ),

      padding: const EdgeInsets.fromLTRB(23.0,12.0,23.0,10.0),
      margin: const EdgeInsets.only(bottom: 18.0),
      child:
      child
  );
}

