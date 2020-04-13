import 'package:flutter/material.dart';

class SimpleSnackBar {
  static void show(ScaffoldState scaffold, String text) {
    scaffold.showSnackBar(SnackBar(content: Text(text)));
  }
}