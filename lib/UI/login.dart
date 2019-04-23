import 'package:bloodms/UI/Widget/customtextfield.dart';
import 'package:bloodms/UI/basescreen.dart';
import 'package:bloodms/UI/donors.dart';
import 'package:bloodms/UI/home.dart';
import 'package:bloodms/UI/profile.dart';
import 'package:bloodms/UI/signup.dart';
import 'package:bloodms/resources/firebase_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:polygon_clipper/polygon_border.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String logintext = "LOGIN";
  String signuptext = "/SignUp";

  bool loading = false;
  bool hiddenText = true;
  var email = "", password = "";
  var _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff44130f),
      key: _scaffoldkey,
      body: BaseScreen(
        child: Container(
          foregroundDecoration: BoxDecoration(color: Colors.black12),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Text(
                          logintext,
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          signuptext,
                          style: TextStyle(color: Colors.white, fontSize: 19),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signup()));
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  buildLoginForm()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (email.isEmpty || password.isEmpty) {
      showSnackbar("Email and password cannot empty");
    } else {
      try {
        setState(() {
          loading = true;
        });

        await FirebaseAuthProvider().login(email, password);
        setState(() {
          loading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } catch (err) {
        setState(() {
          loading = false;
        });
        showSnackbar(err.message);
      }
    }
  }

  showSnackbar(message) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(message ?? "Something went wrong, try again later."),
    ));
  }

  Column buildLoginForm() {
    return Column(
      children: <Widget>[
        CustomTextField(
          onChanged: (value) {
            email = value;
          },
          label: 'Email',
        ),
        SizedBox(
          height: 20,
        ),
        CustomTextField(
          onChanged: (value) {
            password = value;
          },
          label: 'Passsword',
          obscure: hiddenText,
          suffixIcon: IconButton(
            icon: Icon(
              hiddenText ? MdiIcons.eye : MdiIcons.eyeOff,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                hiddenText = !hiddenText;
              });
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
              child: Text(
                'Forgot Password ?',
                style: TextStyle(color: Colors.red),
              ),
              onTap: showForgorPassword,
            )
          ],
        ),
        SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              height: 90,
              child: ClipPolygon(
                sides: 6,
                rotate: 120,
                borderRadius: 9.0,
                child: Container(
                  color: Colors.red,
                  child: loading
                      ? Center(
                          child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.yellow),
                        ))
                      : IconButton(
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                          onPressed: _login,
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  showForgorPassword() {
    showDialog(
        context: context,
        builder: (context) {
          var email1 = "";
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Forgot password ?",
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    email1 = value;
                  },
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Your email address"),
                ),
                SizedBox(height: 15),
                ButtonTheme(
                  child: FlatButton(
                    color: Colors.deepOrange,
                    onPressed: () async {
                      if (email1.isEmpty) {
                        showSnackbar('Email is empty');
                      } else {
                        try {
                          setState(() {
                            loading = true;
                          });
                          await FirebaseAuthProvider().resetPassword(email);
                          setState(() {
                            loading = false;
                          });
                          showSnackbar('Reset Email has been sent ');
                        } catch (e) {
                          setState(() {
                            loading = false;
                          });
                          showSnackbar(e.message);
                        }
                      }

                      Navigator.pop(context);
                    },
                    child: loading
                        ? Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.yellow)))
                        : Text("Reset Password"),
                  ),
                )
              ],
            ),
          );
        });
  }
}
