import 'package:anotacoes/helper/AnotacaoHelper.dart';
import 'package:anotacoes/model/Anotacao.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _controllerTitulo = TextEditingController();
  TextEditingController _controllerDescricao = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> anotacoes = List<Anotacao>();

  _recuperarAnotacoes() async{
    List anotacoesRecuperadas = await _db.recuperarAnotacoes();
    List<Anotacao> listaTemporaria = List<Anotacao>();
    for(var item in anotacoesRecuperadas){
        Anotacao anotacao = Anotacao.fromMap(item);
        listaTemporaria.add(anotacao);
    }
    setState(() {
      anotacoes = listaTemporaria;
    });
    listaTemporaria = null;
  }

  _salvarAnotacao() async{
    String titulo = _controllerTitulo.text;
    String descricao = _controllerDescricao.text;

    Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
    int resultadoDb = await _db.salvarAnotacao(anotacao);

    _controllerTitulo.clear();
    _controllerDescricao.clear();

    _recuperarAnotacoes();

  }

  _exibirTelaCadastro(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Adicionar Anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _controllerTitulo,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Título",
                    hintText: "Digite titulo..."
                  ),
                ),
                TextField(
                  controller: _controllerDescricao,
                  decoration: InputDecoration(
                    labelText: "Descrição",
                    hintText: "Digite a descrição"
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar")
              ),
              FlatButton(
                  onPressed: (){
                    _salvarAnotacao();
                    Navigator.pop(context);
                  },
                  child: Text("Salvar")
              )
            ],
          );
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: anotacoes.length,
                  itemBuilder: (context, index){

                    final anotacao = anotacoes[index];

                    return Card(
                      child: ListTile(
                        title: Text(anotacao.titulo),
                        subtitle: Text("${anotacao.data} - ${anotacao.descricao}"),
                      ),
                    );
                  }
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){
          _exibirTelaCadastro();
        },
      ),
    );
  }
}
