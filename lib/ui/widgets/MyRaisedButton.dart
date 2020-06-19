import 'package:gazpromconnect/themes/colors.dart';
import 'package:flutter/material.dart';

Widget myRaisedButton({String btnText=" ", void Function ()funk}) {
  return RaisedButton(
    onPressed: funk,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
    padding: const EdgeInsets.all(0.0),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(14),
//        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0, maxWidth: 123),
        // min sizes for Material buttons
        alignment: Alignment.center,
        child:  Text(
          btnText,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 16),

        ),
      ),
  );
}