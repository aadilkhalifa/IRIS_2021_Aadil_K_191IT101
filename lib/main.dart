import 'package:flutter/material.dart';
import 'package:wallet_app/models/category.dart';
import '../provider/categories_provider.dart';
import 'widgets/display_transactions.dart';
import 'widgets/new_category.dart';
import 'models/transaction.dart';
import 'widgets/new_transaction.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'widgets/chart_combined.dart';
import 'provider/transactions_provider.dart';
import 'package:provider/provider.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactions');
  Hive.registerAdapter(CategoryAdapter());
  await Hive.openBox<Category>('categories');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Transactions(),
      child: ChangeNotifierProvider(
        create: (ctx) => Categories(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.purple[50],
            primarySwatch: Colors.purple,
          ),
          home: MyHomePage(title: 'Wallet'),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // var _categories = ['Groceries', 'Food', 'Entertainment', 'Other'];

  DateTime dt;
  String filter = 'week';
  var _value = 0;

  // var _transactions = <Transaction>[];

  var dropdownValue = 'One';
  final amountController = TextEditingController();

  void _addTransaction(
      double amt, DateTime dt, String cat, Transactions trans) {
    setState(() {
      // _transactions.add(new Transaction(amt, dt, cat));
      // Transactions.insert(0, new Transaction(amt, dt, cat));
      // Transactions.sort((a, b) => a.dateTime.isAfter(b.dateTime) ? 0 : 1);
      dt = null;
      amountController.clear();
      trans.calculateTotal();
    });
  }

  void _addCategory(String cat, Categories catData) {
    setState(() {
      // _transactions.add(new Transaction(amt, dt, cat));
      catData.add(cat);
      // print(_categories);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        final categoriesData = Provider.of<Categories>(context);
        final categories = categoriesData.getCategories;
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addTransaction, categories),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _startAddNewCategory(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewCategory(_addCategory),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  // double calculateTotal(int value) {
  //   print('cal total for: ' + value.toString());
  //   var duration = 0;
  //   if (value == 0)
  //     duration = 1;
  //   else if (value == 1)
  //     duration = 7;
  //   else if (value == 2)
  //     duration = 30;
  //   else if (value == 3) duration = 365;
  //   var filteredTransactions = _transactions.where((element) => element.dateTime
  //       .isAfter(DateTime.now().subtract(Duration(days: duration))));
  //   return filteredTransactions
  //       .where((element) => true)
  //       .toList()
  //       .fold(0, (previousValue, element) => previousValue += element.amount);
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesData = Provider.of<Categories>(context);
    final categories = categoriesData.getCategories;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).primary[900],
        title: Text(widget.title),
        actions: [
          Center(
            child: FlatButton(
              child: Text(
                "Add Category",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => _startAddNewCategory(context),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
              height: 250,
              width: double.infinity,
              child: Card(
                child: chart_combined(categories),
              )),
          Expanded(child: DisplayTransactions(categories)),
          Container(
            // height: 300,
            height: 0,
            child: SingleChildScrollView(child: null),
          )
        ],
      ),
      floatingActionButton: Row(mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => _startAddNewTransaction(context),
              tooltip: 'Increment',
              child: Icon(
                Icons.add,
                // color: Theme.of(context).primaryColor,
              ),
            ),
          ]),
    );
  }
}
