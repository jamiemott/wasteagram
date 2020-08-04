import 'package:flutter/material.dart';
import 'package:wasteagram/screens/list_screen.dart';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wasteagram',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: ListScreen()
    );
  }
}