import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/categories_provider.dart';

class NewCategory extends StatefulWidget {
  final Function addTx;
  NewCategory(this.addTx);

  @override
  _NewCategoryState createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  final textController = TextEditingController();

  void submitData(Categories catData) {
    final enteredText = textController.text;

    if (enteredText == null) {
      return;
    }
    widget.addTx(enteredText, catData);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesData = Provider.of<Categories>(context);
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'New Category'),
              controller: textController,
              keyboardType: TextInputType.text,
              onSubmitted: (_) => submitData(categoriesData),
              // onChanged: (val) => amountInput = val,
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                child: Text('Add Category'),
                // textColor: Colors.blue,
                onPressed: () => submitData(categoriesData),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
