// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:wallet_app/provider/categories_provider.dart';
import '../models/category.dart';
import 'chart.dart';
import '../models/transaction.dart';
import 'package:provider/provider.dart';
import '../provider/transactions_provider.dart';

class chart_combined extends StatefulWidget {
  final List<Category> c;
  // final Function calculateTotal;
  // var _value;
  List<String> categories;
  chart_combined(this.c) {
    categories = c.map((e) => e.name).toList();
  }

  @override
  _chart_combinedState createState() => _chart_combinedState();
}

class _chart_combinedState extends State<chart_combined> {
  // double totalSum = 200.00;
  // double totalSum =

  final _filters = ['Day', 'Week', 'Month', 'Year'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('innitstate');
    setState(() {
      // totalSum = widget.calculateTotal(widget._value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionsData = Provider.of<Transactions>(context);
    final trans = transactionsData.getTransactions;
    final totalSum = transactionsData.total;
    return Stack(children: [
      Positioned(
        left: 20,
        bottom: 25,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_filters[transactionsData.filterValue]),
          Text(
            '\$${totalSum.toStringAsFixed(2)}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ]),
      ),
      Positioned(
        right: 10,
        bottom: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Filter:',
              // style: TextStyle(color: Colors.blue),
            ),
            Container(
              // width: 200,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton(
                  // isExpanded: true,
                  style: TextStyle(
                    // color: Colors.blue,
                    color: Theme.of(context).accentColor,
                    // backgroundColor: Colors.blue,
                  ),
                  value: transactionsData.filterValue,
                  items: _filters
                      .map((c) => DropdownMenuItem(
                          child: Text(c), value: _filters.indexOf(c)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      // print(widget.calculateTotal());
                      transactionsData.filterValue = value;
                      transactionsData.calculateTotal();
                      print(value);
                    });
                  }),
            ),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: SimpleDatumLegend.withGivenData(
            widget.categories, trans, _filters[transactionsData.filterValue]),
      ),
    ]);
  }
}
