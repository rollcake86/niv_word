import 'package:flutter/material.dart';
import 'package:niv_word/FavoritePage.dart';
import 'package:niv_word/ListPage.dart';
import 'package:niv_word/QuizPage.dart';

import 'database/DatabseHelper.dart';
import 'database/WordModel.dart';
import 'package:firebase_admob/firebase_admob.dart';

class bottomHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _bottomApp();
  }
}

class _bottomApp extends State<bottomHome> with SingleTickerProviderStateMixin {
  TabController tabController;
  DatabaseHelper databaseHelper = new DatabaseHelper();


  BannerAd _bannerAd;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = createBannerAd()..load();
    tabController = new TabController(length: 3, vsync: this);
    _loadData();
    databaseHelper.createDB();

    _showAD();
  }

  var array;
  List<Word> words = new List();

  void _loadData() async {
    String data =
        await DefaultAssetBundle.of(context).loadString('repo/niv.txt');
    setState(() {
      var array = data.toString().split("\n");
      for (int i = 0; i < array.length; i++) {
        var blankWord = array[i].indexOf(" ");
        words.add(Word(id: i , engWord:array[i].substring(0, blankWord) , korWord: array[i].substring(blankWord, array[i].length) , favorite: 0 ));
      }
    });
  }

  void _showAD(){
    _bannerAd ??= createBannerAd();
    _bannerAd
      ..load()
      ..show(anchorOffset: 30, anchorType: AnchorType.top);
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: new TabBarView(
        children: <Widget>[
          new MyHomePage(
            word: words,
            databaseHelper: databaseHelper,
          ),
          new QuizPage(words: words,),
          new FavoritePage(databaseHelper: databaseHelper,)
        ],
        controller: tabController,
      ),
      bottomNavigationBar: new Material(
        color: Colors.brown,
        child: new TabBar(
          tabs: <Tab>[
            new Tab(
              icon: new Icon(Icons.list),
            ),
            new Tab(
              icon: new Icon(Icons.border_color),
            ),
            new Tab(
              icon: new Icon(Icons.save),
            ),
          ],
          controller: tabController,
        ),
      ),
    );
  }
}
