import 'package:flutter/material.dart';

import 'colors.dart';

enum MyThemeKeys {LIGHTFC, DARKFC}

class MyThemes {


  static final ThemeData lightThemeFcNnFonts = ThemeData(

    primaryColor: mainbackgroundlight,
    primaryColorDark: mainbackgroundlight,
    backgroundColor: mainbackgroundlight,
    accentColor: activbottombariconlight,
    scaffoldBackgroundColor: mainbackgroundlight,
    dialogBackgroundColor: Colors.orange,
    brightness: Brightness.light,
    cardColor: boxlight,
    appBarTheme: AppBarTheme(
      color: mainbackgroundlight,
    ),
    textTheme: TextTheme(
      caption: TextStyle(color: redSelected, fontFamily: "Roboto",fontSize: 16 ),
      bodyText1: TextStyle(color: greytextbodylight),
      bodyText2: TextStyle(color: greytextbodylight,
        fontSize: 14,
        fontFamily: "Roboto",
      ),

      headline5: TextStyle(
        fontSize: 20,
        fontFamily: "Roboto",
        color: appbartexstlight,
      ),

      headline6: TextStyle(
          color: appbartexstlight,
          fontSize: 24,
          fontFamily: "Structivism",
          letterSpacing: 1.1),

      subtitle2: TextStyle(color: appbartexstlight, fontSize: 20),

      headline4: TextStyle(
          color: noactivsdrawericonlight,
          fontSize: 24,
          fontFamily: "Structivism",
          letterSpacing: 1.1),


      // боковое меню  Веделенное текст и цвет иконок
      headline3: TextStyle(
          color: activbottombariconlight,
          fontSize: 24,
          fontFamily: "Structivism",
          letterSpacing: 1.1),

    ),
    primaryIconTheme: IconThemeData(color: appbartexstlight),
    tabBarTheme: TabBarTheme(
        unselectedLabelStyle: TextStyle(color: noactivbottombariconlight),
        labelStyle: TextStyle(color: activbottombariconlight),
        labelColor: activbottombariconlight,
        unselectedLabelColor: noactivbottombariconlight),
  );
  static final ThemeData darkThemeFcNnFonts = ThemeData(
    primaryColor: mainbackgrounddark,
    primaryColorDark: mainbackgrounddark,
    backgroundColor: mainbackgrounddark,
    accentColor: activbottombaricondark,
    scaffoldBackgroundColor: mainbackgrounddark,
    dialogBackgroundColor: Colors.orange,
    brightness: Brightness.dark,
    cardColor: boxdark,
    appBarTheme: AppBarTheme(
      color: mainbackgrounddark,
    ),
    textTheme: TextTheme(
      caption: TextStyle(color: redSelected, fontFamily: "Roboto",fontSize: 16 ),
      bodyText1: TextStyle(color: greytextbodydark),
      bodyText2: TextStyle(color: greytextbodydark,
        fontSize: 14,
        fontFamily: "Roboto",
      ),

      headline5: TextStyle(
        fontFamily: "Roboto",
        fontSize: 20,
        color: appbartexstdark,
      ),

      headline6: TextStyle(
          color: appbartexstdark,
          fontSize: 24,
          fontFamily: "Structivism",
          letterSpacing: 1.1),

      subtitle2: TextStyle(color: appbartexstdark, fontSize: 18),

      headline4: TextStyle(
          color: noactivsdrawericondark,
          fontSize: 24,
          fontFamily: "Structivism",
          letterSpacing: 1.1),


      // боковое меню  Веделенное текст и цвет иконок
      headline3: TextStyle(
          color: activbottombariconlight,
          fontSize: 24,
          fontFamily: "Structivism",
          letterSpacing: 1.1),
    ),


    primaryIconTheme: IconThemeData(color: appbartexstdark),
    tabBarTheme: TabBarTheme(
        unselectedLabelStyle: TextStyle(color: noactivbottombaricondark),
        labelStyle: TextStyle(color: activbottombariconlight),
        labelColor: activbottombariconlight,
        unselectedLabelColor: noactivbottombaricondark),
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHTFC:
        return lightThemeFcNnFonts;
      case MyThemeKeys.DARKFC:
        return darkThemeFcNnFonts;
      default:
        return lightThemeFcNnFonts;
    }
  }
}
