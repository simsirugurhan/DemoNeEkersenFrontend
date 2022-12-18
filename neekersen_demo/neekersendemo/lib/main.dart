import 'package:flutter/material.dart';
import 'package:neekersendemo/screens/city/city_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ne Ekersen Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CityPage(),
    );
  }
}
