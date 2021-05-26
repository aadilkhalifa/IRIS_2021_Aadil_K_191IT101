import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  double amount;
  @HiveField(1)
  DateTime dateTime;
  @HiveField(2)
  String category;
  Transaction(this.amount, this.dateTime, this.category);
}
