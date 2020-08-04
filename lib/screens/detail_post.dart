import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPost extends StatelessWidget {
  DocumentSnapshot post;

  DetailPost({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime time = post['date'].toDate();
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Wasteagram')),
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
                    Container(
                        width: MediaQuery.of(context).size.height * 0.4,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Semantics(
                          image: true,
                          label: 'Picture of items that were wasted',
                          child: Image.network(
                            post['imageURL'],
                            fit: BoxFit.cover,
                          ),
                        )),
                    Text(post['quantity'].toString()),
                    Text('Location: (${post['latitude'].toString()}, '
                        '${post['longitude'].toString()})')
                  ],
                ))));
  }
}
