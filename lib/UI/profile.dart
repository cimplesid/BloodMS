import 'package:bloodms/UI/basescreen.dart';
import 'package:bloodms/model/user_model.dart';
import 'package:bloodms/resources/firestore_provider.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserModel donor;

  @override
  void initState() {
    super.initState();
    FirestoreProvider().getUser().then((d) {
      setState(() {
        donor = d;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BaseScreen(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Card(
                elevation: 2,
                child: Container(
                  constraints: BoxConstraints(minHeight: 105),
                  child: Text('Name: ${donor.name}'),
                ),
              ),
              Card(
                clipBehavior: Clip.hardEdge,
                elevation: 2,
                child: Container(
                  constraints: BoxConstraints(minHeight: 105),
                  child: Text('Phone: ${donor.contact}'),
                ),
              ),
              Card(
                elevation: 2,
                borderOnForeground: true,
                child: Container(
                  
                  constraints: BoxConstraints(minHeight: 105),
                  child: Text('Blood Group: ${donor.blood}'),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
