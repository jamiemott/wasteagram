import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:wasteagram/models/waste_post.dart';
import 'package:wasteagram/widgets/image_display.dart';

class NewEntryForm extends StatefulWidget {
  String url;

  NewEntryForm(String url) {
    this.url = url;
  }

  @override
  _NewEntryFormState createState() => _NewEntryFormState();
}

class _NewEntryFormState extends State<NewEntryForm> {
  final formKey = GlobalKey<FormState>();
  WastePost newPost = WastePost();
  LocationData geoData;
  var geo = Location();

  @override
  void initState() {
    super.initState();
    _getLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('New Post')),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
            ImageDisplay(url: this.widget.url),
            Padding(padding: EdgeInsets.all(10)),
            Form(
              key: formKey,
              child: Column(children: <Widget>[
                Semantics(
                  textField: true,
                  label:
                      'Numeric input field for wasted items, cannot be left blank',
                  child: TextFormField(
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Number of Items',
                          border: OutlineInputBorder()),
                      onSaved: (value) {
                        newPost.quantity = int.tryParse(value);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the number of items';
                        } else {
                          return null;
                        }
                      }))
            ]))
      ])),
      bottomNavigationBar: BottomAppBar(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Semantics(
                  button: true,
                  onTapHint: 'Save new post',
                  label: 'Upload new post button',
                  child: RaisedButton(
                      elevation: 20.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      color: Colors.red,
                      child: Icon(Icons.file_upload, size: 50),
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          newPost.latitude = geoData.latitude;
                          newPost.longitude = geoData.longitude;
                          newPost.imageURL = this.widget.url;
                          newPost.date = DateTime.now();
                          //create post and save to Firebase
                          Firestore.instance
                              .collection('posts')
                              .document()
                              .setData({
                            'date': newPost.date,
                            'latitude': newPost.latitude,
                            'longitude': newPost.longitude,
                            'quantity': newPost.quantity,
                            'imageURL': newPost.imageURL,
                          });
                          Navigator.of(context).pop();
                        }
                      })))),
    );
  }

//Get permissions and location from https://pub.dev/packages/location
  void _getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    try {
      _serviceEnabled = await geo.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await geo.requestService();
        if (!_serviceEnabled) {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return AlertDialog(
                    title: Text('Location Services must be enabled.'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Ok'))
                    ]);
              });
        }
      }

      _permissionGranted = await geo.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await geo.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return AlertDialog(
                    title: Text('Location Services must be enabled.'),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Ok'))
                    ]);
              });
          return;
        }
      }

      geoData = await geo.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      geoData = null;
    }
  }
}
