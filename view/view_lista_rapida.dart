import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_list/dao/database_conection_utils.dart';
import 'package:market_list/model/lista_rapida.dart';
import 'package:market_list/model/produto.dart';
import 'package:market_list/view/view_nome_produtos.dart';

class ViewListaRapida extends StatefulWidget {
  @override
  _ViewListaRapidaState createState() => _ViewListaRapidaState();
}

class _ViewListaRapidaState extends State<ViewListaRapida> {
  DatabaseConectionUtils db = DatabaseConectionUtils();
  List<ListaRapida> listaRapida = [];

  @override
  void initState() {
    super.initState();
    _getAllFromListaRapida();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista Rápida"),
          actions: [
            IconButton(
                onPressed: () => removeAllFromListaRapida(),
                icon: Icon(Icons.close)),
            IconButton(
                onPressed: () => dialogOfNewProdutoInListaRapida(),
                icon: Icon(Icons.add_rounded))
          ],
        ),
        body: RefreshIndicator(
          onRefresh: removeComprados,
          child: ListView.builder(
              itemBuilder: (context, index) =>
                  Card(child: generateListTile(listaRapida[index])),
              itemCount: listaRapida.length),
        ));
  }

  void _getAllFromListaRapida() {
    db.selectAllFromListaRapida().then((list) {
      setState(() {
        listaRapida = list;
      });
    });
  }

  Widget generateListTile(ListaRapida rowLista) {
    bool isComprado = rowLista.comprado == 0 ? false : true;

    return CheckboxListTile(
        value: isComprado,
        title: Text(
          rowLista.nomeProduto!,
          style: GoogleFonts.arsenal(fontSize: 20),
        ),
        onChanged: (bool? value) {
          isComprado = value!;
          isComprado == true ? rowLista.comprado = 1 : rowLista.comprado = 0;
          setState(() {
            changeComprado(rowLista);
          });
        });
  }

  Future<void> changeComprado(ListaRapida rowLista) async {
    await db.updateCompradoFromLista(rowLista);
  }

  void dialogOfNewProdutoInListaRapida() {
    var nameController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Insira o nome do produto:"),
            content: TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  selectNameInList().then((String name) {
                    nameController.text = name;
                  });
                },
              )),
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancelar"),) ,
              TextButton(
                  onPressed: () {
                    saveNewProdutoInListaRapida(nameController.text);
                    Navigator.pop(context);
                    _getAllFromListaRapida();
                  },
                  child: Text("Salvar"))
            ],
          );
        });
  }

  Future<void> saveNewProdutoInListaRapida(String nome) async {
    ListaRapida lr = ListaRapida();
    lr.comprado = 0;
    lr.nomeProduto = nome;
    await db.insertNewProdutoToListaRapida(lr);
  }

  Future<void> removeComprados() async {
    await db.deleteCompradosFromListaRapida();
    _getAllFromListaRapida();
  }

  Future<void> removeAllFromListaRapida() async {
    await db.deleteAllFromListaRapida();
    _getAllFromListaRapida();
  }

  Future<String> selectNameInList() async {
    String? nameChoosed = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewNomeProdutosList()));
    if (nameChoosed != null) {
      return nameChoosed;
    } else {
      return '';
    }
  }
}
