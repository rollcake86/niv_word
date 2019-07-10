import 'package:niv_word/database/WordModel.dart';

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> database;

  void createDB() async {
    Future<Database> databse = openDatabase(
      join(await getDatabasesPath(), 'word_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          "CREATE TABLE words(id INTEGER PRIMARY KEY, eng TEXT, kor TEXT ,favorite INT)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    this.database = databse;
  }

  Future<void> insertWord(Word word) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'words',
      word.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Word>> words() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('words');
    return List.generate(maps.length, (i) {
      return Word(
        id: maps[i]['id'],
        engWord: maps[i]['eng'],
        korWord: maps[i]['kor'],
        favorite: maps[i]['favorite'],
      );
    });
  }

  Future<void> updateWord(Word word) async {
    // Get a reference to the database.
    final db = await database;
    // Update the given Dog.
    await db.update(
      'words',
      word.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [word.id],
    );
  }
}
