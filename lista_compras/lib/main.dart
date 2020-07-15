import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lista_compras/ui/hortifruti.dart';
import 'package:lista_compras/ui/mercado.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    initialRoute: "/",
    routes: {
      "/Hortifruti": (context) => Hortifruti(),
      "/Mercado": (context) => Mercado()
    },
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de compras"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(right: 5.0),
                  child: Container(
                    height: 150,
                    color: Colors.red,
                    child: RaisedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, "/Hortifruti");
                      },
                      color: Colors.green,
                      icon: Icon(Icons.shopping_basket),
                      label: Text("Sacolão", style: TextStyle(fontSize: 15.0, color: Colors.white),),
                      textColor: Colors.white,
                    ),

                  ),
                )
            ),
            Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Container(
                    height: 150,
                    color: Colors.orange,
                    child: RaisedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, "/Mercado");
                      },
                      color: Colors.orange,
                      icon: Icon(Icons.shopping_cart),
                      label: Text("Mercado", style: TextStyle(fontSize: 15.0, color: Colors.white),),
                      textColor: Colors.white,
                    ),
                  ),
                )
            )
          ],
        ),
      )


    );
  }
}

