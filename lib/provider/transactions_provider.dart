import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/boxes.dart';

class Transactions with ChangeNotifier {
  List<Transaction> _trans = [
    //   new Transaction(10.00, DateTime.now(), 'Groceries'),
    //   new Transaction(20.00, DateTime.now(), 'Food'),
    //   new Transaction(
    //       30.00, DateTime.now().subtract(Duration(days: 5)), 'Entertainment'),
    //   new Transaction(
    //       30.00, DateTime.now().subtract(Duration(days: 10)), 'Groceries'),
    //   new Transaction(30.00, DateTime.now().subtract(Duration(days: 15)), 'Food'),
    //   new Transaction(
    //       30.00, DateTime.now().subtract(Duration(days: 25)), 'Other'),
    //   new Transaction(
    //       30.00, DateTime.now().subtract(Duration(days: 35)), 'Groceries'),
    //   new Transaction(
    //       30.00, DateTime.now().subtract(Duration(days: 45)), 'Entertainment'),
  ];
  double total = 0;
  int filterValue = 0;

  List<Transaction> get getTransactions {
    return [..._trans];
  }

  void insert(double amt, DateTime dt, String cat) {
    var transaction = new Transaction(amt, dt, cat);
    _trans.insert(0, transaction);
    _trans.sort((a, b) => a.dateTime.isAfter(b.dateTime) == true ? 0 : 1);
    final box = Boxes.getTransactions();
    box.add(transaction);
  }

  void removeAt(int index) {
    _trans.removeAt(index);
    // box.re;
    calculateTotal();
    notifyListeners();
  }

  double calculateTotal() {
    var value = filterValue;
    print('cal total for: ' + value.toString());
    var duration = 0;
    if (value == 0)
      duration = 1;
    else if (value == 1)
      duration = 7;
    else if (value == 2)
      duration = 30;
    else if (value == 3) duration = 365;
    var filteredTransactions = _trans.where((element) => element.dateTime
        .isAfter(DateTime.now().subtract(Duration(days: duration))));
    this.total = filteredTransactions
        .where((element) => true)
        .toList()
        .fold(0, (previousValue, element) => previousValue += element.amount);
    notifyListeners();
    return this.total;
  }

  Transactions() {
    var t = Boxes.getTransactions().values.toList();
    t.sort((a, b) => a.dateTime.isAfter(b.dateTime) == true ? 1 : 0);
    _trans.addAll(t);
    print("Extracted values : " +
        Boxes.getTransactions().values.toList().toString());
    this.total = this.calculateTotal();
  }
}
