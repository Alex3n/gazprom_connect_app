import 'package:flutter/material.dart';

Padding textFieldPadding(
    {String fieldname = " ",
    double lr = 0,
    double tb = 5,
    TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isValid,
    String labelText = "Имя",
    Function validator,
    Function validate,
    int maxLines = 1}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: lr, vertical: tb),
    child: TextFormField(
      controller: controller,
      autofocus: true,
      maxLines: maxLines,
      onChanged: (text) {
        validate();
      },
      keyboardType: keyboardType,
      style: new TextStyle(
          fontSize: 16.0,
          height: 1.0,
          color: Color(0xff616161),
//                                color: const Color(0xFF000000),
//          fontWeight: FontWeight.w200,
          fontFamily: "Roboto"),
      decoration: InputDecoration(
        labelText: fieldname,
        contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffCBCBCB),
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff2C98F0),
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
//                prefixIcon: Icon(Icons.search),
//          filled: true,
        fillColor: Colors.white,
        // hintText: fieldname,
      ),
      textAlignVertical: TextAlignVertical.center,
      minLines: 1,
      validator: (value) {
        return validator();
      },
    ),
  );
}

Padding textFieldComment(
    {String fieldname = " ",
    double lr = 0,
    double tb = 5,
    TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isValid,
    String labelText = "Имя",
    Function validator,
    Function validate}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: lr, vertical: tb),
    child: TextFormField(
      maxLength: 170,
      controller: controller,
      onTap: () {},
      onChanged: (text) {
        validate();
      },
      keyboardType: keyboardType,
      style: new TextStyle(
          fontSize: 16.0,
          height: 1.0,
          color: Color(0xff616161),
//                                color: const Color(0xFF000000),
//          fontWeight: FontWeight.w200,
          fontFamily: "Roboto"),
      decoration: InputDecoration(
        labelText: fieldname,
        contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffCBCBCB),
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff2C98F0),
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
//                prefixIcon: Icon(Icons.search),
//          filled: true,
        fillColor: Colors.white,
        // hintText: fieldname,
      ),
      textAlignVertical: TextAlignVertical.center,
      minLines: 1,
      validator: (value) {
        return validator();
      },
    ),
  );
}
