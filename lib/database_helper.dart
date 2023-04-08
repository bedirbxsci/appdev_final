import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import '../models/questions_list.dart';

class DatabaseHelper {
  static const _databaseName = 'user_questions.db';
  static const _databaseVersion = 1;
  static const table = 'questions';
  static const columnName = 'name';
  static const columnQuestions = 'JSON_questions';

  // Singleton instance
  static DatabaseHelper? _instance;
  factory DatabaseHelper() {
    return _instance ??= DatabaseHelper._internal();
  }

  DatabaseHelper._internal();

  // SQLite database
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnName TEXT NOT NULL,
        $columnQuestions TEXT NOT NULL
      )
    ''');
  }
Future<int> insertList(QuestionsList questionsList) async {
  Database? db = await database;
  final jsonString = jsonEncode(questionsList.questions);
  final row = {
    columnName: questionsList.name,
    columnQuestions: jsonString,
  };
  return await db!.insert(table, row);
}

  Future<List<QuestionsList>> queryAllRows() async {
    Database? db = await DatabaseHelper().database;
    List<Map<String, dynamic>> result = await db!.query(table);
    return result.map((row) {
      final questions = jsonDecode(row[columnQuestions]) as List;
      final name = row[columnName] as String;
      return QuestionsList(questions,name);
    }).toList();
  }
}