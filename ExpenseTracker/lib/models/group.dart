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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCode': icon.codePoint,
      'colorValue': color.value,
      'balance': balance,
      'memberIds': memberIds,
    };
  }

  factory ExpenseGroup.fromJson(Map<String, dynamic> json) {
    return ExpenseGroup(
      id: json['id'],
      name: json['name'],
      icon: IconData(json['iconCode'] ?? Icons.group.codePoint, fontFamily: 'MaterialIcons'),
      color: Color(json['colorValue'] ?? Colors.blue.value),
      balance: json['balance'] ?? 0.0,
      memberIds: List<String>.from(json['memberIds'] ?? []),
    );
  }

  String get balanceText {
    if (balance == 0) return 'Settled';
    final prefix = balance > 0 ? 'Owed' : 'Owe';
    return '$prefix ₹${balance.abs().toStringAsFixed(2)}';
  }
}
