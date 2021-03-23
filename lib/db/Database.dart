import 'dart:io';
import 'package:app_notes/models/Notes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  //* Criando a instacia
  DatabaseHelper._createInstace();

  //* Criando para facilitar na hora de fazer os codigos a tabela e as colunas
  String notaTabela = 'nota';
  String colId = 'id';
  String colTitulo = 'titulo';
  String colDescricao = 'descricao';

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstace();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  // Inicializando o Banco de dados
  Future<Database> initializeDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'newNota.db';

    var notasDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notasDatabase;
  }

  //CRIANDO TABLE E AS COLUNAS
  Future _createDb(Database db, int newVersion) async {
    await db.execute('''
          CREATE TABLE $notaTabela (
            $colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $colTitulo TEXT ,
            $colDescricao TEXT
          )
          ''');
  }

  //* OPERAÇOES CRUD

  //incluindo uma nota no banco de dados
  Future<int> incrementNota(Note note) async {
    Database db = await this.database;
    var resultado = await db.insert(notaTabela, note.toMap());
    return resultado;
  }

  //retornando todas as nota pelo ID
  Future<List<Note>> getAllNotes() async {
    Database db = await this.database;

    var resultado = await db.query(notaTabela);
    List<Note> lista = resultado.isNotEmpty
        ? resultado.map((n) => Note.fromMap(n)).toList()
        : [];

    return lista;
  }

  //retornando uma nota pelo ID
  Future<Note> getOneNotes(int id) async {
    Database db = await this.database;
    List<Map> maps = await db.query(
      notaTabela,
      columns: [colId, colTitulo, colDescricao],
      where: "$colId = ?",
      whereArgs: [id],
    );
    if (maps.length > 0) {
      return Note.fromMap(maps.first);
    } else {
      return null;
    }
  }

  //Atualizar o notas existente
  Future<int> updateNote(Note note) async {
    var db = await this.database;

    var resultado = await db.update(
      notaTabela,
      note.toMap(),
      where: "$colId = ?",
      whereArgs: [note.id],
    );
    return resultado;
  }

  //Deleta a nota existente
  Future<int> deleteNote(int id) async {
    var db = await this.database;

    var resultado = await db.delete(
      notaTabela,
      where: "$colId = ?",
      whereArgs: [id],
    );
    return resultado;
  }

  //obter quantos contatos tem no banco de dados
  Future<int> getCoutNotes() async {
    var db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $notaTabela');
    int resultado = Sqflite.firstIntValue(x);
    return resultado;
  }

  Future close() async {
    var db = await this.database;
    db.close();
  }
}
