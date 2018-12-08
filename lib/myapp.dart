import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/Api.dart';
import 'package:flutter_app/NetworkUtil.dart';
import 'package:flutter_app/model/Jokes.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: new Center(
          //child: new Text("这是一个段子"),
          child: new JokesList(),
        ),
      ),
      theme: new ThemeData(primaryColor: Colors.red),
    );
  }
}

class JokesListState extends State<JokesList> {
  var jokesData = <Joke>[];

  var currentPage = 1;

  ScrollController  scrollController = new ScrollController();

  JokesListState() {
    scrollController.addListener((){
      var maxScroll  = scrollController.position.maxScrollExtent;
      var pixels = scrollController.position.pixels;

      //print("maxScroll = $maxScroll pixels = $pixels");
      if(maxScroll == pixels) {
        print("滑到底了");
        currentPage++;
        asyncGetJokesData(true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    asyncGetJokesData(false);
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('糗事百科'),
      ),
      body: buildJokesData(),
    );
  }

  Widget buildJokesData() {
    if (jokesData.length <= 0) {
      return new Center(
        // CircularProgressIndicator是一个圆形的Loading进度条
        child: new CircularProgressIndicator(),
      );
    }

    Widget listView = ListView.builder(
        itemCount: jokesData.length,
        itemBuilder: (context, i) {
          return buildRow(jokesData[i]);
        },
        controller: scrollController,);

    return new RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
  }

  Widget buildRow(Joke joke) {
    return new ListTile(
      title: new Card(
          child: new Column(
            children: <Widget>[
              new Padding(
                  padding: EdgeInsets.only(top: 10, left: 10),
                  child: new Row(
                    children: <Widget> [
                      new Icon(Icons.contact_mail),
                      new Text("   "),
                      new Text(joke.name)
                    ])
              ),
              new Padding(
                padding: EdgeInsets.all(10),
                child: new Text(joke.content,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ),
            ],
          )
      )
    );
  }

  asyncGetJokesData(bool isLoadMore) async {

    Map<String, String> params = new Map();
    params.putIfAbsent("page", ()=>"$currentPage");
    params.putIfAbsent("count", ()=>"12");

    var jsonStr = await NetworkUtil.getJson(Api.textJokesUrl, params);
    var data = json.decode(jsonStr);
    print(jsonStr);
    final tmpJokesData = <Joke>[];
    Joke tmpJoke;
    final contents = data['items'];
    contents.forEach((item) {
      tmpJoke = new Joke();
      tmpJoke.content = item['content'];
      tmpJoke.name = "${item['id']}";
      tmpJokesData.add(tmpJoke);
    });

    setState(() {
      if(isLoadMore) {
        jokesData.addAll(tmpJokesData);
      } else {
        jokesData = tmpJokesData;
      }
    });

    return jokesData;
  }

  Future<void> _pullToRefresh() async{
    currentPage = 1;
    asyncGetJokesData(false);
    return null;
  }
}

class JokesList extends StatefulWidget {
  @override
  State createState() => new JokesListState();
}
