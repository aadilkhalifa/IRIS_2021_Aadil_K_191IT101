/// Bar chart with series legend example
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/transaction.dart';

class SimpleDatumLegend extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleDatumLegend(this.seriesList, {this.animate});

  // factory SimpleDatumLegend.withSampleData() {
  //   return new SimpleDatumLegend(
  //     _createSampleData(),
  //     // Disable animations for image tests.
  //     animate: true,
  //   );
  // }

  factory SimpleDatumLegend.withGivenData(categories, transactions, filter) {
    return new SimpleDatumLegend(
      _createUsingData(categories, transactions, filter),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  _SimpleDatumLegendState createState() => _SimpleDatumLegendState();

  /// Create series list with one series
  static List<charts.Series<CategoryData, String>> _createSampleData() {
    final data = [
      new CategoryData('Cat1', 100),
      new CategoryData('Cat2', 75),
      new CategoryData('Cat3', 25),
      new CategoryData('Cat4', 5),
    ];

    return [
      new charts.Series<CategoryData, String>(
        id: 'Sales',
        domainFn: (CategoryData sales, _) => sales.cat,
        measureFn: (CategoryData sales, _) => sales.total,
        data: data,
      )
    ];
  }

  static List<charts.Series<CategoryData, String>> _createUsingData(
      List categories, List<Transaction> transactions, String filter) {
    // filter=''
    // final data = [
    //   new CategoryData('Cat1', 100),
    //   new CategoryData('Cat2', 75),
    //   new CategoryData('Cat3', 25),
    //   new CategoryData('Cat4', 5),
    // ];

    final data = <CategoryData>[];

    var totalData = [];
    for (int i = 0; i < categories.length; i++) {
      totalData.add(0);
    }

    int timeSpan;
    if (filter == 'Day')
      timeSpan = 1;
    else if (filter == 'Week')
      timeSpan = 7;
    else if (filter == 'Month')
      timeSpan = 30;
    else
      timeSpan = 365;

    for (int i = 0; i < transactions.length; i++) {
      if (categories.indexOf(transactions[i].category) != -1) {
        if (transactions[i]
            .dateTime
            .isAfter(DateTime.now().subtract(Duration(days: timeSpan)))) {
          totalData[categories.indexOf(transactions[i].category)] =
              totalData[categories.indexOf(transactions[i].category)] +
                  transactions[i].amount;
        }
      }
    }

    for (int i = 0; i < categories.length; i++) {
      data.add(new CategoryData(categories[i], totalData[i] + .0));
    }

    return [
      new charts.Series<CategoryData, String>(
        id: 'Sales',
        domainFn: (CategoryData sales, _) => sales.cat,
        measureFn: (CategoryData sales, _) => sales.total,
        colorFn: (CategoryData sales, i) =>
            charts.MaterialPalette.getOrderedPalettes(categories.length)[i]
                .shadeDefault,
        data: data,
      )
    ];
  }
}

class _SimpleDatumLegendState extends State<SimpleDatumLegend> {
  @override
  Widget build(BuildContext context) {
    print('build chart');
    return Column(
      children: [
        Container(
          height: 190,
          child: new charts.PieChart(
            widget.seriesList,
            animate: widget.animate,
            // Add the series legend behavior to the chart to turn on series legends.
            // By default the legend will display above the chart.
            behaviors: [
              new charts.DatumLegend(
                desiredMaxColumns: 4,
                // position: charts.BehaviorPosition.bottom,
              )
            ],
          ),
        )
      ],
    );
  }
}

/// Sample linear data type.
class CategoryData {
  final String cat;
  final double total;
  Color color;

  CategoryData(this.cat, this.total);
}
