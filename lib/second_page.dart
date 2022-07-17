import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class SecondPage extends StatefulWidget {

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {


  final _todoControler = TextEditingController();

  List _toDoList = [];

  Map<String, dynamic> _lastRemoved = Map();

  int _lastRemovedPos = 0;

  @override
  void initState() {
    super.initState();
    _realData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _naMao() {
    List lista = [
      "3 glifage XR 500 mi",
    ];
    for (var item in lista) {
      setState(() {
        Map<String, dynamic> newToDo = Map();
        newToDo["title"] = item;
        newToDo["ok"] = false;
        _toDoList.add(newToDo);
        _saveData();
      });
    }
  }

  void _addTodo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _todoControler.text;
      _todoControler.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _toDoList.sort((a, b) {
        if (a["ok"] && !b["ok"])
          return 1;
        else if (!a["ok"] && b["ok"])
          return -1;
        else
          return 0;
      });
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
            child: Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: _naMao,
                  child: Text(
                    "+",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: TextField(
                    // use the text align property
                    textAlign: TextAlign.center,
                    controller: _todoControler,
                    decoration: InputDecoration(
                      hintText: "Nova Tarefa",
                      hintStyle: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: Text("ADD", style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  itemCount: _toDoList.length,
                  itemBuilder: buildItem),
              onRefresh: _refresh,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime
          .now()
          .microsecondsSinceEpoch
          .toString()),
      background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment(-0.9, 0.0),
            child: Icon(Icons.delete, color: Colors.white,),
          )
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error),
        ), onChanged: (value) {
        setState(() {
          _toDoList[index]["ok"] = value;
          _saveData();
        });
      },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedPos = index;
          _toDoList.removeAt(index);

          _saveData();

          final snack = SnackBar(
            content: Text("Tarefa ${_lastRemoved["title"]} removida!"),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _toDoList.insert(_lastRemovedPos, _lastRemoved);
                  _saveData();
                });
              },
            ),
            duration: Duration(seconds: 2),
          );
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data2.json");
  }

  Future<File> _saveData() async {
    String data2 = json.encode(_toDoList);

    final file = await _getFile();
    return file.writeAsString(data2);
  }

  Future<String> _realData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return "errouuuu...";
    }
  }
}