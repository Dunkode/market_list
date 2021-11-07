import 'package:flutter/material.dart';
import 'package:market_list/view/view_lista_geral.dart';
import 'package:market_list/view/view_lista_rapida.dart';
import 'package:market_list/view/view_produtos.dart';
import 'package:market_list/view/view_sincronizacao.dart';
import 'package:market_list/view/view_sugestao.dart';
import 'view/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
      ),
      initialRoute: "/",
      routes: {
        "/" : (context) => MainMenu(title: "market_list",),
        "/ListaGeral" : (context) => ViewListaGeral(),
        "/ListaProdutos" : (context) => ViewProdutos(),
        "/Sugestao" : (context) => ViewSugestao(),
        "/ListaRapida" : (context) => ViewListaRapida(),
        "/Sincronizacao" : (context) => ViewSincronizacao(),

      },
    );
  }
}

