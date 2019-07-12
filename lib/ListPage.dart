import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'database/DatabseHelper.dart';
import 'database/WordModel.dart';

class MyHomePage extends StatefulWidget {
  final List<Word> word;
  final DatabaseHelper databaseHelper;

  const MyHomePage({Key key, this.word, this.databaseHelper}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum TtsState { playing, stopped }

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();

  List<Word> wordList = new List();

  FlutterTts flutterTts;
  dynamic languages;
  dynamic voices;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  @override
  void initState() {
    super.initState();
    _copyList();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    if (Platform.isAndroid) {
      flutterTts.ttsInitHandler(() {
        _getLanguages();
        _getVoices();
      });
    } else if (Platform.isIOS) {
      _getLanguages();
      _getVoices();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
  }

  _copyList() async {
    setState(() {
      wordList = widget.word;
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.setLanguage("en-US");
    if (languages != null) setState(() => languages);
    await flutterTts.isLanguageAvailable("en-US");
  }

  Future _getVoices() async {
    voices = await flutterTts.getVoices;
    if (voices != null) setState(() => voices);
  }

  Future _speak(String _test) async {
    if (_test != null) {
      if (_test.isNotEmpty) {
        var result = await flutterTts.speak(_test);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {},
              onEditingComplete: () {
                _changeList(controller.value.text);
              },
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "단어 검색",
                  hintText: "알파벳을 검색하세요",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: wordList.length,
                  itemBuilder: (BuildContext context, int index) {
                    print(wordList.length);

                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    wordList[index].engWord,
                                    style: TextStyle(
                                      textBaseline: TextBaseline.alphabetic,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 22),
                                  ),
                                  Text(
                                    wordList[index].korWord,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              onTap: () {
                                _speak(wordList[index].engWord);
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                child: Padding(padding: EdgeInsets.all(10) , child: Text(
                                  '즐겨찾기 추가',
                                  style: TextStyle(color: Colors.white),
                                ),),
                                color: Colors.brown,
                              ),
                              onTap: () {
                                Word word = new Word(
                                    id: wordList[index].id,
                                    korWord: wordList[index].korWord,
                                    engWord: wordList[index].engWord,
                                    favorite: 1);
                                widget.databaseHelper.insertWord(word);
                                Scaffold.of(context).showSnackBar(new SnackBar(
                                  content: new Text("즐겨찾기에 추가되었습니다"),
                                  duration: new Duration(seconds: 1),
                                ));
                              },
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ),
                    );
                  }))
        ],
      )),
    );
  }

  void _changeList(String value) async {
    print(value);
    setState(() {
      if (value.length == 0) {
        wordList = new List();
        wordList = widget.word;
      } else {
        wordList = new List();
        for (Word i in widget.word) {
          if (i.engWord.contains(value)) {
            wordList.add(i);
          }
        }
        print('list');
        print(wordList.length);
      }
    });
  }

  String getKorText(String korWord) {
    if (korWord.length > 10) {
      return korWord.substring(0, 9) + "...";
    } else {
      return korWord;
    }
  }
}

class DetailScreen extends StatelessWidget {
  String engWord;
  String korWord;

  DetailScreen(this.engWord, this.korWord);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: GestureDetector(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              engWord,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              korWord,
              style: TextStyle(fontSize: 20),
            ),
          ],
        )),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
