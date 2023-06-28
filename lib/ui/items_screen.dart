import 'package:flutter/material.dart';
import '../model/list_items.dart';
import '../model/shopping_list.dart';
import '../util/db_helper.dart';
import 'list_item_dialog.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;
  const ItemsScreen({Key? key, required this.shoppingList}) : super(key: key);

  @override
  _ItemsScreenState createState() => _ItemsScreenState(shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  DBHelper helper = DBHelper();
  List<ListItem> items = [];
  final ShoppingList shoppingList;
  late ListItemDialog dialog;

  _ItemsScreenState(this.shoppingList);
  @override
  Widget build(BuildContext context) {
    dialog = ListItemDialog();
    showData();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shoppingList.name),
      ),
      body: FutureBuilder(
        future: helper.getItems(widget.shoppingList.id),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            items = snapshot.data;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(items[index].name),
                  onDismissed: (direction) {
                    String strName = items[index].name;
                    helper.deleteItem(items[index]);
                    setState(() {
                      items.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("$strName deleted"),
                      // duration: const Duration(seconds: 2),
                      // action: SnackBarAction(
                      //   label: "UNDO",
                      //   onPressed: () {
                      //     helper.insertItem(items[index]);
                      //     setState(() {
                      //       items.insert(index, items[index]);
                      //     });
                      //   },
                      // ),
                    ));
                  },
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(items[index].quantity),
                      ),
                      title: Text(items[index].name),
                      subtitle: Text(
                          "Quantity: ${items[index].quantity} - Note:${items[index].note}"),
                      onTap: () {
                        Navigator.pushNamed(context, '/item',
                            arguments: items[index]);
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => dialog
                                  .buildAlert(context, items[index], false));
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => dialog.buildAlert(
                  context,
                  ListItem(
                      id: 0,
                      listId: shoppingList.id,
                      name: '',
                      quantity: "",
                      note: ""),
                  true));
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> showData() async {
    await helper.openDb();
    items = await helper.getItems(shoppingList.id);
    setState(() {
      items = items;
    });
  }
}
