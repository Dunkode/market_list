class ListaGeral {
  int? id = null;
  int? idProduto = null;
  int qtdDisponivel = 0;

  ListaGeral();

  ListaGeral.fromMap(Map map) {
    id = map["id"];
    idProduto = map["idProduto"];
    qtdDisponivel = map["qtdDisponivel"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idProduto" : idProduto,
      "qtdDisponivel" : qtdDisponivel,

    };

    if (id != null){
      map["id"] = id;
    }
    return map;
  }
}
