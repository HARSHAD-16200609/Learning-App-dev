import 'dart:typed_data';

class Friend {
  final String id;
  final String name;
  final String avatarUrl;
  final double balance; // positive = they owe you, negative = you owe them
  final String? lastActivity;
  final DateTime? lastActivityDate;
  final Uint8List? photoBytes; // For device contact photos
  final String? phoneNumber;
  final String? email;

  Friend({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.balance = 0.0,
    this.lastActivity,
    this.lastActivityDate,
    this.photoBytes,
    this.phoneNumber,
    this.email,
  });

  bool get owesYou => balance > 0;
  bool get youOwe => balance < 0;
  bool get isSettled => balance == 0;

  bool get hasPhoto => photoBytes != null && photoBytes!.isNotEmpty;

  String get balanceText {
    if (isSettled) return 'Settled up';
    final absBalance = balance.abs().toStringAsFixed(2);
    if (owesYou) return 'Owes you \$$absBalance';
    return 'You owe \$$absBalance';
  }

  // Get initials for avatar placeholder
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  // Copy with new balance
  Friend copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    double? balance,
    String? lastActivity,
    DateTime? lastActivityDate,
    Uint8List? photoBytes,
    String? phoneNumber,
    String? email,
  }) {
    return Friend(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      balance: balance ?? this.balance,
      lastActivity: lastActivity ?? this.lastActivity,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      photoBytes: photoBytes ?? this.photoBytes,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
    );
  }
}
