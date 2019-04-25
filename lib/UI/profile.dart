import 'package:bloodms/UI/basescreen.dart';
import 'package:bloodms/model/user_model.dart';
import 'package:bloodms/resources/firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:polygon_clipper/polygon_border.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  UserModel donor;
  Animation <double> animation;
  AnimationController animaitonController ;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
   
    FirestoreProvider().getUser().then((d) {
      setState(() {
        donor = d;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : BaseScreen(
                child: SafeArea(
                  child: Stack(
                    children: <Widget>[
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.red.shade400,
                                        Colors.purpleAccent,
                                        Colors.green,
                                        Colors.cyanAccent,
                                        Colors.brown,
                                        Colors.deepOrangeAccent,
                                        Colors.orange,
                                        Colors.yellow,
                                        Colors.lightGreen,
                                        Colors.indigoAccent,
                                      ]),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 15.0,
                                      offset: Offset(0.0, 10.0),
                                    ),
                                  ],
                                ),

                                padding: EdgeInsets.all(20),
                                // constraints: BoxConstraints(minHeight: 105),
                                child: Text(
                                  'Name: ${donor.name}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'Phone: ${donor.contact}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Card(
                                elevation: 10,
                                borderOnForeground: true,
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Text('Blood Group: ${donor.blood}'),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                              ),
                              Container(
                                alignment: Alignment.center,
                                // color: Colors.green,
                                child: Icon(
                                  MdiIcons.water,
                                  color: Colors.red.shade700,
                                  size: 220,
                                ),
                              ),
                              Text(
                                '${donor.blood}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      Positioned(
                        bottom: 50,
                        right: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              // alignment: Alignment.bottomCenter,
                              icon: Icon(
                                Icons.edit_location,
                                size: 90,
                              ),
                              color: Color(0xffeebbcc),
                              onPressed: () {},
                            ),
                            SizedBox(height: 29,),
                            Text('Edit',style: TextStyle(color: Color(0xffeebbcc)),)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      // floatingActionButton: Container(
      //   padding: EdgeInsets.all(40),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: <Widget>[
      // IconButton(
      //   alignment: Alignment.bottomCenter,
      //   icon: Icon(
      //     Icons.edit_location,
      //     size: 90,
      //   ),
      //   tooltip: 'Edit',
      //   color: Color(0xffeebbcc),
      //   onPressed: () {},
      // ),
      //       Text('Edit', style: TextStyle(color: Colors.green)),
      //     ],
      //   ),
      // ),
    );
  }
}
