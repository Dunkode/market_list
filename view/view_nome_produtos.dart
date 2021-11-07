import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_list/dao/database_conection_utils.dart';
import 'package:market_list/model/produto.dart';

class ViewNomeProdutosList extends StatefulWidget {
  const ViewNomeProdutosList({Key? key}) : super(key: key);

  @override
  _ViewNomeProdutosListState createState() => _ViewNomeProdutosListState();
}

class _ViewNomeProdutosListState extends State<ViewNomeProdutosList> {
  DatabaseConectionUtils db = DatabaseConectionUtils();
  List<String> nomesProdutos = [];

  @override
  void initState() {
    super.initState();

    _getNamesFromProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Escolha um produto"),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) =>
              listTileBuilder(nomesProdutos[index]),
          separatorBuilder: (context, index) => Divider(
                height: 20,
              ),
          itemCount: nomesProdutos.length),
    );
  }

  Widget listTileBuilder(String name) {
    return ListTile(
        onTap: () => Navigator.pop(context, name),
        title: Text(name, style: GoogleFonts.arsenal(fontSize: 20)));
  }

  Future<void> _getNamesFromProdutos() async {
    List<String> nomes = [];
    db.getAllProdutos().then((List<Produto> list) {
      setState(() {
        for (Produto prod in list) {
          nomes.add(prod.nome);
        }
        nomesProdutos = nomes;
      });
    });
  }
}
