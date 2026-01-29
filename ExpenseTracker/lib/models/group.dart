import 'package:flutter/material.dart';

class ExpenseGroup {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final double balance; // positive = owed, negative = owing
  final List<String> memberIds;

  ExpenseGroup({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.balance = 0.0,
    this.memberIds = const [],
  });

  String get balanceText {
    if (balance == 0) return 'Settled';
    final prefix = balance > 0 ? 'Owed' : 'Owe';
    return '$prefix ₹${balance.abs().toStringAsFixed(2)}';
  }
}
