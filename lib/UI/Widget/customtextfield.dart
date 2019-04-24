import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Function(String) onSaved, onValidate;
  final String label;
  final String hint;
  final bool obscure;
  final Widget suffixIcon;
  final TextEditingController controller;
  final TextCapitalization textCapitalization;
  final TextInputType inputType;
  const CustomTextField(
      {Key key,
      this.onSaved,
      this.label,
      this.obscure = false,
      this.suffixIcon,
      this.controller,
      this.textCapitalization = TextCapitalization.none,
      this.inputType = TextInputType.text,
      this.hint,
      this.onValidate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
      child: TextFormField(
        // autovalidate: true,
        validator: (value) {
          if (onValidate != null) return onValidate(value);
        },
        onSaved: (value) {
          if (onSaved != null) onSaved(value);
        },
        
        keyboardType: inputType,
        textCapitalization: textCapitalization,
        controller: controller,
        style: TextStyle(color: Colors.white),
        obscureText: obscure,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          hintStyle: TextStyle(color: Colors.white),
          hintText: hint,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
