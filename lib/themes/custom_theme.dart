import 'package:gazpromconnect/main.dart';
import 'package:gazpromconnect/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


class _CustomTheme extends InheritedWidget {
  final CustomThemeState data;

  _CustomTheme({
    this.data,
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_CustomTheme oldWidget) {
    return true;
  }
}

class CustomTheme extends StatefulWidget {
  final Widget child;
  final MyThemeKeys initialThemeKey;

  const CustomTheme({
    Key key,
    this.initialThemeKey,
    @required this.child,
  }) : super(key: key);

  @override
  CustomThemeState createState() => new CustomThemeState();

  static ThemeData of(BuildContext context) {
    _CustomTheme inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>());
    return inherited.data.theme;
  }

  static CustomThemeState instanceOf(BuildContext context) {
    _CustomTheme inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>());
    return inherited.data;
  }
}

class CustomThemeState extends State<CustomTheme> {
  ThemeData _theme;

  ThemeData get theme => _theme;
  MyThemeKeys mythemeKey;

  @override
  initState() {
    mythemeKey=widget.initialThemeKey;
    if  (prefs != null && prefs.get("isDarkTeme")!= null) {
      mythemeKey = prefs.get("isDarkTeme")? MyThemeKeys.DARKFC :MyThemeKeys.LIGHTFC;
    }
    _theme = MyThemes.getThemeFromKey(mythemeKey);
    super.initState();
  }

  

  void changeTheme(MyThemeKeys themeKey) {
    setState(() {
      _theme = MyThemes.getThemeFromKey(themeKey);
      mythemeKey=themeKey;
      prefs.setBool("isDarkTeme", mythemeKey == MyThemeKeys.DARKFC);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _CustomTheme(
      data: this,
      child: widget.child,
    );
  }
}