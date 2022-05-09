import 'package:flutter/material.dart';

class AppText {
  static TextStyle H1({Color color = Colors.black}) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 22,
      color: color
    );
  }
  static TextStyle H2({Color color = Colors.black}) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 19,
      color: color
    );
  }
  static TextStyle H5({Color color = Colors.black}) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 13,
      color: color
    );
  }
  static TextStyle H4({Color color = Colors.black}) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: color
    );
  }
}