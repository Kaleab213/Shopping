import 'package:flutter/material.dart';
import 'package:sqflite6/ui/items_screen.dart';
import './util/db_helper.dart';
import '../model/shopping_list.dart';
import '../model/list_items.dart';
import './ui/list_item_dialog.dart';
import './ui/shopping_list_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // databaseFactory = databaseFactoryFfi;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Raleway",
      ),
      home: const Shlist(),
    );
  }
}

class Shlist extends StatefulWidget {
  const Shlist({super.key});

  @override
  _ShlistState createState() => _ShlistState();
}

class _ShlistState extends State<Shlist> {
  List<ShoppingList> shopping_lists = [];
  DBHelper helper = DBHelper();
  late ShoppingListDialog dialog;
  @override
  void initState() {
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping List"),
      ),
      body: ListView.builder(
          itemCount: shopping_lists.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(shopping_lists[index].name),
              onDismissed: (direction) {
                String strName = shopping_lists[index].name;
                helper.deleteList(shopping_lists[index]);

                setState(() {
                  shopping_lists.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("The list $strName is deleted"),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemsScreen(
                          shoppingList: shopping_lists[index],
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    child: Text(shopping_lists[index].priority.toString()),
                  ),
                  title: Text(shopping_lists[index].name),
                  subtitle: Text(shopping_lists[index].id.toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => dialog.buildDialog(
                          context,
                          shopping_lists[index],
                          false,
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => dialog.buildDialog(
                context, ShoppingList(id: 0, name: "", priority: 0), true),
          );
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future showData() async {
    await helper.openDb();
    shopping_lists = await helper.getLists();
    setState(() {
      shopping_lists = shopping_lists;
    });
  }

  Future<int> deleteList(ShoppingList list) async {
    var result = await helper.deleteList(list);
    return result;
  }
}
