import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  CustomTextField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Color.fromRGBO(243, 244, 245, 1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(36.0),
            borderSide: BorderSide(color: Color.fromRGBO(231, 231, 231, 1)),
          ),
        ),
      ),
    );
  }
}
