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
  });

  String get amountText {
    final prefix = type == TransactionType.owed ? '+' : '-';
    return '$prefix\$${amount.toStringAsFixed(2)}';
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
}
