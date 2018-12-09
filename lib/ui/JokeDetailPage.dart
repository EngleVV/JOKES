import 'package:flutter/material.dart';

class JokeDetailPage extends StatelessWidget {
  final String content;

  JokeDetailPage({Key key, @required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: new Center(
          child: new Scaffold(
            appBar: new AppBar(
              title: new Text("详情"),
            ),
            body: buildJokeDetailUI(),
          ),
        ),
      ),
      theme: new ThemeData(primaryColor: Colors.red),
    );
  }

  Widget buildJokeDetailUI() {
    return new Padding(
      padding: EdgeInsets.all(10),
      child: new Text(content),
    );
  }
}
