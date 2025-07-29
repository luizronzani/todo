import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'models/item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item> items = [];
  final TextEditingController newTaskCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void add() {
    if (newTaskCtrl.text.isEmpty) return;

    setState(() {
      items.add(Item(title: newTaskCtrl.text, done: false));
      newTaskCtrl.clear();
      save();
    });
  }

  void remove(int index) {
    setState(() {
      items.removeAt(index);
      save();
    });
  }

  Future<void> save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'data',
      jsonEncode(items.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> loadData() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');
    if (data != null) {
      List<dynamic> decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        items = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: newTaskCtrl,
          decoration: const InputDecoration(
            labelText: "Nova Tarefa",
            labelStyle: TextStyle(color: Colors.black),
          ),
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Dismissible(
            key: Key(item.title),
            onDismissed: (direction) => remove(index),
            background: Container(color: Theme.of(context).primaryColorLight),
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (bool? value) {
                setState(() {
                  item.done = value ?? false;
                  save();
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
