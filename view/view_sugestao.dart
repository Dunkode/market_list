import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_list/dao/database_conection_utils.dart';
import 'package:market_list/model/doughnut.dart';
import 'package:market_list/model/lista_geral.dart';
import 'package:tuple/tuple.dart';

class ViewSugestao extends StatefulWidget {
  const ViewSugestao({Key? key}) : super(key: key);

  @override
  _ViewSugestaoState createState() => _ViewSugestaoState();
}

class _ViewSugestaoState extends State<ViewSugestao> {
  DatabaseConectionUtils dbCon = DatabaseConectionUtils();
  List<ListaGeral> listaGeral = [];

  ///1: nome do produto
  ///2: quantidade recomendada
  ///3: quantidade disponível
  List<Tuple3<String, int, int>> valuesToUse = [];

  @override
  void initState() {
    super.initState();

    _getValuesFromListaGeral();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sugestões de Compra"),
        ),
        body: ListView.separated(
            padding: EdgeInsets.only(right: 26, left: 26),
            itemBuilder: (context, index) => itemBuilder(valuesToUse[index]),
            separatorBuilder: (context, index) => Divider(
                  height: 20,
                ),
            itemCount: valuesToUse.length));
  }

  Widget itemBuilder(Tuple3<String, int, int> values) {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black12),
      ),
      child: Column(
        children: [
          Text(
            values.item1,
            style: GoogleFonts.andikaNewBasic(fontSize: 24),
          ),
          Divider(
            height: 20,
          ),
          Container(
            height: 200,
            child: buildDoughnut(values.item2, values.item3),
          )
        ],
      ),
    );
  }

  double calculateSugestion(int qtdRec, int qtdDisp) {
    double valueSugestion = (qtdDisp * 100) / qtdRec;
    valueSugestion = double.parse(valueSugestion.toStringAsPrecision(2));

    return valueSugestion;
  }

  Widget buildDoughnut(int qtdRec, int qtdDisp) {
    double valueSugestion = calculateSugestion(qtdRec, qtdDisp);
    int qtdToBuy = qtdRec - qtdDisp;

    if (valueSugestion > 100) {
      return DoughnutDefault(qtdDisp, qtdRec, Colors.lightGreenAccent,
          "Tem mais do que o\nnecessário!");
    } else if (valueSugestion >= 50 && valueSugestion <= 100) {

      return DoughnutDefault(
          qtdDisp, qtdRec, Colors.green, "Não precisa comprar\nno momento.");
    } else if (valueSugestion < 50 && valueSugestion >= 20) {

      return DoughnutDefault(
        qtdDisp,
        qtdRec,
        Colors.yellow,
        "Pode comprar\nmas não precisa",
        textInnerHint: Text(
          "Quantidade: $qtdToBuy",
          style: TextStyle(color: Colors.yellow),
        ),
      );
    } else {

      return DoughnutDefault(
        qtdDisp,
        qtdRec,
        Colors.red,
        "É necessário comprar!",
        textInnerHint: Text(
          "Quantidade: $qtdToBuy",
          style: TextStyle(color: Colors.red),
        ),
      );
    }
  }

  void _getValuesFromListaGeral() {
    dbCon.getValuesToSugestao().then((list) => setState(() {
          valuesToUse = list;
        }));
  }
}
