import 'dart:async';

import 'package:market_list/model/lista_rapida.dart';
import 'package:tuple/tuple.dart';
import 'package:market_list/model/lista_geral.dart';
import 'package:market_list/model/produto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConectionUtils {
  static final DatabaseConectionUtils _instance =
      DatabaseConectionUtils.internal();

  factory DatabaseConectionUtils() => _instance;

  DatabaseConectionUtils.internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDb();
      return _db!;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "databaseschema.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("""CREATE TABLE produto (
                        idProduto INTEGER PRIMARY KEY,
                        nomeProduto TEXT,
                        qtdRec INTEGER,
                        geral INTEGER
                      );""");
      await db.execute("""CREATE TABLE listaGeral (
                        id INTEGER PRIMARY KEY,
                        idProduto INTEGER,
                        qtdDisponivel INTEGER,
                        FOREIGN KEY (idProduto) REFERENCES produto(idProduto)
                      );""");
      await db.execute("""CREATE TABLE listaRapida(
                        id INTEGER PRIMARY KEY,
                        nomeProduto TEXT,
                        comprado INTEGER
                      );""");
    });
  }

  Future<Produto> insertProduto(Produto prod) async {
    Database dbSchema = await db;
    prod.id = await dbSchema.insert("produto", prod.toMap());
    return prod;
  }


  Future<Produto> getProduto(int id) async{
    Database dbSchema = await db;
    List result = await dbSchema.query("produto", where: "idProduto = ?", whereArgs: [id]);
    return new Produto.fromMap(result[0]);
  }

  Future<List<Produto>> getProdutosById(List<int> idsProdutos) async {
    Database dbSchema = await db;
    String idsToString = ajustIdListToString(idsProdutos);

    List listMapReturned = await dbSchema
        .rawQuery("SELECT * FROM produto WHERE idProduto in ($idsToString)");
    List<Produto> listProdutos = [];

    for (Map m in listMapReturned) {
      listProdutos.add(Produto.fromMap(m));
    }

    return listProdutos;
  }

  Future<List<Produto>> getAllProdutos() async {
    Database dbSchema = await db;
    List listMapReturned = await dbSchema.rawQuery("SELECT * FROM produto");
    List<Produto> listProdutos = [];

    for (Map m in listMapReturned) {
      listProdutos.add(Produto.fromMap(m));
    }
    return listProdutos;
  }

  Future<List<Produto>> getProdutosCanBeInListaGeral() async {
    Database dbSchema = await db;
    List listMapReturned =
        await dbSchema.rawQuery("SELECT * FROM produto WHERE geral = 1");
    List<Produto> listProdutos = [];

    for (Map m in listMapReturned) {
      listProdutos.add(Produto.fromMap(m));
    }

    return listProdutos;
  }

  Future<int> deleteProduto(int id) async {
    Database dbSchema = await db;
    return await dbSchema
        .delete("produto", where: "idProduto = ?", whereArgs: [id]);
  }

  Future<void> deleteAllProdutos() async {
    Database dbSchema = await db;
    await dbSchema.delete("produto");
  }

  Future<int> updateProduto(Produto prod) async {
    Database dbSchema = await db;
    return await dbSchema.update("produto", prod.toMap(),
        where: "idProduto = ?", whereArgs: [prod.id]);
  }

  /// UTILITARIOS DA LISTA GERAL ------------------------------

  Future<ListaGeral> insertProdutoInListaGeral(ListaGeral lg) async {
    Database dbSchema = await db;
    lg.id = await dbSchema.insert('listaGeral', lg.toMap());
    return lg;
  }

  Future<void> deleteProdutosFromListaGeral(List<int> ids) async {
    Database dbSchema = await db;
    String idString = ajustIdListToString(ids);
    await dbSchema.delete("listaGeral", where: "id in ($idString)");
  }

  Future<void> deleteAllFromListaGeral() async {
    Database dbSchema = await db;
    await dbSchema.delete("listaGeral");
  }

  Future<List<Tuple3<String, int, int>>> getValuesToSugestao() async {
    Database dbSchema = await db;
    List returnDB = await dbSchema.rawQuery(
        "select po.nomeProduto, po.qtdRec, lg.qtdDisponivel from listaGeral lg "
        "JOIN produto po ON lg.idProduto = po.idProduto");
    List<Tuple3<String, int, int>> listWithTuples = [];

    for (Map m in returnDB) {
      var tupla = Tuple3<String, int, int>(
          m["nomeProduto"], m["qtdRec"], m["qtdDisponivel"]);
      listWithTuples.add(tupla);
    }
    return listWithTuples;
  }

  Future <ListaGeral?> getListaGeralById(int id) async {
    Database dbSchema = await db;
    List retorno = await dbSchema.query("listaGeral", where: "idProduto = ?", whereArgs: [id]);

    if (retorno.isNotEmpty){
      return ListaGeral.fromMap(retorno[0]);
    } else {
      return null;
    }
  }

  Future<List<ListaGeral>> getListaGeral() async {
    Database dbSchema = await db;
    List returnDB = await dbSchema.rawQuery("SELECT * FROM listaGeral");
    List<ListaGeral> lgRows = [];

    for (Map m in returnDB) {
      lgRows.add(ListaGeral.fromMap(m));
    }
    return lgRows;
  }

  Future<List<Map<String, dynamic>>> getProdutosAndAvaliablesMap(
      List<int> idsProdutos) async {
    Database dbSchema = await db;
    String idsToString = ajustIdListToString(idsProdutos);

    List<Map<String, dynamic>> prodAndAvaliable = await dbSchema.rawQuery(
        "SELECT idProduto, qtdDisponivel FROM listaGeraL WHERE idProduto in ($idsToString);");

    return prodAndAvaliable;
  }

  /// UTILITARIOS DA LISTA RAPIDA ------------------------------

  Future<List<ListaRapida>> selectAllFromListaRapida() async {
    List<ListaRapida> lrRows = [];

    Database dbSchema = await db;
    List<Map<String, dynamic>> returnDB = await dbSchema.query("listaRapida");

    for (Map m in returnDB) {
      lrRows.add(ListaRapida.fromMap(m));
    }

    return lrRows;
  }

  Future<void> deleteAllFromListaRapida() async {
    Database dbSchema = await db;
    dbSchema.delete("listaRapida");
  }

  Future<void> deleteCompradosFromListaRapida() async {
    Database dbSchema = await db;
    dbSchema.delete("listaRapida", where: "comprado = 1");

  }

  Future<int> updateCompradoFromLista (ListaRapida lr) async {
    Database dbSchema = await db;
    dbSchema.update("listaRapida", lr.toMap(), where: "id = ?", whereArgs: [lr.id]);
    return lr.id!;
  }

  Future<ListaRapida> insertNewProdutoToListaRapida (ListaRapida lr) async{
    Database dbSchema = await db;

    lr.id = await dbSchema.insert("listaRapida", lr.toMap());
    return lr;
  }


  /// UTILITARIOS GERAIS ------------------------------
  String ajustIdListToString(List<int> idsProdutos) {
    String idsToString = "";

    for (int id in idsProdutos) {
      idsToString += "$id, ";
    }

    if (idsToString.length >= 2) {
      idsToString = idsToString.substring(0, idsToString.length - 2);
    }
    return idsToString;
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }

}
