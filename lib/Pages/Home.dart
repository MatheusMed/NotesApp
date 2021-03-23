import 'package:app_notes/Pages/notas_page.dart';
import 'package:app_notes/controllers/theme_controller.dart';
import 'package:app_notes/db/Database.dart';
import 'package:app_notes/models/Notes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var controller = ThemeController.to;

  DatabaseHelper db = DatabaseHelper();
  // ignore: deprecated_member_use
  List<Note> notas = List<Note>();

  @override
  void initState() {
    super.initState();
    _exibirTodasNotas();
  }

  void _exibirTodasNotas() async {
    await db.getAllNotes().then((lista) {
      setState(() {
        notas = lista;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas'),
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: ListTile(
                        leading: Obx(
                          () => controller.isDark.value
                              ? Icon(Icons.brightness_7)
                              : Icon(Icons.brightness_2),
                        ),
                        title: Obx(
                          () => controller.isDark.value
                              ? Text('Tema Branco')
                              : Text('Tema Escuro'),
                        ),
                        onTap: () => controller.changeTheme(),
                      ),
                    ),
                  ]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _exibirContatoPage();
        },
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: notas.length,
        itemBuilder: (context, index) {
          return _listaNotas(context, index);
        },
      ),
    );
  }

  _listaNotas(context, index) {
    return Card(
      child: ListTile(
        title: Text(
          notas[index].titulo ?? '',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(notas[index].descricao ?? ''),
        onTap: () {
          _exibirContatoPage(nota: notas[index]);
        },
        onLongPress: () {
          _confirmarExclusao(context, notas[index].id, index);
        },
      ),
    );
  }

  void _exibirContatoPage({Note nota}) async {
    final notaRecebido = await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => NotasPage(notas: nota),
      ),
    );

    if (notaRecebido != null) {
      if (nota != null) {
        await db.updateNote(notaRecebido);
      } else {
        await db.incrementNota(notaRecebido);
      }
      _exibirTodasNotas();
    }
  }

  void _confirmarExclusao(context, int notasid, index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color(0xff53435b),
            title: Text(
              "Excluir Nota",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            content: Text(
              'Confirmar exclusao de Nota',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
              TextButton(
                  onPressed: () {
                    setState(() {
                      notas.removeAt(index);
                      db.deleteNote(notasid);
                      Navigator.of(context).pop();
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
                            'Excluido com sucesso',
                            style: TextStyle(color: Colors.white),
                          )));
                    });
                  },
                  child: Text(
                    'Excluir',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ))
            ],
          );
        });
  }
}
