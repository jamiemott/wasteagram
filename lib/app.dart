import 'package:flutter/material.dart';
import 'package:wasteagram/screens/list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  SharedPreferences preferences;

  App({Key key, @required this.preferences}) : super(key: key);

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  ThemeData data;
  SharedPreferences prefs;

  //Function to handle resetting the theme mode
  getTheme() {
    setState(() {
      prefs = this.widget.preferences;
      //Look to see if the key exists, if so, set mode accordingly
      if (prefs.containsKey('_darkOn')) {
        data = (prefs.getBool("_darkOn") ?? false)
            ? ThemeData.dark()
            : ThemeData.light();
      } else {
        //If no key, enter it and set to light mode
        prefs.setBool('_darkOn', false);
        data = ThemeData.light();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wasteagram',
        theme: data,
        home: ListScreen());
  }
}
