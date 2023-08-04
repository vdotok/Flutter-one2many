import 'package:flutter/material.dart';
import 'package:flutter_one2many/src/constants/constant.dart';
import 'package:flutter_one2many/src/core/config/config.dart';

import 'package:provider/provider.dart';
import '../../core/providers/auth.dart';

class SelecturlScreen extends StatefulWidget {
  @override
  _SelecturlScreenState createState() => _SelecturlScreenState();
}

class _SelecturlScreenState extends State<SelecturlScreen> {
  final GlobalKey<FormState> _loginformkey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  String? _genderRadioBtnVal;
  @override
  void initState() {
    super.initState();
  }

  handlePress() async {
    if (_loginformkey.currentState!.validate()) {
      AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
      auth.login(_emailController.text, _passwordController.text);
      if (auth.getUser!.auth_token == null) {
        setState(() {
          _autoValidate = true;
        });
      }
      // _loginBloc
      //     .add(LoginEvent(_emailController.text, _passwordController.text));
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
    // _authBloc.add(LoadingEvent());
    // Navigator.of(context).pushNamed("/register");
    // _loginBloc.add(LoginLoadingEvent());
  }

  handleRegister() {
    // _loginBloc.add(RegisterScreenEvent());
    // // Navigator.pushNamed(context, "/register");
    // Navigator.of(context).pushNamed("/register");
    Navigator.pushNamed(context, "/register");
  }

  void _handleGenderChange(String? value) {
    setState(() {
      _genderRadioBtnVal = value;
    });

    tenant_url = _genderRadioBtnVal!;
    print("selected gender is $tenant_url");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 100, 0, 100),
            // color: Colors.pink,
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Radio<String>(
                      value: "stenant.vdotok.dev",
                      groupValue: _genderRadioBtnVal,
                      onChanged: _handleGenderChange,
                    ),
                    Text("stenant.vdotok.dev"),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: "http://tenant-api.vdotok.dev/API/",
                      groupValue: _genderRadioBtnVal,
                      onChanged: _handleGenderChange,
                    ),
                    Text("http://tenant-api.vdotok.dev/API/"),
                  ],
                ),
                SizedBox(height: 50),
                SizedBox(
                  width: 300.0,
                  height: 48.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                        primary: redColor),
                    onPressed: () {
                      Navigator.pushNamed(context, "/signin");
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SignInScreen()));
                    },
                    child: Text(
                      "Next",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w300,
                          fontFamily: font_Family,
                          fontStyle: FontStyle.normal,
                          color: whiteColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            )),
      ),
    );
    //   },
    // );
    //   },
    // )
    // );
  }
}
