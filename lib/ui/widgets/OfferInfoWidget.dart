import 'package:gazpromconnect/ui/widgets/MyCard.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class OfferInfoWidget extends StatefulWidget {
  String title;
  String firePath;

  @override
  State createState() {
    return OfferInfoState(title, firePath);
  }

  OfferInfoWidget(
      {this.title = "", this.firePath = "/userimages/food/burger.png"});
}

class OfferInfoState extends State<OfferInfoWidget> {
  String title;
  String photoUrl = "";
  String firePath;

  OfferInfoState(this.title, this.firePath);

  @override
  void initState() {
    super.initState();
    loadUrl(firePath);
  }

  @override
  Widget build(BuildContext context) {
    return offerInfoContent(context);
  }

  @override
  Widget offerInfoContent(BuildContext context) {
    return buildMyCardWithPaddingBlue(Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Expanded(
            flex: 1,
            child: FadeInImage.assetNetwork(
              placeholder: "assets/logonn.png",
              image: photoUrl,
              alignment: Alignment.centerRight,
            ),
          )
        ]));
  }

  loadUrl(String path) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(path);
    String url = (await ref.getDownloadURL()).toString();
    setState(() {
      photoUrl = url;
    });
  }
}
