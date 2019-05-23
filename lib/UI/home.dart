import 'package:bloodms/UI/login.dart';
import 'package:bloodms/UI/profile.dart';
import 'package:bloodms/resources/firebase_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'donors.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoggedIn = false;
  var _scaffoldkey = GlobalKey<ScaffoldState>();

  getUser() async {
    var user = await FirebaseAuthProvider().getCurrentUser();
    if (user == null) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  showErrorDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Text('You must Login to continue !',
                  style: TextStyle(color: Colors.red)),
              actions: <Widget>[
                FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    }),
              ],
              title: Text(
                'Oops',
                style: TextStyle(fontWeight: FontWeight.bold),
              ));
        });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  showSnackbar(message) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.purple,
      content: Text(message ?? "Something went wrong, try again later."),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
          'BloodMS',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          isLoggedIn
              ? SizedBox()
              : IconButton(
                  icon: Icon(MdiIcons.logout),
                  onPressed: () async {
                    await FirebaseAuthProvider().logout();
                    showSnackbar('You are logged out');

                    getUser();
                  })
        ],
        backgroundColor: Colors.red.shade900,
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            // This is our main page
            children: <Widget>[
              Expanded(
                child: Material(
                  color: Colors.green.shade500,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Donor()));
                    },
                    child: Center(
                      child: Container(
                        decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Colors.white, width: 5.0)),
                        padding: new EdgeInsets.all(20.0),
                        child: Text('Need',
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                      ),
                    ),
                  ),
                ),
              ),
              Divider(height: 3),
              Expanded(
                child: Material(
                  color: Colors.redAccent.shade400,
                  child: InkWell(
                    onTap: () async {
                      var user = await FirebaseAuthProvider().getCurrentUser();
                      print(user);
                      if (user == null) {
                        showErrorDialog();
                      } else {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Profile()));
                      }
                    },
                    child: Center(
                      child: Container(
                        decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Colors.white, width: 5.0)),
                        padding: new EdgeInsets.all(20.0),
                        child: Text('Donate',
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                      ),
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
}
