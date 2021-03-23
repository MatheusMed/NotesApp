import 'package:app_notes/models/Notes.dart';
import 'package:flutter/material.dart';

class NotasPage extends StatefulWidget {
  final Note notas;
  NotasPage({this.notas});

  @override
  _NotasPageState createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _titleFocus = FocusNode();

  bool editado = false;
  Note _editaNota;

  @override
  void initState() {
    super.initState();

    if (widget.notas == null) {
      _editaNota = Note('', '');
    } else {
      _editaNota = Note.fromMap(widget.notas.toMap());

      _tituloController.text = _editaNota.titulo;
      _descricaoController.text = _editaNota.descricao;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editaNota.titulo == '' ? "Criando Nova Nota" : 'Editando Nota',
        ),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                if (_editaNota.titulo != null &&
                    _editaNota.titulo.isNotEmpty &&
                    _editaNota.descricao != null &&
                    _editaNota.descricao.isNotEmpty) {
                  Navigator.pop(context, _editaNota);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Color(0xff2b3752),
                      // behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'OK',
                        textColor: Colors.blueAccent,
                        onPressed: () {},
                      ),
                      content: Text(
                        'Nota Salva!',
                        style: TextStyle(color: Colors.white),
                      )));
                } else {
                  _exibirAviso();
                  FocusScope.of(context).requestFocus(_titleFocus);
                }
              },
              child: Icon(
                Icons.check,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _tituloController,
              focusNode: _titleFocus,
              decoration: InputDecoration(
                  hintText: 'Nota', labelText: "Digite a Sua Nota"),
              onChanged: (text) {
                editado = true;
                setState(() {
                  _editaNota.titulo = text;
                });
              },
            ),
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(
                  hintText: 'Descriçao', labelText: "Digite sua Descriçao"),
              onChanged: (text) {
                editado = true;
                _editaNota.descricao = text;
              },
            ),
          ],
        ),
      ),
    );
  }

  void _exibirAviso() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Titulo e Descriçao',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Informe o titulo e a Descriçao da nota por favor',
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Fechar',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
            ],
          );
        });
  }
}
