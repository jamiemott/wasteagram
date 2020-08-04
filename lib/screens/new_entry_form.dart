import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:wasteagram/models/waste_post.dart';

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

  //Get permissions and location from https://pub.dev/packages/location
  void _getLocation() async {
    var geo = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await geo.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await geo.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await geo.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await geo.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    geoData = await geo.getLocation();
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('New Post'))),
      body: Column(children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.height * 0.4,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Semantics(
              image: true,
              label: 'Picture of items that were wasted',
              child: Image.network(
                this.widget.url,
                fit: BoxFit.cover,
              ),
            )),
        Padding(padding: EdgeInsets.all(10)),
        Form(
            key: formKey,
            child: Column(children: <Widget>[
              TextFormField(
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
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
                  })
            ]))
      ]),
      bottomNavigationBar: BottomAppBar(
          child: Semantics(
              button: true,
              onTapHint: 'Save new post',
              label: 'Upload new post button',
              child: RaisedButton(
                  color: Colors.greenAccent,
                  child: Icon(Icons.file_upload),
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
                  }))),
    );
  }
}
