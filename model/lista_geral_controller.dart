import 'package:flutter/cupertino.dart';
import 'package:market_list/model/produto.dart';

class ListaGeralController {

  TextEditingController textController;
  Produto produto;
  int quantidadeDisponivel;


  ListaGeralController(this.textController,this.produto, this.quantidadeDisponivel);

}