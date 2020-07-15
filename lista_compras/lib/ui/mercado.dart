import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Mercado(),
  ));
}

class Mercado extends StatefulWidget {
  @override
  _MercadoState createState() => _MercadoState();
}

class _MercadoState extends State<Mercado> {

  final mercadoController = TextEditingController();
  List _mrcList = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();
    _readData().then(
            (data) => setState(() {
          print(data);
          _mrcList = json.decode(data);
        })
    );
  }

  void _addItem() {
    if(mercadoController.text != "") {
      setState(() {
        Map<String, dynamic> newItem = Map();
        newItem["title"] = mercadoController.text;
        newItem["ok"] = false;
        newItem["type"] = "mrc";
        mercadoController.text = "";
        _mrcList.add(newItem);
        _saveData();
      });
    };
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _mrcList.sort((a, b) {
        if(a["ok"] && !b["ok"]) return 1;
        else if(!a["ok"] && b["ok"]) return -1;
        else return 0;
      });
      _saveData();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mercado"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                      controller: mercadoController,
                      decoration: InputDecoration(
                          labelText: "Novo ítem",
                          labelStyle: TextStyle(color: Colors.orange)
                      ),
                    )
                ),
                RaisedButton(
                  onPressed: _addItem,
                  color: Colors.orange,
                  child: Text("ADC"),
                  textColor: Colors.white,
                )
              ],
            ),
          ),
          Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0),
                    itemCount: _mrcList.length,
                    itemBuilder: buildItem
                ),
              )
          )
        ],
      ),
    );
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white,),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_mrcList[index]["title"]),
        value: _mrcList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_mrcList[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (checked) {
          setState(() {
            _mrcList[index]["ok"] = checked;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_mrcList[index]);
          _lastRemovedPos = index;
          _mrcList.removeAt(index);
          _saveData();

          final snack = SnackBar(
            content: Text("Item \"${_lastRemoved["title"]}\" removido(a)!"),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _mrcList.insert(_lastRemovedPos, _lastRemoved);
                  _saveData();
                });
              },
            ),
            duration: Duration(seconds: 3),
          );
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/lista_mrc.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_mrcList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}

