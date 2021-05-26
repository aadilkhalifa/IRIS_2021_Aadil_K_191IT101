import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import '../provider/transactions_provider.dart';

class DisplayTransactions extends StatefulWidget {
  List<Category> categories;

  DisplayTransactions(this.categories);

  @override
  _DisplayTransactionsState createState() => _DisplayTransactionsState();
}

class _DisplayTransactionsState extends State<DisplayTransactions> {
  @override
  Widget build(BuildContext context) {
    final transactionsData = Provider.of<Transactions>(context);
    final trans = transactionsData.getTransactions;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: trans.length,
      itemBuilder: (context, index) {
        final item = trans[index];
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            // Remove the item from the data source.
            setState(() {
              transactionsData.removeAt(index);
            });
            trans[index].delete();

            // Then show a snackbar.
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('$item dismissed')));
          },
          child: Card(
            child: ListTile(
              leading: Container(
                height: 40,
                width: 40,
                child: Image.asset(
                    // 'assets/${widget.categories.indexOf(Category(trans[index].category)) < 4 ? widget.categories.indexOf(Category(trans[index].category)) : 3}.png'),
                    'assets/${trans[index].category == 'Shopping' ? 0 : trans[index].category == 'Food' ? 1 : trans[index].category == 'Entertainment' ? 2 : 0}.png'),
              ),
              title: Text(
                trans[index].category,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$" + trans[index].amount.toStringAsFixed(2),
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(Jiffy(trans[index].dateTime.toString()).yMMMMd),
                  ]),
            ),
          ),
        );
      },
    );
  }
}
