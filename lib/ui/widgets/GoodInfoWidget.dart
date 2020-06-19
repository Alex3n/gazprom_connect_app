import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazpromconnect/GoodInfoPage.dart';
import 'package:gazpromconnect/ui/widgets/MyCard.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'ToastWidget.dart';

class GoodInfoWidget extends StatefulWidget {
  DocumentSnapshot document;
  bool purchasesActive;

  @override
  State createState() {
    return GoodInfoState(
        document['title'],
        document['infoText'],
        document['size'],
        document['sizeName'],
        document['price'],
        document['firePath'],
        document['id'],
        document['group'],
        purchasesActive);
  }

  GoodInfoWidget({this.document, this.purchasesActive});
}

class GoodInfoState extends State<GoodInfoWidget> {
  String title;
  String photoUrl = "";
  String infoText;
  String size;
  String price;
  String sizeName;
  String firePath;
  int id;
  String group;
  bool purchasesActive;

  GoodInfoState(this.title, this.infoText, this.size, this.sizeName, this.price,
      this.firePath, this.id, this.group, this.purchasesActive);

  @override
  void initState() {
    super.initState();
    loadUrl(firePath);
  }

  @override
  Widget build(BuildContext context) {
    return goodInfoContent(context);
  }

  Widget goodInfoContent(BuildContext context) {
    return buildMyCardWithPadding(
        new Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            FadeInImage.assetNetwork(
              placeholder: "assets/logonn.png",
              image: photoUrl,
              alignment: Alignment.centerRight,
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 8.0),
                  child: new Text(
                    title,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 1.0,
                          color: Theme.of(context).backgroundColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
                  child: new Text(
                    infoText,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 1.0,
                          color: Theme.of(context).backgroundColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 8.0),
                  child: new Text(
                    size,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 1.0,
                          color: Theme.of(context).backgroundColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 8.0),
                  child: new Text(
                    price,
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.5, 1.5),
                          blurRadius: 1.5,
                          color: Theme.of(context).backgroundColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ), onTapFunc: () {
      purchasesActive
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GoodInfoPage(
                        title: title,
                        infoText: infoText,
                        price: price,
                        size: size,
                        sizeName: sizeName,
                        photoUrl: photoUrl,
                        id: id,
                        group: group,
                      )))
          : showCompleteToast(context, "В данный момент функционал недоступен");
    });
  }

  loadUrl(String path) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(path);
    String url = (await ref.getDownloadURL()).toString();
    setState(() {
      photoUrl = url;
    });
  }
}
