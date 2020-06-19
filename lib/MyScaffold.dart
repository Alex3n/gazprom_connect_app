import 'package:gazpromconnect/ui/views/mainDrawer.dart';
import 'package:flutter/material.dart';

import 'ui/views/BottobBanner.dart';

Scaffold buildMyScaffold(BuildContext context, Widget body, String title,
    {int bottomItemIndex = 0, bool isAppbar = true, int indexdrawer = 0, bool isNeedDrawer = true, bool isNeedBottomMenu = true, bool isNeedBottomBar = false}) {
  return Scaffold(
      appBar: isAppbar
          ? AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(title, style: Theme.of(context).textTheme.headline6),
              centerTitle: true,
            )
          : null,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: isNeedDrawer ?  mainDrawer(index: indexdrawer) : null,
      body: body,
      bottomNavigationBar: !isNeedBottomMenu? null : Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
         isNeedBottomBar?  SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            height: 50.0,
            child: BottomBanner("mainbottombaner"),
          ) :  Container(),
          BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              iconSize: 26,
              unselectedItemColor:
                  Theme.of(context).tabBarTheme.unselectedLabelColor,
              selectedItemColor: Theme.of(context).tabBarTheme.labelColor,
              selectedLabelStyle: Theme.of(context).tabBarTheme.labelStyle,
              unselectedLabelStyle:
                  Theme.of(context).tabBarTheme.unselectedLabelStyle,
              showUnselectedLabels: true,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.access_alarms),
                  title: Text('Главная'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  title: Text('Команда'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  title: Text('Чаты'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  title: Text('Профиль'),
                ),
              ],
              currentIndex: bottomItemIndex,
              onTap: (int index) {
                String _routeName;
                switch (index) {
                  case 0:
                    _routeName = '/';
                    break;
                  case 1:
                    _routeName = '/team';
                    break;
                  case 2:
                    _routeName = '/chats';
                    break;
                  case 3:
                    _routeName = '/profile';
                    break;
                }
                Navigator.pushNamed(context, _routeName);
              }),
        ],
      ) //
      );
}
