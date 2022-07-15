import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class FirstPage extends StatefulWidget {

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  final _todoControler1 = TextEditingController();

  List _toDoList1 = [];

  Map<String, dynamic> _lastRemoved1 = Map();
  int _lastRemovedPos1 = 0;


  @override
  void initState() {
    super.initState();
    _realData1().then((data) {
      setState((){
        _toDoList1 = json.decode(data);
      });
    });
  }

  void _addTodo1() {
    setState((){
      Map<String, dynamic> newToDo = Map();
      newToDo["title1"] = _todoControler1.text;
      _todoControler1.text = "";
      newToDo["ok1"] = false;
      _toDoList1.add(newToDo);
      _saveData1();
    });
  }

  Future<Null> _refresh1() async{
    await Future.delayed(Duration(seconds: 1));

    setState((){
      _toDoList1.sort((a,b){
        if(a["ok1"] && !b["ok1"]) return 1;
        else if(!a["ok1"] && b["ok1"])return -1;
        else return 0;
      });
      _saveData1();
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
                Expanded(
                  child: TextField(
                    controller: _todoControler1,
                    decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addTodo1,
                  child: Text("ADD", style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  itemCount: _toDoList1.length,
                  itemBuilder: buildItem1),
              onRefresh: _refresh1,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem1(context, index){
    return Dismissible(
      key: Key(DateTime.now().microsecondsSinceEpoch.toString()),
      background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment(-0.9, 0.0),
            child: Icon(Icons.delete, color: Colors.white,),
          )
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList1[index]["title1"]),
        value: _toDoList1[index]["ok1"],
        secondary: CircleAvatar(
          child: Icon(_toDoList1[index]["ok1"] ? Icons.check : Icons.error),
        ), onChanged: (value) {
        setState(() {
          _toDoList1[index]["ok1"] = value;
          _saveData1();
        });
      },
      ),
      onDismissed: (direction){
        setState((){
          _lastRemoved1 = Map.from(_toDoList1[index]);
          _lastRemovedPos1 = index;
          _toDoList1.removeAt(index);

          _saveData1();

          final snack = SnackBar(
            content: Text("Tarefa ${_lastRemoved1["title1"]} removida!"),
            action: SnackBarAction(
              label: "Desfazer",
              onPressed: (){
                setState((){
                  _toDoList1.insert(_lastRemovedPos1, _lastRemoved1);
                  _saveData1();
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

  Future<File> _getFile1() async {
    final directory1 = await getApplicationDocumentsDirectory();
    return File("${directory1.path}/data1.json");
  }

  Future<File> _saveData1() async {
    String data1 = json.encode(_toDoList1);

    final file1 = await _getFile1();
    return file1.writeAsString(data1);
  }

  Future<String> _realData1() async {
    try {
      final file1 = await _getFile1();
      return file1.readAsString();
    }catch (e) {
      return "errouuuu...";
    }
  }
}