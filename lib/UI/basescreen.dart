import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:polygon_clipper/polygon_clipper.dart';

class BaseScreen extends StatefulWidget {
  final Widget child;
  BaseScreen({this.child});
  @override
  _BasescreenState createState() => _BasescreenState();
}

class _BasescreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff44130f),
      child: Stack(overflow: Overflow.visible, children: <Widget>[
        Align(
          alignment: Alignment.topRight,
          child: FractionalTranslation(
            translation: Offset(0.35, -0.20),
            child: Container(
              child: SizedBox(
                height: 300,
                child: ClipPolygon(
                  sides: 6,
                  rotate: 120,
                  borderRadius: 15,
                  child: Container(
                    // alignment: Alignment.bottomLeft,
                    color: Colors.red,
                    child: Icon(MdiIcons.water),
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: FractionalTranslation(
            translation: Offset(-.50, 0.45),
            child: Container(
              child: SizedBox(
                height: 300,
                width: 300,
                child: ClipPolygon(
                  sides: 6,
                  rotate: 300,
                  borderRadius: 15,
                  child: Container(
                    color: Colors.red,
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Icon(
                        MdiIcons.water,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 900,
          child: SizedBox(
            height: 100,
            child: ClipPolygon(
              sides: 6,
              rotate: 120,
              borderRadius: 20,
              child: Container(
                child: SizedBox(
                  height: 2,
                ),
              ),
            ),
          ),
        ),
        Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
              child: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height),
                  child: widget.child)),
        ),
      ]),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();

    p.moveTo(size.width / 2, 0);
    p.arcToPoint(Offset(-20, -20));
    p.lineTo(size.width, size.height / 3);
    p.lineTo(size.width, size.width * 2 / 3);
    p.lineTo(size.width / 2, size.height);
    p.lineTo(0, size.height * 2 / 3);
    p.lineTo(0, size.height / 3);
    p.lineTo(size.width / 2, 0);
    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
