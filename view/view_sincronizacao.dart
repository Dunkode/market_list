import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_list/dao/flutterfire_conection_utils.dart';

class ViewSincronizacao extends StatefulWidget {
  _ViewSincronizacaoState createState() => _ViewSincronizacaoState();
}

class _ViewSincronizacaoState extends State<ViewSincronizacao> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sincronizar"),
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            Image.asset("img/sincronizar.png",height: 200,
            width: 200,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () => getProdutos(),
                    child: Text(
                      "Receber Produtos",
                      style: GoogleFonts.fjallaOne(fontSize: 20),
                    )),
                ElevatedButton(
                    onPressed: () => sendProdutos(),
                    child: Text(
                      "Enviar Produtos",
                      style: GoogleFonts.fjallaOne(fontSize: 20),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  void sendProdutos() {
    FlutterFireConectionUtil ffcon = FlutterFireConectionUtil();

    ffcon.saveProdutosOnFireStore().then((response) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Resposta"),
              content: Text(response),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text("OK"))
              ],
            );
          });
    });
  }

  void getProdutos() {
    FlutterFireConectionUtil ffcon = FlutterFireConectionUtil();

    ffcon.getProdutosToDB().then((response) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Resposta"),
              content: Text(response),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text("OK"))
              ],
            );
          });
    });
  }
}
