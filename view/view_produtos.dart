import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_list/dao/database_conection_utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:market_list/model/produto.dart';

import 'create_produtos_form.dart';

class ViewProdutos extends StatefulWidget {
  const ViewProdutos({Key? key}) : super(key: key);

  @override
  _ViewProdutosState createState() => _ViewProdutosState();
}

class _ViewProdutosState extends State<ViewProdutos> {
  DatabaseConectionUtils dbCon = DatabaseConectionUtils();
  List<Produto> produtos = [];

  @override
  void initState() {
    super.initState();
    _getAllProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos Cadastrados"),
        actions: <Widget>[
          IconButton(onPressed: toProdutoForm, icon: Icon(Icons.add))
        ],
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => buildSlidable(produtos[index]),
          separatorBuilder: (context, index) => Divider(
                height: 2,
              ),
          itemCount: produtos.length),
    );
  }

  Widget buildSlidable(Produto prod) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      actions: [
        IconSlideAction(
            caption: "Remover\nProduto",
            color: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.remove_circle_outline,
            onTap: () {
              removeProduto(prod);
            })
      ],
      secondaryActions: [
        IconSlideAction(
            caption: "Editar\nProduto",
            color: Colors.greenAccent,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            onTap: () {
              toProdutoForm(prod: prod);
            })
      ],
      child: buildCardForSlidable(prod),
    );
  }

  Widget buildCardForSlidable(Produto prod) {
    return Card(
      child: Container(
        width: 500,
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              prod.nome,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Text(
              "Quantidade Recomendada: " + prod.qtdRec.toString(),
              style: TextStyle(fontSize: 15, color: Colors.blue),
            ),
            Text(
              "Aparece na Lista Geral? " + (prod.geral == 1 ? "Sim" : "Não"),
              style: (prod.geral == 1
                  ? TextStyle(fontSize: 15, color: Colors.green)
                  : TextStyle(fontSize: 15, color: Colors.red)),
            )
          ],
        ),
      ),
    );
  }

  void toProdutoForm({Produto? prod}) async {
    DatabaseConectionUtils dbCon = DatabaseConectionUtils();

    final produtoCadastrado = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateProdutosForm(produto: prod)));

    if (produtoCadastrado != null) {
      if (prod != null) {
        await dbCon.updateProduto(produtoCadastrado);
      } else {
        await dbCon.insertProduto(produtoCadastrado);
      }
    }
    setState(() {
      _getAllProdutos();
    });
  }

  void _getAllProdutos() {
    dbCon.getAllProdutos().then((list) => setState(() {
          produtos = list;
        }));
  }

  void removeProduto(Produto prod) {
    DatabaseConectionUtils dbCon = DatabaseConectionUtils();
    dbCon.deleteProdutosFromListaGeral([prod.id!]);
    dbCon.deleteProduto(prod.id!);

    final snack = SnackBar(
      content: Text("Produto ${prod.nome} removido com sucesso!"),
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snack);

    _getAllProdutos();
  }
}
