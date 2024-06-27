import 'package:flutter/material.dart';
import 'package:math_test/view/pages/home_page.dart';

void main() => runApp(MaterialApp(
      builder: (_, child) => MediaQuery.withNoTextScaling(child: child!),
      theme: ThemeData(useMaterial3: false),
      home: const HomePage(),
    ));
