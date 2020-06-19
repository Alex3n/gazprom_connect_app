import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gazpromconnect/MyScaffold.dart';
import 'package:gazpromconnect/ui/widgets/MyCard.dart';
import 'package:gazpromconnect/ui/widgets/RaisedGradientButton.dart';
import 'package:gazpromconnect/ui/widgets/TextFieldPadding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'core/fireStorage.dart';
import 'main.dart';

//import 'package:sticky_headers/sticky_headers.dart';

class EditProfilePage extends StatefulWidget {
  final bool fromAuth;

  EditProfilePage({Key key, this.fromAuth = false}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameTFC = TextEditingController();

  TextEditingController _emailTFC = TextEditingController();

  TextEditingController _bornDateTFC = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Isolate isolate;

  FirebaseUser _user;
  Map dBuser;
  String photoURL;

  bool isNameValid = false;
  bool isEmailValid = false;

  Future getCurrentUser() async {
    firebaseAuth.currentUser().then((_userFB) {
      setState(() {
        _user = _userFB;
      });
      Firestore.instance
          .collection("users")
          .document(_userFB.uid)
          .snapshots()
          .listen((data) {
        setState(() {
          dBuser = data.data;
          userdata = data.data;
          _user = _userFB;
          if (dBuser != null) {
            _nameTFC.text = dBuser["name"];
            validateName();
            _bornDateTFC.text = dBuser["bornDate"];
            _emailTFC.text = dBuser["email"];
            validateEmail();
            photoURL = dBuser["photoURL"];
          }
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void saveChanges(BuildContext context) async {
    Map<String, dynamic> _userdata =  {
      'time': dBuser == null ? FieldValue.serverTimestamp() : dBuser['time'],
      'timeLastChanged': FieldValue.serverTimestamp(),
      'name': _nameTFC.text,
      'email': _emailTFC.text,
      'phone': _user.phoneNumber,
      'bornDate': _bornDateTFC.text,
      'photoURL': photoURL,
      'id': _user.uid
    };
    Firestore.instance.collection("users").document(_user.uid).setData(_userdata).then((value) {
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = _nameTFC.text;
      _user
          .updateProfile(updateInfo)
          .then((value) => Navigator.pushNamed(context, "/"));
      userdata =  _userdata;
    });
  }

  Future<Null> validateName() async {
    print("in validate : ${_nameTFC.text.length}");
    if (_nameTFC.text.length > 1) {
      setState(() {
        isNameValid = true;
      });
    } else {
      setState(() {
        isNameValid = false;
      });
    }
  }

  String emailValidator(String value) {
    return isEmailValid ? null : "Почта введена не верно";
  }

  Future<Null> validateEmail() async {
    print("in validate : ${_emailTFC.text.length}");
    if (_emailTFC.text.length > 2 && _emailTFC.text.contains("@")) {
      setState(() {
        isEmailValid = true;
      });
    } else {
      setState(() {
        isEmailValid = false;
      });
    }
  }

  String nameValidator(String value) {
    return isNameValid ? null : "Имя не введено";
  }

  Widget profileEditContentColumn(BuildContext context) {
    return new ListView(
//        mainAxisSize: MainAxisSize.max,
//        mainAxisAlignment: MainAxisAlignment.start,
//        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildMyCardWithPadding(
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          firebaseAuth.signOut();
                          Navigator.pushNamed(context, "/signin");
                        },
                        child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(Icons.exit_to_app,
                                size: 40.0,
                                color: Theme.of(context)
                                    .tabBarTheme
                                    .unselectedLabelColor)))
                  ],
                ),
                FlatButton(
                    child: Container(
                      margin: EdgeInsets.all(26),
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          image: FirebaseImage(photoURL != null
                              ? "gs://fcnn-8e0f7.appspot.com/" + photoURL
                              : 'https://st3.depositphotos.com/4111759/13425/v/450/depositphotos_134255588-stock-illustration-empty-photo-of-male-profile.jpg'),
//
                        ),
                      ),
                    ),
                    onPressed: () {
                      uploadUserAvatar(_user.uid, isolate);
                    }),
                textFieldPadding(
                    fieldname: "Имя",
                    controller: _nameTFC,
                    validate: validateName,
                    validator: nameValidator),
                InkWell(
                  onTap: () {
                    _selectDate(_bornDateTFC
                        .text); // Call Function that has showDatePicker()
                  },
                  child: IgnorePointer(
                    child: textFieldPadding(
                        fieldname: "Дата рождения", controller: _bornDateTFC),
                  ),
                ),
                textFieldPadding(
                    fieldname: "Е-mail",
                    controller: _emailTFC,
                    validator: emailValidator,
                    validate: validateEmail),
                new Padding(
                    padding: EdgeInsets.all(24),
                    child: Opacity(
                      child: myGradientButton(context, btnText: "Применить",
                          funk: () {
                        if (isEmailValid && isNameValid) {
                          saveChanges(context);
                        } else {}
                      }),
                      opacity: (isEmailValid && isNameValid) ? 1.0 : 0.5,
                    ))
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 35),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return widget.fromAuth
        ? Scaffold(
            body: profileEditContentColumn(context),
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                "Регистрация",
                style: Theme.of(context).textTheme.headline6,
              ),
            ))
        : buildMyScaffold(
            context, profileEditContentColumn(context), "Редактирование",
            bottomItemIndex: 3);
  }

  Future _selectDate(String date) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1930),
        maxTime: DateTime.now(), onConfirm: (picked) {
      _bornDateTFC.text = DateFormat('dd.MM.yyyy').format(picked).toString();
    },
        currentTime:date.isEmpty? DateTime.now() : DateFormat('dd.MM.yyyy').parse(date),
        locale: LocaleType.ru);
  }
}
