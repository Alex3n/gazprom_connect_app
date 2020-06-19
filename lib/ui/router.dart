import 'package:gazpromconnect/SignInPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../SplashPage.dart';
import './views/addProduct.dart';
import '../CheckoutPage.dart';
import '../EditProfilePage.dart';
import '../GoodInfoPage.dart';
import '../NewsPage.dart';
import '../ProfilePage.dart';
import 'widgets/ProfilePlayer.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => NewsPage());
      case '/addProduct':
        return MaterialPageRoute(builder: (_) => AddProduct());
//      case '/settings':
//        return MaterialPageRoute(builder: (_) => SettingsPage());

      case '/player':
        return MaterialPageRoute(builder: (_) => ProfilePlayer());
      case '/signin':
        return MaterialPageRoute(builder: (_) => PhoneLogin());
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case '/editprofile':
        return MaterialPageRoute(builder: (_) => EditProfilePage());
      case '/goodinfo':
        return MaterialPageRoute(builder: (_) => GoodInfoPage());
      case '/checkout':
        return MaterialPageRoute(builder: (_) => CheckoutPage());

      case '/splashPage':
        return MaterialPageRoute(builder: (_) => SplashPage());
      case '/watchplace':







      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
