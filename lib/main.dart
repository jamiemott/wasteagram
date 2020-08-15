import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasteagram/app.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  //Work in every orientation except upside down
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
  ]);

  //Get Shared preferences for theme mode
  runApp(App(preferences: await SharedPreferences.getInstance()));
}
