import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
      home: new HomePage()
  ));
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  String username = "paysafecard";
  List data;
  Map<String, dynamic> user_data;

  Future<String> getData() async {
    var response_user = await http.get(
        Uri.encodeFull("https://api.github.com/users/" + username),
        headers: {
          "Accept": "application/json"
        }
    );

    var response = await http.get(
        Uri.encodeFull("https://api.github.com/users/" + username + "/repos"),
        headers: {
          "Accept": "application/json"
        }
    );

    this.setState(() {
      data = json.decode(response.body);
      user_data = json.decode(response_user.body);
    });

    return "Success!";

  }

  @override
  void initState(){
    this.getData();
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(title: new Text("GitHub Repositories"), backgroundColor: Colors.blue),
      body: Center(
        child: Column(
        children: <Widget>[

          Center(child: Image.network(user_data["avatar_url"], fit: BoxFit.fitWidth)),

          Center(child:Container(padding: EdgeInsets.only(top:30, left: 30, right: 30),
              child:Text( "Username: " + user_data["login"], style: TextStyle(fontWeight: FontWeight.bold)))),

          Center(child:Container(padding: EdgeInsets.only(top:30, left: 30, right: 30),
              child:Text( "Followers: " + user_data["followers"].toString(), style: TextStyle(fontWeight: FontWeight.bold)))),

          Center(child:Container(padding: EdgeInsets.only(top:30, left: 30, right: 30),
              child:Text( "Following: " + user_data["following"].toString(), style: TextStyle(fontWeight: FontWeight.bold)))),


          Expanded(child: ListView.builder(
            padding: EdgeInsets.only(top:30, left: 30, right: 30, bottom: 30),
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int index){
              return new Card(
                child: new Text(data[index]["name"]),
              );
            },
          ),
          )
        ],
        )
      )
    );
  }
}