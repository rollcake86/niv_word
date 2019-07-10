


import 'package:niv_word/database/DatabseHelper.dart';

class Word {
  final int id;
  final String engWord;
  final String korWord;
  final int favorite;

  Word({this.id, this.engWord, this.korWord, this.favorite});

  Map<String , dynamic> toMap(){
    return {
      'id' : id,
      'eng' : engWord,
      'kor' : korWord,
      'favorite' : favorite
    };
  }

  @override
  String toString() {
    return 'Word{id: $id, eng: $engWord, kor: $korWord , favorite : $favorite}';
  }

}