import 'package:flutter/material.dart';

Widget buildMyCard(Widget child) {
  return Card(
    semanticContainer: true,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () {
        print('Card tapped.');
      },
      child: Container(
        child: child,
      ),
    ),
  );
}

Widget buildMYColumn(BuildContext context, title, column) {
  return Column(
    children: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  print('Card tapped.');
                },
                child: column,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildMyCard2(Widget child, {Function onTap}) {
  return Card(
    semanticContainer: true,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
    child: InkWell(
      splashColor: Colors.blue.withAlpha(30),
      onTap: () {
        onTap();
        print('Card tapped.');
      },
      child: Container(
        child: child,
      ),
    ),
  );
}

Widget buildMyCardWithPadding(Widget child,
    {EdgeInsets padding = const EdgeInsets.all(16),
    void Function() onTapFunc,
    BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          onTapFunc();
          print('Card tapped.');
        },
        child: Container(
          padding: padding,
          child: child,
        ),
      ),
    ),
  );
}

Widget buildMyCardWithPaddingNotOnTap(Widget child,
    {EdgeInsets padding = const EdgeInsets.fromLTRB(23.0, 12.0, 23.0, 10.0),
    void Function() onTapFunc,
    BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        child: Container(
          padding: padding,
          child: child,
        ),
      ),
    ),
  );
}

Widget buildMyCardWithPaddingBlue(Widget child, {Function funk}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Card(
      color: Colors.blueAccent,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print('Card tapped.');
          funk();
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(23.0, 12.0, 23.0, 10.0),
          child: child,
        ),
      ),
    ),
  );
}
