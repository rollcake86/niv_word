import 'package:flutter/material.dart';

import 'database/DatabseHelper.dart';
import 'database/WordModel.dart';

class FavoritePage extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  const FavoritePage({Key key, this.databaseHelper}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _favoritePage();
  }
}

class _favoritePage extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Center(
          // Use future builder and DefaultAssetBundle to load the local JSON file
          child: new FutureBuilder(
              future: getDatabaseList(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('');
                    break;
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                    break;
                  case ConnectionState.active:
                    return Text('');
                    break;
                  case ConnectionState.done:
                    List<Word> new_data = snapshot.data;
                    List<Word> showData = new List();
                    for (Word i in new_data) {
                      if (i.favorite == 1) {
                        showData.add(i);
                      }
                    }
                    return new ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return new Card(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  showData[index].engWord,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20),
                                ),
                                Text(
                                  showData[index].korWord,
                                  style: TextStyle(fontSize: 20),
                                ),
                                GestureDetector(
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                  onTap: () {
                                    Word word = new Word(
                                        id:  showData[index].id,
                                        korWord: showData[index].korWord,
                                        engWord: showData[index].engWord,
                                        favorite: 0);
                                    widget.databaseHelper.updateWord(word);
                                    Scaffold.of(context)
                                        .showSnackBar(new SnackBar(
                                      content: new Text("즐겨찾기에서 제거 되었습니다"),
                                      duration: new Duration(seconds: 1),
                                    ));
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: showData == null ? 0 : showData.length,
                    );
                    break;
                }
                return CircularProgressIndicator();
              }),
        ),
      ),
    );
  }

  Future<List<Word>> getDatabaseList() {
    return widget.databaseHelper.words();
  }
}
