
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazpromconnect/ui/widgets/MyCard.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import 'package:gazpromconnect/core/funcs.dart';

class BottomBanner extends StatefulWidget {
  String bannerId;
  BottomBanner(this.bannerId);

  @override
  _BottomBannerState createState() => _BottomBannerState(bannerId);
}

class _BottomBannerState extends State<BottomBanner> {
  String bannerId;
  String imageOnBottom= prefs.getString("onBottomBanner");
  _BottomBannerState(this.bannerId);
  String url;

  @override
  initState() {
    super.initState();
    Firestore.instance
        .collection("stylephotos").document(bannerId).get().then((snap) {
      String _imageOnDrawerTop = snap.data["image"];
      url = snap.data["link"];

      setState(() {
        url = snap.data["link"];
        imageOnBottom= _imageOnDrawerTop;
        prefs.setString("onBottomBanner", _imageOnDrawerTop);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  FlatButton(
      onPressed: () {
        if (url!=null) {
          launchUrl(url);
        }
      },
      child: Center(
        child: buildMyCard2(imageOnBottom==null? Text('Загрузка...') :
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(

                image: FirebaseImage(imageOnBottom)), //
          ),
        ),
          onTap: () {
            if (url!=null) {
              launchUrl(url);
            }
          },

        ),
      ),
    );
  }
}