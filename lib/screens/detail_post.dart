import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:wasteagram/widgets/image_display.dart';

class DetailPost extends StatelessWidget {
  DocumentSnapshot post;

  DetailPost({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime time = post['date'].toDate();
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Wasteagram')
        ),
        body: Center(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('${DateFormat.yMMMMEEEEd().format(time)}',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    ImageDisplay(url: post['imageURL']),
                    Text("${post['quantity']} items", style: TextStyle(
                      fontSize: 20)),
                    Text('Location: (${post['latitude'].toString()}, '
                        '${post['longitude'].toString()})')
                  ],
                )
            )
        )
    );
  }
}
