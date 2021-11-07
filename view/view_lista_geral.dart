import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_list/dao/database_conection_utils.dart';
import 'package:market_list/model/lista_geral.dart';
import 'package:market_list/model/produto.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class ViewListaGeral extends StatefulWidget {
  const ViewListaGeral({Key? key}) : super(key: key);

  @override
  _ViewProdutoState createState() => _ViewProdutoState();
}

class _ViewProdutoState extends State<ViewListaGeral> {
  DatabaseConectionUtils dbCon = DatabaseConectionUtils();

  List<Produto> produtos = [];
  List<TextEditingController> textControlerList = [];
  List<int> avaliableValuesList = [];

  @override
  void initState() {
    super.initState();
    _getProdutosGeral();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista Geral"),
        actions: [
          IconButton(
              onPressed: () {
                dbCon.deleteAllFromListaGeral();
                saveQuantitiesAvaliable();
                showSnackBar();
              },
              icon: Icon(
                Icons.save_sharp,
                color: Colors.white,
              ))
        ],
      ),
      body: ListView.separated(
          padding: EdgeInsets.only(left: 30, right: 30),
          itemBuilder: (context, index) =>
              buildNumberInput(produtos[index], textControlerList[index]),
          separatorBuilder: (context, index) => Divider(
                height: 40,
              ),
          itemCount: produtos.length),
    );
  }

  Widget buildNumberInput(Produto prod, TextEditingController textControler) {
    return Column(children: [
      Text(
        prod.nome,
        textAlign: TextAlign.center,
        style: GoogleFonts.acme(fontSize: 30),
      ),
      NumberInputPrefabbed.roundedButtons(
        controller: textControler,
        incDecBgColor: Colors.greenAccent,
        decIcon: Icons.remove,
        incIcon: Icons.add,
        buttonArrangement: ButtonArrangement.incRightDecLeft,
        isInt: true,
        initialValue: avaliableValuesList[produtos.indexOf(prod)],
        onSubmitted: (num lastNumber) {
          _changeValorInserido(produtos.indexOf(prod), lastNumber);
        },
        onIncrement: (num lastNumber) {
          _changeValorInserido(produtos.indexOf(prod), lastNumber);
        },
        onDecrement: (num lastNumber) {
          _changeValorInserido(produtos.indexOf(prod), lastNumber);
        },
      )
    ]);
  }

  ///Geradores das listas---------------------------------------
  Future<void> _getProdutosGeral() async {
    dbCon.getProdutosCanBeInListaGeral().then((list) async {
      produtos = list;

      _createTextControlerList();
      await _generateListValuesAvaliable();
      setState(() {});
    });
  }

  void _changeValorInserido(int index, num lstNum) {
    avaliableValuesList[index] = int.parse("$lstNum");
  }

  void _createTextControlerList() {
    textControlerList =
        List.generate(produtos.length, (int index) => TextEditingController());
  }

  Future<void> _generateListValuesAvaliable() async {
    var listaGeral = await dbCon.getListaGeral();
    avaliableValuesList = List.generate(produtos.length, (index) => 0);

    if (listaGeral.isNotEmpty) {
      List<int> idsProdutos = [];

      for (ListaGeral lg in listaGeral) {
        idsProdutos.add(lg.idProduto!);
      }

      var produtosInListaGeral = await dbCon.getProdutos(idsProdutos);
      var avaliableValuesFromProdutos =
          await dbCon.getProdutosAndAvaliablesMap(idsProdutos);

      for (Produto prod in produtosInListaGeral) {
        int indexOfProdutoInList =
            produtos.indexWhere((prodInList) => prodInList.id == prod.id);

        if (indexOfProdutoInList != -1) {
          int indexOfAvaliable = avaliableValuesFromProdutos
              .indexWhere((map) => map["idProduto"] == prod.id);

          avaliableValuesList[indexOfProdutoInList] =
              avaliableValuesFromProdutos[indexOfAvaliable]["qtdDisponivel"];
        }
      }
    }
  }

  ///Utilidades  -------------------------------------------------

  Future<void> saveQuantitiesAvaliable() async {
    List<Map<String, dynamic>> ProdQuantity = [];

    for (int i = 0; i < produtos.length; i++) {
      Map<String, dynamic> map = {
        "produto": produtos[i],
        "qtd": avaliableValuesList[i],
      };
      ProdQuantity.add(map);
    }

    for (Map mapeado in ProdQuantity) {
      ListaGeral lg = ListaGeral();
      Produto prod = mapeado["produto"];

      lg.idProduto = prod.id;
      lg.qtdDisponivel = mapeado["qtd"];

      await dbCon.insertProdutoInListaGeral(lg);
    }
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Lista Salva com sucesso!'),
      duration: const Duration(milliseconds: 1500),
      elevation: 600,
      padding: const EdgeInsets.all(
        15.0,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
    ));
  }
}
