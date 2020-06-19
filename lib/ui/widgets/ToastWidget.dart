import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showCompleteToast(BuildContext context, String title) {
  Fluttertoast.showToast(
      msg: title,
      textColor: Theme.of(context).textTheme.headline3.color,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 3,
      backgroundColor: Theme.of(context).primaryColor,
      fontSize: Theme.of(context).textTheme.headline3.fontSize);
}
