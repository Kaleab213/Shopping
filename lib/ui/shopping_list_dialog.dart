import "package:flutter/material.dart";
import '../util/db_helper.dart';
import '../model/shopping_list.dart';

class ShoppingListDialog {
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buildDialog(BuildContext context, ShoppingList list, bool isNew) {
    DBHelper helper = DBHelper();
    if (!isNew) {
      txtName.text = list.name;
      txtPriority.text = list.priority.toString();
    }

    return AlertDialog(
      title: Text(
        (isNew) ? "New shopping list" : "Editing shopping list",
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: const InputDecoration(hintText: "Shopping List Name"),
            ),
            TextField(
              controller: txtPriority,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: "Shopping List Priority (1-3)"),
            ),
            ElevatedButton(
              onPressed: () {
                list.name = txtName.text;
                list.priority = int.parse(txtPriority.text);
                helper.insertList(list);
                Navigator.pop(context);
              },
              child: const Text(
                "Shopping list",
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
