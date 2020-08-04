import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:wasteagram/widgets/custom_title.dart';
import 'package:wasteagram/widgets/list_contents.dart';
import 'new_entry_form.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  File image;

  Future<String> getImage() async {
    image = await ImagePicker.pickImage(source: ImageSource.camera);
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(Path.basename(image.path));
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    final url = await storageReference.getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: CustomTitle(),
        ),
        body: ListContents(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Semantics(
            button: true,
            onTapHint: 'Take a photo',
            label: 'Take a new photo',
            child: FloatingActionButton(
                child: Icon(Icons.camera_alt),
                onPressed: () async {
                  String url = await getImage();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewEntryForm(url)));
                })
        )
    );
  }
}
