

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class _SettingListTileState extends State<SettingListTile> {
  Widget settingsLineWiget(BuildContext context) {
    return FlatButton(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(flex: 5,
                child: Text(widget.text
                    ,style: TextStyle(
                      fontSize: 20,
//                          color: Color(0xFFFFFFFF),
                    )),),
              Expanded(flex: 1,
                  child: CupertinoSwitch(  activeColor: Theme.of(context).accentColor, value: widget.value, onChanged: (bool _value) {
                    setState(() {
                         widget.value = _value;
                    });
                    widget.func();
                  },)),
            ],
          ),
          Divider(),
        ],
      ),
      onPressed: () {
        setState(() {
          widget.value = !widget.value;
        });
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return settingsLineWiget (context);
  }
}

class SettingListTile extends StatefulWidget {
  String text;
  bool value;
  Function () func;
  SettingListTile ({Key key, this.text, this.value = false, this.func}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingListTileState();
  }
}


