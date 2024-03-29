import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(Size(372, 42)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: Colors.greenAccent))),
        textStyle: MaterialStateProperty.all<TextStyle>(
            GoogleFonts.arsenal(fontSize: 20)));

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Market App",
              style: GoogleFonts.acme(fontSize: 40, color: Colors.greenAccent),
            ),
            actionButtonMenu("Lista Geral", "/ListaGeral", style),
            actionButtonMenu("Lista Rápida", "/ListaRapida", style),
            actionButtonMenu("Produtos", "/ListaProdutos", style),
            actionButtonMenu("Sugestão de Compra", "/Sugestao", style),
            actionButtonMenu("Sincronizar", "/Sincronizacao", style),
          ],
        ),
      ),
    );
  }

  Widget actionButtonMenu(String labbel, String path, ButtonStyle style) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        child: Text(labbel),
        onPressed: () => Navigator.pushNamed(context, path),
        style: style,
      ),
    );
  }
}
