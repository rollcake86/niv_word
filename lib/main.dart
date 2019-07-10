import 'dart:async';

import 'package:flutter/material.dart';
import 'package:niv_word/TabHome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Niv Word',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: Intro(),
    );
  }
}

class Intro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _intro();
  }
}

class _intro extends State<Intro>{

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => bottomHome()));
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      color: Colors.brown,
      child: Center(
        child: Text('Niv Word' , style: TextStyle(fontSize: 25 , color: Colors.white),),
      ),
    );
  }


}