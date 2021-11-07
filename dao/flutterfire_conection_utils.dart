import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_list/dao/database_conection_utils.dart';
import 'package:market_list/model/produto.dart';

class FlutterFireConectionUtil {
  final DatabaseConectionUtils dbCon = DatabaseConectionUtils();

  Future<String> saveProdutosOnFireStore() async {
    await initApp();
    CollectionReference produtosOnFirebase =
        FirebaseFirestore.instance.collection("Produtos");

    String message = '';
    var produtos = await dbCon.getAllProdutos();
    var documentos = await getDocument();

    if (documentos == null || documentos.isEmpty) {
      message = sendProdutosToFirebase(produtos, produtosOnFirebase);
    } else {
      for (var doc in documentos) {
        doc.reference.delete();
      }
      message = sendProdutosToFirebase(produtos, produtosOnFirebase);
    }
    return message;
  }

  Future<List<DocumentSnapshot<Object?>>?> getDocument() async {
    await initApp();

    var collection = FirebaseFirestore.instance.collection('Produtos');
    var snapshots = await collection.get();

    return snapshots.docs;
  }

  Future<FirebaseApp> initApp() async {
    return Firebase.initializeApp();
  }

  String sendProdutosToFirebase(
      List<Produto> produtos, CollectionReference<Object?> produtosOnFirebase) {
    String message = "";
    for (Produto prod in produtos) {
      try {
        produtosOnFirebase.add(
            {"nome": prod.nome, "qtdRec": prod.qtdRec, "geral": prod.geral});
      } catch (e) {
        message = "Ocorreu um erro: $e";
      }
      message = "Produtos enviados com sucesso!!";
    }
    return message;
  }

  Future<String> getProdutosToDB() async {
    DatabaseConectionUtils dbCon = DatabaseConectionUtils();
    await initApp();
    var documentos = await getDocument();

    String message = "";

    dbCon.deleteAllFromListaGeral();
    dbCon.deleteAllProdutos();

    if (documentos == null || documentos.isEmpty) {
      message = "Nenhum produto para importar!!";
    } else {
      for (var doc in documentos) {
        Produto prod = Produto();
        prod.nome = doc["nome"];
        prod.qtdRec = doc["qtdRec"];
        prod.geral = doc["geral"];

        dbCon.insertProduto(prod);
      }
      message = "Produtos importados com sucesso!";
    }
    return message;
  }
}
