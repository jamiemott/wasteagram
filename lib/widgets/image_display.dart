import 'package:flutter/material.dart';

class ImageDisplay extends StatelessWidget {
  String url;

  ImageDisplay({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.height * 0.4,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Semantics(
          image: true,
          label: 'Picture of items that were wasted',
          child: Image.network(url, fit: BoxFit.cover),
        )
    );
  }
}