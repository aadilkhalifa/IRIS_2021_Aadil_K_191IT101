import 'package:hive/hive.dart';
import 'package:wallet_app/models/category.dart';
import '../models/transaction.dart';

class Boxes {
  static Box<Transaction> getTransactions() =>
      Hive.box<Transaction>('transactions');
  static Box<Category> getCategories() => Hive.box<Category>('categories');
}
