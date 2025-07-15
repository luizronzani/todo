import 'package:flutter/material.dart';
import 'models/item.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final List<Item> items;

  HomePage({super.key})
    : items = [
        Item(title: "Buy groceries", isDone: false),
        Item(title: "Walk the dog", isDone: true),
      ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();

  void add() {
    if (newTaskCtrl.text.isEmpty) return;
    setState(() {
      widget.items.add(Item(title: newTaskCtrl.text, isDone: false));

      newTaskCtrl.text = "";
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskCtrl, // VINCULA o campo ao controller
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.black, fontSize: 24),
          decoration: InputDecoration(
            labelText: "Nova Tarefa",
            labelStyle: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = widget.items[index];
          return Dismissible(
            background: Container(color: Colors.red.withValues(alpha: 0.85)),
            onDismissed: (direction) {
              setState(() {
                remove(index);
              });
            },
            key: Key(item.title),
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.isDone,
              onChanged: (value) {
                setState(() {
                  //atualiza o estado do item
                  item.isDone = value!;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }
}
