import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  CustomAppBar(this.title);
  final String title;
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.orange.shade900,
        child: ListTile(
          title: Text(title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 40);
}
