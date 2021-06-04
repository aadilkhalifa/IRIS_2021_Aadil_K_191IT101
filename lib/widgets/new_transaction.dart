import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../provider/transactions_provider.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  final List<Category> categories;

  NewTransaction(this.addTx, this.categories);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final remarksController = TextEditingController();

  final amountController = TextEditingController();
  var _value = 0;
  DateTime dt;

  void submitData(Transactions transData) {
    final enteredRemark = remarksController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredAmount <= 0 || dt == null) {
      return;
    }

    // widget.addTx(enteredTitle, enteredAmount, 'Other');
    widget.addTx(enteredAmount, DateTime.now(), 'Other', transData);
    transData.insert(enteredAmount, dt, widget.categories[_value].name);
    transData.calculateTotal();

    Navigator.of(context).pop();
  }

  void _displayDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2010),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) return;
      print(pickedDate);
      setState(() {
        dt = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionsData = Provider.of<Transactions>(context);
    final trans = transactionsData.getTransactions;
    final node = FocusScope.of(context);
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onEditingComplete: () => node.nextFocus(),
              // onSubmitted: (_) => submitData(),
              // onChanged: (val) => amountInput = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Category: '),
                DropdownButton(
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      // backgroundColor: Colors.blue,
                    ),
                    value: _value,
                    items: widget.categories
                        .map((c) => DropdownMenuItem(
                            child: Text(c.name),
                            value: widget.categories.indexOf(c)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    })
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: _displayDatePicker,
                  child: Text('pick date'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).accentColor),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(dt != null
                      ? Jiffy(dt.toString()).yMMMMd
                      : 'no date choosen'),
                ),
              ],
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Remarks'),
              controller: remarksController,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => node.unfocus(),
              // onSubmitted: (_) => submitData(),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                child: Text('Add Transaction'),
                // textColor: Colors.purple,
                onPressed: () => submitData(transactionsData),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).accentColor),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
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
