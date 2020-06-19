import 'package:flutter/material.dart';
// опка не используем(комментарий удалить при первом использовании)
RaisedButton ButtonBlueGradient(BuildContext context, void Function ()funk,{String btnText}) {
  return RaisedButton(
  child: Container(child: Text(btnText),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: <Color>[
          Colors.blue,
          Colors.red,
        ],
      ),
    ),),

      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20)),
      onPressed:  funk);
}

