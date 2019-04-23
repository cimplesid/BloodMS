import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  final String text ;
  final Future _onTap;

  Button(this.text,this._onTap);

  @override
  Widget build(BuildContext context) {
    return  Expanded( // true button
      child: new Material(
        color: Colors.redAccent,
        child: new InkWell(
          onTap: () => _onTap,
          child: new Center(
            child: new Container(
              decoration: new BoxDecoration(
                border: new Border.all(color: Colors.white, width: 5.0)
              ),
              padding: new EdgeInsets.all(20.0),
              child: new Text( text,
                style: new TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)
              ),
            )
          ),
        ),
      ),
    );
  }
}