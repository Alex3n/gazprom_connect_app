import 'package:flutter/material.dart';

import 'mainDrawer.dart';

class ProductDetails extends StatelessWidget {
  final name;

  ProductDetails({this.name: "name"});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(child: Image(image: AssetImage('assets/minilogofcnn.png'))),
      drawer: mainDrawer()
    );
  }
}
