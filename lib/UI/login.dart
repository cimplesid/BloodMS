import 'package:bloodms/UI/Widget/customtextfield.dart';
import 'package:bloodms/UI/basescreen.dart';
import 'package:bloodms/UI/home.dart';
import 'package:bloodms/UI/signup.dart';
import 'package:bloodms/resources/firebase_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String loginText = "LOGIN";
  String signupText = "/SignUp";
  bool isLoading = false;
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Text(
                          loginText,
                          style: TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          signupText,
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
                  buildLoginForm(),
                  SizedBox(width: 0.0, height: 0.0),
                  SizedBox(width: 0.0, height: 0.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      try {
        setState(() {
          isLoading = true;
        });

        await FirebaseAuthProvider().login(email, password);
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } catch (err) {
        setState(() {
          isLoading = false;
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

  buildLoginForm() {
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
          CustomTextField(
            onSaved: (value) {
              print(value);
              email = value;
            },
            inputType: TextInputType.emailAddress,
            label: 'Email',
            hint: 'Email',
            onValidate: (value) {
              if (value.isEmpty) return 'This field can\'t be empty';
            },
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextField(
            onSaved: (value) {
              password = value;
            },
            label: 'Passsword',
            hint: 'Passsword',
            onValidate: (value) {
              if (value.isEmpty) return 'This field can\'t be empty';
            },
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
                    child: isLoading
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
      ),
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
                            isLoading = true;
                          });
                          await FirebaseAuthProvider().resetPassword(email);
                          setState(() {
                            isLoading = false;
                          });
                          showSnackbar('Reset Email has been sent ');
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          showSnackbar(e.message);
                        }
                      }

                      Navigator.pop(context);
                    },
                    child: isLoading
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
