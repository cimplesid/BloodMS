import 'package:bloodms/UI/basescreen.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BaseScreen(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              
            ],
          ),
        ),
      ),
    ));
  }
}
