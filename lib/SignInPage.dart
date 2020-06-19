import 'package:gazpromconnect/otpPage.dart';
import 'package:gazpromconnect/ui/widgets/RaisedGradientButton.dart';
import 'package:gazpromconnect/ui/widgets/myUserAgreement.dart';
import 'package:flutter/material.dart';

class PhoneLogin extends StatefulWidget {
  PhoneLogin({Key key}) : super(key: key);

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  final TextEditingController _phoneNumberController = TextEditingController();

  bool isValid = false;

  Future<Null> validate() async {
    print("in validate : ${_phoneNumberController.text.length}");
    if (_phoneNumberController.text.length == 10) {
      setState(() {
        isValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Логин',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                'Введите номер телефона, чтобы продолжить',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _phoneNumberController,
                  autofocus: true,
                  onChanged: (text) {
                    validate();
                  },
                  decoration: InputDecoration(
                    labelText: "10-ти значный номер телефона",
                    prefix: Container(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "+7",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  autovalidate: true,
                  autocorrect: false,
                  maxLengthEnforced: true,
                  validator: (value) {
                    return !isValid
                        ? 'Проверьте правильность ввода (10-ти значний номер телфона)'
                        : null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Text("Проходя регистрацию, я даю своё согласие на"
                          " обработку персональных данных и принимаю условия "
                          "политики конфиденциальности, программы лояльности и "
                          "пользовательского соглашения")),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: myGradientButton(context, btnText:
                         "Посмотреть согласие и условия",
                          funk:() {
                            showDialog(context: context, child:
                              UserAgreementDialog()
                            );
                          }
                      )),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Opacity(
                        opacity: isValid ? 1.0 : 0.5,
                        child: myGradientButton(context,
                            btnText: !isValid
                                ? "Введите номер телефона"
                                : "Продолжить", funk: () {
                          if (isValid) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OTPScreen(
                                    mobileNumber: _phoneNumberController.text,
                                  ),
                                ));
                          } else {
                            validate();
                          }
                        }),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  RaisedButton buildRaisedButton(BuildContext context, StateSetter state) {
    return RaisedButton(
      color: !isValid
          ? Theme.of(context).primaryColor.withOpacity(0.5)
          : Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      child: Text(
        !isValid ? "ENTER PHONE NUMBER" : "CONTINUE",
        style: TextStyle(
            color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        // расскоментить ниже чтобы работала авторизация
        if (isValid) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPScreen(
                  mobileNumber: _phoneNumberController.text,
                ),
              ));
        } else {
          validate();
        }
      },
      padding: EdgeInsets.all(16.0),
    );
  }
}
