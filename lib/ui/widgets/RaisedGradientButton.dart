import 'package:gazpromconnect/themes/colors.dart';
import 'package:flutter/material.dart';

Widget myGradientButton(BuildContext context,
    {String btnText = " ", void Function() funk}) {
  return RaisedButton(
    onPressed: funk,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
    padding: const EdgeInsets.all(0.0),
    child: Ink(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: <Color>[btngradientstartlight, btngradientendlight]),
        borderRadius: BorderRadius.all(Radius.circular(80.0)),
      ),
      child: Container(
        padding: EdgeInsets.all(14),
//        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0, maxWidth: 123),
        // min sizes for Material buttons
        alignment: Alignment.center,
        child: Text(
          btnText,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    ),
  );
}

Widget myGradientButtonNoRadius(BuildContext context,
    {String btnText = " ", void Function() funk}) {
  return Ink(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
          colors: <Color>[btngradientstartlight, btngradientendlight]),
//        borderRadius: BorderRadius.all(Radius.circular(80.0)),
    ),
    child: Container(
      padding: EdgeInsets.all(14),
//        constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0, maxWidth: 123),
      // min sizes for Material buttons
      alignment: Alignment.center,
      child: Text(
        btnText,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    ),
  );
}


