import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:wasteagram/screens/detail_post.dart';

class ListContents extends StatefulWidget {
  @override
  _ListContentsState createState() => _ListContentsState();
}

class _ListContentsState extends State<ListContents> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        //Use .orderBy to sort descending from:
        //https://stackoverflow.com/questions/58044290/flutter-sort-data-firestore-with-streambuilder
        stream: Firestore.instance
            .collection('posts')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.documents.length == 0) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: <Widget>[
                Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          var post = snapshot.data.documents[index];
                          DateTime time = post['date'].toDate();
                          return ListTile(
                            trailing: Text(post['quantity'].toString()),
                            title:
                                Text('${DateFormat.yMMMMEEEEd().format(time)}'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailPost(post: post)));
                            },
                          );
                        })),
              ],
            );
          }
        });
  }
}
