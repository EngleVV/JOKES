import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: new Center(
          //child: new Text("这是一个段子"),
          child: new RandomWords(),
        ),
      ),
      theme: new ThemeData(
        primaryColor: Colors.red
      ),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  var _suggestions = <String>[];

  final _saved = new Set<WordPair>();

  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {

    setData();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  setData() async {
    _suggestions = await _asyncGetSuggestions();    //getData()延迟执行后赋值给data
  }

  Widget _buildSuggestions() {
    if(_suggestions.length <= 0) {
      return new Text("无内容");
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        final index = i ~/ 2;

        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(String content) {

    return new ListTile(
      title: new Text(
        content,
        style: _biggerFont,
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((pair) {
        return new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Saved Suggestions')
        ),
          body: new ListView(children: divided)
      );
    }));
  }

  _asyncGetSuggestions() async{
    var url = "http://m2.qiushibaike.com/article/list/text";
    var httpClient = new HttpClient();

    String result;

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if(response.statusCode == HttpStatus.OK) {
        var jsonStr = await response.transform(utf8.decoder).join();
        var data = json.decode(jsonStr);


        print(jsonStr);
        final _suggestionsA = <String>[];
        final contents = data['items'];
        contents.forEach((item) {
          _suggestionsA.add(item);
        });

        setState(() {
          _suggestions = _suggestionsA;
        });
      }
    } catch(excption) {
      result = "";
    }

    return _suggestions;
  }
}

class RandomWords extends StatefulWidget {
  @override
  State createState() => new RandomWordsState();
}
