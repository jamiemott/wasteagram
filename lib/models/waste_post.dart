import 'package:cloud_firestore/cloud_firestore.dart';

class WastePost {
  String imageURL;
  int quantity;
  double latitude;
  double longitude;
  DateTime date;

  WastePost(
      {this.imageURL, this.quantity, this.latitude, this.longitude, this.date});

  /*WastePost.fromFirestore(dynamic document) {
    this.imageURL = document['imageURL'];
    this.quantity = document['quantity'];
    this.latitude = document['latitude'];
    this.longitude = document['longitude'];
    this.date = document['date'].toDate();
  }*/
}