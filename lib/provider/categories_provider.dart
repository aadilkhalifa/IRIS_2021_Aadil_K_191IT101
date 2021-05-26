import 'package:flutter/material.dart';
import '../models/category.dart';
import '../widgets/boxes.dart';

class Categories with ChangeNotifier {
  List<Category> _items = [
    new Category('Groceries'),
    new Category('Food'),
    new Category('Entertainment'),
    new Category('Other'),
  ];

  List<Category> get getCategories {
    return [..._items];
  }

  void add(String item) {
    var c = new Category(item);
    this._items.add(c);
    final box = Boxes.getCategories();
    box.add(c);
    notifyListeners();
  }

  Categories() {
    var extracted = Boxes.getCategories().values.toList();
    List<Category> unique = [];
    for (var i = 0; i < extracted.length; i++) {
      if (!unique.contains(extracted[i])) {
        unique.add(extracted[i]);
      }
    }
    _items.addAll(unique);
  }
}
