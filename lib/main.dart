import 'package:flutter/material.dart';
import './first_page.dart';
import './second_page.dart';
import './third_page.dart';

void main() {
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "TabBar Tutorial",
        home:MainPage()),
      );
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("COMPRAS"),
          centerTitle: true,
          bottom: TabBar(
              tabs: [
                Tab(text: "MERCADO"),
                Tab(text: "FARMACIA"),
                Tab(text: "EXTRA"),
              ]
          ),
        ),
        body: TabBarView(
          children: [
            FirstPage(),
            SecondPage(),
            ThirdPage(),
          ],
        ),
      ),
    );
  }
}
