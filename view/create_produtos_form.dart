import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_list/model/produto.dart';

class CreateProdutosForm extends StatefulWidget {
  final Produto? produto;

  CreateProdutosForm({this.produto});

  @override
  _CreateProdutosState createState() => _CreateProdutosState();
}

class _CreateProdutosState extends State<CreateProdutosForm> {
  final _nameController = TextEditingController();
  final _qtdRecControler = TextEditingController();
  bool isGeral = false;

  bool _isProdEdited = false;

  final _focusToName = FocusNode();

  Produto _produto = Produto();

  @override
  void initState() {
    super.initState();

    if (widget.produto != null) {
      _produto = Produto.fromMap(widget.produto!.toMap());

      _produto.geral == 0 ? isGeral = false : isGeral = true;
      _nameController.text = _produto.nome;
      _qtdRecControler.text = _produto.qtdRec.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title:
                Text(_produto.nome.isEmpty ? "Nome Do Produto" : _produto.nome),
            actions: [
              IconButton(onPressed: saveProdutoEdited, icon: Icon(Icons.save))
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                TextField(
                    controller: _nameController,
                    focusNode: _focusToName,
                    decoration: InputDecoration(labelText: "Nome do Produto"),
                    maxLength: 50,
                    onChanged: (text) {
                      _isProdEdited = true;
                      setState(() {
                        _produto.nome = text;
                      });
                    }),
                TextField(
                    controller: _qtdRecControler,
                    decoration: InputDecoration(
                        labelText: "Quantidade recomendada do produto: "),
                    maxLength: 5,
                    onChanged: (text) {
                      _isProdEdited = true;
                      setState(() {
                        _produto.qtdRec = int.parse(text);
                      });
                    },
                    keyboardType: TextInputType.phone),
                CheckboxListTile(
                    title: Text("Aparece na lista geral?"),
                    value: isGeral,
                    onChanged: (bool? value) {
                      setState(() {
                        isGeral = value!;
                      });
                    })
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  void saveProdutoEdited() {
    if (_produto.nome != null && _produto.nome.isNotEmpty) {
      isGeral == true ? _produto.geral = 1 : _produto.geral = 0;
      Navigator.pop(context, _produto);
    } else {
      FocusScope.of(context).requestFocus(_focusToName);
    }
  }

  Future<bool> _requestPop() {
    if (_isProdEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
