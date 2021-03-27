import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(/*title: 'Flutter Demo Home Page'*/),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //MyHomePage({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _url = "https://owlbot.info/api/v4/dictionary/";
  String token = "a0572f28de980d5e7fc13bf54364e84cda773ce3";

  TextEditingController _searchController = TextEditingController();
  StreamController _streamController;
  Stream _stream;
  int statusCode = 0;

  void _search() async {
    if (_searchController.text == null || _searchController.text.length == 0) {
      _streamController.add(null);
      return;
    } else {
      _streamController.add("waiting");
      Response response = await get(
          Uri.parse(_url + _searchController.text.trim()),
          headers: {"Authorization": "Token " + token});
      setState(() {
        statusCode = response.statusCode;
      });
      print(response.statusCode);
      print(response.body);
      _streamController.add(json.decode(response.body));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _streamController = StreamController();
    _stream = _streamController.stream;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dictionary"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 12, bottom: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24)),
                  child: TextFormField(
                    onChanged: (value) {
                      print("Textfiled value changed");
                    },
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (value) {
                      _search();
                    },
                    decoration: InputDecoration(
                        hintText: "Type a word to be Searched",
                        contentPadding: EdgeInsets.only(left: 24.0),
                        border: InputBorder.none),
                    controller: _searchController,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                color: Colors.white,
                onPressed: () {
                  print("search button pressed");
                  _search();
                },
              )
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(9),
        child: StreamBuilder(
          stream: _stream,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Text("Enter a word to be searched!"),
              );
            } else if (snapshot.data == "waiting") {
              return Center(child: CircularProgressIndicator());
            } else if (statusCode == 404) {
              return Center(
                child: Text("Word Searched Not Available"),
              );
            } else if (statusCode == 200) {
              return ListView.builder(
                itemCount: snapshot.data["definitions"].length,
                itemBuilder: (context, index) {
                  return ListBody(
                    children: [
                      Container(
                        color: Colors.grey[300],
                        child: ListTile(
                          leading: snapshot.data["definitions"][index]
                                      ["image_url"] ==
                                  null
                              ? null
                              : CircleAvatar(
                                  foregroundImage: NetworkImage(snapshot
                                      .data["definitions"][index]["image_url"]),
                                ),
                          title: Text(_searchController.text +
                              "(" +
                              snapshot.data["definitions"][index]["type"] +
                              ")"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(9),
                        child: Text(
                            snapshot.data["definitions"][index]["definition"]),
                      )
                    ],
                  );
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
