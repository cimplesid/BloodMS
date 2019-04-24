import 'package:bloodms/UI/Widget/customtextfield.dart';
import 'package:bloodms/UI/basescreen.dart';
import 'package:bloodms/UI/login.dart';
import 'package:bloodms/resources/firebase_auth_provider.dart';
import 'package:bloodms/resources/firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:polygon_clipper/polygon_clipper.dart';
import 'package:bloodms/UI/map.dart';
import 'package:bloodms/model/user_model.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  var _email = TextEditingController();
  var _user = TextEditingController();
  var _pass = TextEditingController();
  var _cpass = TextEditingController();
  String logintext = "/LOGIN";
  String signuptext = "SignUp";
  String locname = 'Location';
  bool index = true;
  bool loading = false;
  bool hiddenText = true;
  UserModel user = UserModel(
      id: "",
      name: "",
      blood: "",
      contact: "",
      longitude: 0,
      latitude: 0,
      email: "");
  static const blood = <String>['A+', 'A-', 'B+', 'B-', 'O+', 'O-'];
  final List<DropdownMenuItem<String>> _bloodgroups = blood
      .map(
        (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value,
                  style: TextStyle(
                    color: Colors.red,
                  )),
            ),
      )
      .toList();
  String selectedvalue;
  var _scaffoldkey = GlobalKey<ScaffoldState>();
  void _signup() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
    } else
      return;
    if (_pass.text != _cpass.text) {
      showSnackbar('Password do not match');
    } else {
      try {
        setState(() {
          loading = true;
        });
        var fUser = await FirebaseAuthProvider()
            .signup(_email.text, _pass.text, _user.text);
        FirestoreProvider().addUser(user..id = fUser.uid);

        setState(() {
          _email.text = "";
          _pass.text = "";

          index = true;
          loading = false;
        });
        showSnackbar('Sucessfully signed up login now');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff44130f),
      key: _scaffoldkey,
      body: BaseScreen(
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
                        signuptext,
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        logintext,
                        style: TextStyle(color: Colors.white, fontSize: 19),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                buildSignupForm()
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildSignupForm() {
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
          CustomTextField(
            textCapitalization: TextCapitalization.words,
            controller: _user,
            onSaved: (value) {
              user.name = value;
            },
            label: "Fullname",
            hint: "Ex: Marquees Brownlee",
            onValidate: (value) {
              if (value.isEmpty) return 'This field can\'t be empty';
            },
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextField(
            controller: _email,
            onSaved: (value) {
              user.email = value;
            },
            hint: "Email",
            onValidate: (value) {
              if (value.isEmpty) return 'This field can\'t be empty';
            },
            inputType: TextInputType.emailAddress,
            label: "Email",
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextField(
            controller: _pass,
            label: "Password",
            hint: "Password",
            onValidate: (value) {
              if (value.isEmpty) return 'This field can\'t be empty';
            },
            obscure: hiddenText,
            suffixIcon: IconButton(
              icon: Icon(hiddenText ? MdiIcons.eye : MdiIcons.eyeOff,
                  color: Colors.grey),
              onPressed: () {
                setState(() {
                  hiddenText = !hiddenText;
                });
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CustomTextField(
            controller: _cpass,
            onValidate: (value) {
              if (value.isEmpty) return 'This field can\'t be empty';
            },
            label: "Confirm Password",
            hint: "Re-Enter Password",
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

          //
          SizedBox(
            height: 20,
          ),
          CustomTextField(
            onSaved: (value) {
              user.contact = value;
            },
            onValidate: (value) {
              if (value.length != 10)
                return 'Phone Number must be of 10 digits';
            else  if (value.isEmpty) return 'This field can\'t be empty';
            },
            label: 'Contact',
            hint: 'Ex:9880124587',
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 1))),
            child: DropdownButtonFormField(
              value: selectedvalue,
              hint: Text(
                'Blood Group',
                style: TextStyle(color: Colors.white),
              ),
              items: _bloodgroups,
              onChanged: ((String newvalue) {
                setState(() {
                  selectedvalue = newvalue;
                  print(selectedvalue);
                  user.blood = selectedvalue;
                });
              }),
            ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 1))),
            height: 55,
            child: FlatButton(
              child: Text(locname,
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed: () async {
                var loc = await Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Maps()));
                if (loc != null) {
                  setState(() {
                    locname = "${loc.latitude},${loc.longitude}";
                  });
                  user.latitude = loc.latitude;
                  user.longitude = loc.longitude;
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.yellow)))
                        : IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                            onPressed: _signup,
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

  showErrorDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content:
                  Text('Enter the fields', style: TextStyle(color: Colors.red)),
              actions: <Widget>[
                FlatButton(
                  child: Text('ok'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
              title: Text('Error'));
        });
  }
}
