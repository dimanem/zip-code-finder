import 'package:flutter/material.dart';

import 'home/home_page.dart';

void main() => runApp(RoutesWidget());

class RoutesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: "My App",
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: HomePage(),
  );
}