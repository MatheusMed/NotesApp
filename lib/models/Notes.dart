import 'dart:convert';

// ignore: todo
//TODO: CRIAÇAO DA CLASS DE MODELO

class Note {
  int id;
  String titulo;
  String descricao;

  Note(this.descricao, this.titulo);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
    };
    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    titulo = map['titulo'];
    descricao = map['descricao'];
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() => 'Note(id: $id, titulo: $titulo, descricao: $descricao)';
}
