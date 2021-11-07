class ListaRapida {
  int? id = null;
  String? nomeProduto = null;
  int comprado = 0;

  ListaRapida();

  ListaRapida.fromMap(Map map) {
    id = map["id"];
    nomeProduto = map["nomeProduto"];
    comprado = map["comprado"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nomeProduto" : nomeProduto,
      "comprado" : comprado,

    };

    if (id != null){
      map["id"] = id;
    }
    return map;
  }
}