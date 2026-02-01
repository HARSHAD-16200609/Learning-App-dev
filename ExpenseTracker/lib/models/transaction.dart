enum TransactionType { owed, owing, settled }

enum TransactionCategory { food, transport, shopping, entertainment, utilities, other }

class Transaction {
  final String id;
  final String title;
  final String friendId;
  final String friendName;
  final String friendAvatar;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime date;
  final String? description;
  final String? receiptImagePath;

  Transaction({
    required this.id,
    required this.title,
    required this.friendId,
    required this.friendName,
    required this.friendAvatar,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.description,
    this.receiptImagePath,
  });

  String get amountText {
    final prefix = type == TransactionType.owed ? '+' : '-';
    return '$prefix₹${amount.toStringAsFixed(2)}';
  }

  String get statusText {
    switch (type) {
      case TransactionType.owed:
        return 'OWED';
      case TransactionType.owing:
        return 'PENDING';
      case TransactionType.settled:
        return 'SETTLED';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'friendId': friendId,
      'friendName': friendName,
      'friendAvatar': friendAvatar,
      'amount': amount,
      'type': type.name, // Enum Name
      'category': category.name, // Enum Name
      'date': date.toIso8601String(),
      'description': description,
      'receiptImagePath': receiptImagePath,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      friendId: json['friendId'],
      friendName: json['friendName'],
      friendAvatar: json['friendAvatar'],
      amount: json['amount'],
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.owing,
      ),
      category: TransactionCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => TransactionCategory.other,
      ),
      date: DateTime.parse(json['date']),
      description: json['description'],
      receiptImagePath: json['receiptImagePath'],
    );
  }
}
