class Produto {
  int? id = null;
  String nome = '';
  int qtdRec = 0;
  int geral = 0;

  Produto();

  Produto.fromMap(Map map){
    id = map["idProduto"];
    nome = map["nomeProduto"];
    qtdRec = map["qtdRec"];
    geral = map["geral"];
  }

  Map<String, dynamic> toMap() {
    Map <String, dynamic> map = {
      "nomeProduto": nome,
      "qtdRec": qtdRec,
      "geral": geral,
    };
    if (id != null) {
      map["idProduto"] = id;
    }
      return map;
  }
}
