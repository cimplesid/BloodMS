import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Function(String) onChanged;
  final String label;
  final bool obscure;
  final Widget suffixIcon;
  final TextEditingController controller;
  const CustomTextField(
      {Key key,
      this.onChanged,
      this.label,
      this.obscure = false,
      this.suffixIcon,this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
      child: TextField(
        onChanged: (value) {
          onChanged(value);
        },
        controller: controller,
        style: TextStyle(color: Colors.white),
        obscureText: obscure,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          hintStyle: TextStyle(color: Colors.white),
          
          hintText: label,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
