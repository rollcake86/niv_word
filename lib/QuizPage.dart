import 'package:flutter/material.dart';
import 'dart:math';

import 'database/WordModel.dart';

class QuizPage extends StatefulWidget {
  final List<Word> words;

  const QuizPage({Key key,  this.words}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _quizPage();
  }
}

class _quizPage extends State<QuizPage> {
  int QuizParam = 1;

  int count = 0;
  int allQuiz =1 ;
  String quiz = '';
  int quizNum;

  int answerValue = 1;
  String answer1;
  String answer2;
  String answer3;

  @override
  void initState() {
    super.initState();
    getQuiz();
    getAnswer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  '지금까지 문제 : $allQuiz',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  '맞춘 문제 : $count',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, left: 10, right: 10),
                child: Text(
                  '퀴즈 : $quiz',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                  onPressed:  () {
                    if(answerValue == 1){
                      setState(() {
                        allQuiz ++;
                        count ++;
                      });
                    }else{
                      setState(() {
                        allQuiz ++;
                      });
                    }
                    getQuiz();
                    getAnswer();
                  },
                  child: Text('$answer1'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                  onPressed:  () {
                    if(answerValue == 2){
                      setState(() {
                        allQuiz ++;
                        count ++;
                      });
                    }else{
                      setState(() {
                        allQuiz ++;
                      });
                    }
                    getQuiz();
                    getAnswer();
                  },
                  child: Text('$answer2'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                  onPressed:  () {
                    if(answerValue == 3){
                      setState(() {
                        allQuiz ++;
                        count ++;
                      });
                    }else{
                      setState(() {
                        allQuiz ++;
                      });
                    }
                    getQuiz();
                    getAnswer();
                  },
                  child: Text('$answer3'),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (QuizParam == 1) {
            QuizParam = 2;
          } else {
            QuizParam = 1;
          }
          getQuiz();
          getAnswer();
        },
        child: Icon(Icons.transform),
      ),
    );
  }

  void getQuiz() {
    Random rand = new Random();
    setState(() {
      if (QuizParam == 1) {
        quizNum = rand.nextInt(widget.words.length);
        quiz = widget.words[quizNum].engWord;
      } else {
        quizNum = rand.nextInt(widget.words.length);
        quiz = widget.words[quizNum].korWord;
      }
    });
  }

  void getAnswer() {
    Random random = new Random();
    int answerNum = random.nextInt(2);
    setState(() {
      if (answerNum == 0) {
        answerValue = 1;
        if (QuizParam == 1) {
          answer1 = widget.words[quizNum].korWord;
          answer2 = widget.words[random.nextInt(widget.words.length)].korWord;
          answer3 = widget.words[random.nextInt(widget.words.length)].korWord;
        } else {
          answer1 = widget.words[quizNum].engWord;
          answer2 = widget.words[random.nextInt(widget.words.length)].engWord;
          answer3 = widget.words[random.nextInt(widget.words.length)].engWord;
        }
      } else if (answerNum == 1) {
        answerValue = 2;
        if (QuizParam == 1) {
          answer2 = widget.words[quizNum].korWord;
          answer1 = widget.words[random.nextInt(widget.words.length)].korWord;
          answer3 = widget.words[random.nextInt(widget.words.length)].korWord;
        } else {
          answer2 = widget.words[quizNum].engWord;
          answer1 = widget.words[random.nextInt(widget.words.length)].engWord;
          answer3 = widget.words[random.nextInt(widget.words.length)].engWord;
        }
      } else {
        answerValue = 3;
        if (QuizParam == 1) {
          answer3 = widget.words[quizNum].korWord;
          answer1 = widget.words[random.nextInt(widget.words.length)].korWord;
          answer2 = widget.words[random.nextInt(widget.words.length)].korWord;
        } else {
          answer3 = widget.words[quizNum].engWord;
          answer1 = widget.words[random.nextInt(widget.words.length)].engWord;
          answer2 = widget.words[random.nextInt(widget.words.length)].engWord;
        }
      }
    });
  }

  select(int i) {
    if(answerValue == i){
//      Scaffold.of(context).showSnackBar(new SnackBar(
//        content: new Text("정답입니다"),
//        duration: new Duration(seconds: 1),
//      ));
      setState(() {
        allQuiz ++;
        count ++;
      });
    }else{
//      Scaffold.of(context).showSnackBar(new SnackBar(
//        content: new Text("틀렸습니다"),
//        duration: new Duration(seconds: 1),
//      ));
      setState(() {
        allQuiz ++;

      });
    }
    getQuiz();
    getAnswer();
  }
}
