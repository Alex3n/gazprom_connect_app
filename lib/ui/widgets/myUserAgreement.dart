
import 'package:gazpromconnect/MyScaffold.dart';
import 'package:gazpromconnect/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAgreementDialog extends StatefulWidget {
  @override
  _UserAgreementDialogState createState() => _UserAgreementDialogState();
}

class _UserAgreementDialogState extends State<UserAgreementDialog> {
  String userAgreementText;


  @override
  void initState() {
   firestore.collection("info").document("userAgreement").get()
       .then((value) =>
   setState((){
     userAgreementText = value.data["text"];
   })
   );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildMyScaffold(context,
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: userAgreementText==null? CircularProgressIndicator() : Text(userAgreementText),
        ),
      )
      , "Согласие на обработку данных", isNeedBottomMenu: false, isNeedDrawer: false );
    throw UnimplementedError();
  }
}