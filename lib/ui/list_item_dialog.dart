import 'package:flutter/material.dart';
import '../model/list_items.dart';
import '../util/db_helper.dart';

class ListItemDialog {
  final txtItemName = TextEditingController();
  final txtItemQuantity = TextEditingController();
  final txtItemNote = TextEditingController();

  Widget buildAlert(BuildContext context, ListItem item, bool isNew) {
    DBHelper helper = DBHelper();
    helper.openDb();
    if (!isNew) {
      txtItemName.text = item.name;
      txtItemQuantity.text = item.quantity.toString();
      txtItemNote.text = item.note;
    }

    return AlertDialog(
      title: Text(
        (isNew) ? "New shopping list item" : "Editing shopping list item",
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtItemName,
              decoration: const InputDecoration(hintText: "Item Name"),
            ),
            TextField(
              controller: txtItemQuantity,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Item Quantity"),
            ),
            TextField(
              controller: txtItemNote,
              decoration: const InputDecoration(hintText: "Item Note"),
            ),
            ElevatedButton(
              onPressed: () {
                item.name = txtItemName.text;
                item.quantity = txtItemQuantity.text;
                item.note = txtItemNote.text;
                helper.insertItem(item);
                Navigator.pop(context);
              },
              child: const Text(
                "Save Item",
              ),
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }
}
