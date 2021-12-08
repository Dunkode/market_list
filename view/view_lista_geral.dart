import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_list/dao/database_conection_utils.dart';
import 'package:market_list/model/lista_geral.dart';
import 'package:market_list/model/lista_geral_controller.dart';
import 'package:market_list/model/produto.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class ViewListaGeral extends StatefulWidget {
  const ViewListaGeral({Key? key}) : super(key: key);

  @override
  _ViewProdutoState createState() => _ViewProdutoState();
}

class _ViewProdutoState extends State<ViewListaGeral> {
  DatabaseConectionUtils dbCon = DatabaseConectionUtils();

  // List<Produto> produtos = [];
  // List<TextEditingController> textControlerList = [];
  // List<int> avaliableValuesList = [];

  List<ListaGeralController> ControllerQuantidadesProdutos = [];

  @override
  void initState() {
    super.initState();
    _initializeTextControllers();
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
      body: ControllerQuantidadesProdutos == null ? LinearProgressIndicator() : ListView.separated(
          padding: EdgeInsets.only(left: 30, right: 30),
          itemBuilder: (context, index) =>
              buildNumberInput(ControllerQuantidadesProdutos[index]),
          separatorBuilder: (context, index) => Divider(
                height: 40,
              ),
          itemCount: ControllerQuantidadesProdutos.length),
    );
  }

  Widget buildNumberInput(ListaGeralController ControllerQuantidadeProduto) {
    return Column(children: [
      Text(
        ControllerQuantidadeProduto.produto.nome,
        textAlign: TextAlign.center,
        style: GoogleFonts.acme(fontSize: 30),
      ),
      NumberInputPrefabbed.roundedButtons(
        controller: ControllerQuantidadeProduto.textController,
        incDecBgColor: Colors.greenAccent,
        decIcon: Icons.remove,
        incIcon: Icons.add,
        buttonArrangement: ButtonArrangement.incRightDecLeft,
        isInt: true,
        initialValue: ControllerQuantidadeProduto.quantidadeDisponivel,
        onSubmitted: (num lastNumber) {
          _changeValorInserido(ControllerQuantidadeProduto, lastNumber);
        },
        onIncrement: (num lastNumber) {
          _changeValorInserido(ControllerQuantidadeProduto, lastNumber);
        },
        onDecrement: (num lastNumber) {
          _changeValorInserido(ControllerQuantidadeProduto, lastNumber);
        },
      )
    ]);
  }

  ///Geradores das listas---------------------------------------

  Future<void> _initializeTextControllers() async {
    List<Produto> produtosListaGeral = await dbCon.getProdutosCanBeInListaGeral();

      for (Produto prod in produtosListaGeral){
        ListaGeral? lg = await dbCon.getListaGeralById(prod.id!);

        if (lg != null){
          ControllerQuantidadesProdutos.add(
            ListaGeralController(
                TextEditingController(), prod, lg.qtdDisponivel));
        } else {
          ControllerQuantidadesProdutos.add(
            ListaGeralController(
                TextEditingController(), prod, 0));
        }
      }

    setState(() {});
  }

  void _changeValorInserido(ListaGeralController controller, num lstNum) {
    controller.quantidadeDisponivel = int.parse("$lstNum");
  }

  ///Utilidades  -------------------------------------------------

  Future<void> saveQuantitiesAvaliable() async {

    for (ListaGeralController lgc in ControllerQuantidadesProdutos) {
      ListaGeral lg = ListaGeral();

      lg.idProduto = lgc.produto.id;
      lg.qtdDisponivel = lgc.quantidadeDisponivel;

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
