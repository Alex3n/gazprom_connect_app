import 'package:flutter/material.dart';

Widget borderContainer(Widget child) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
    child: Container(
      padding: EdgeInsets.only(top: 8.0,bottom: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFE2E2E2),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    ),
  );
}
