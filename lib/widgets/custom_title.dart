import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Add up the total items for appBar title
class CustomTitle extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    int totalWasted;
    return StreamBuilder(
      stream: Firestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        //Set to zero so count is reset each time page changes, loop to add
        totalWasted = 0;
        if (snapshot.hasData && snapshot.data.documents.length > 0) {
          for (int i = 0; i < snapshot.data.documents.length; i++) {
            totalWasted += snapshot.data.documents[i]['quantity'];
          }
        }
        return Text('Wasteagram - $totalWasted');
      },
    );
  }
}