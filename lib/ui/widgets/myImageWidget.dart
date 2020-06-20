
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

class MyImageWidget extends StatefulWidget {
  final String url;
  MyImageWidget({Key key, this.url}) : super(key: key);

  @override
  _MyImageWidgetState createState() => _MyImageWidgetState();
}

class _MyImageWidgetState extends State<MyImageWidget> {
  String fullUrl;

  @override
  void initState() {
        if (widget.url!=null && widget.url.isNotEmpty) {
          fb.storage().refFromURL(widget.url).getDownloadURL().then((value) =>
              setState(() {
                fullUrl = value.toString();
              })
          );
        }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.url==null || widget.url.isEmpty)? Container() : fullUrl == null? Container(child: CircularProgressIndicator(),) : Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: NetworkImage(fullUrl))),
    );

  }
}