import 'package:flutter/material.dart';
import '../models/friend.dart';
import '../models/transaction.dart';
import '../models/group.dart';

class ExpenseProvider extends ChangeNotifier {
  // Sample avatar URLs using placeholder images
  static const String _avatar1 = 'https://i.pravatar.cc/150?img=1';
  static const String _avatar2 = 'https://i.pravatar.cc/150?img=2';
  static const String _avatar3 = 'https://i.pravatar.cc/150?img=3';
  static const String _avatar4 = 'https://i.pravatar.cc/150?img=4';
  static const String _avatar5 = 'https://i.pravatar.cc/150?img=5';
  static const String _avatar6 = 'https://i.pravatar.cc/150?img=6';
  static const String _avatar7 = 'https://i.pravatar.cc/150?img=7';
  static const String _userAvatar = 'https://i.pravatar.cc/150?img=8';

  // Current user data
  final String userName = 'Alex Rivera';
  String get userAvatar => _userAvatar;

  // Friends list
  final List<Friend> _friends = [
    Friend(
      id: '1',
      name: 'Jordan Smith',
      avatarUrl: _avatar1,
      balance: 40.00,
      lastActivity: 'Owes you for Dinner',
      lastActivityDate: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Friend(
      id: '2',
      name: 'Sarah Jenkins',
      avatarUrl: _avatar2,
      balance: -15.50,
      lastActivity: 'You owe for Groceries',
      lastActivityDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Friend(
      id: '3',
      name: 'Marcus Lee',
      avatarUrl: _avatar3,
      balance: 22.00,
      lastActivity: 'Owes you for Movie Night',
      lastActivityDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Friend(
      id: '4',
      name: 'Emma Watson',
      avatarUrl: _avatar4,
      balance: 0.0,
      lastActivity: 'Settled up',
      lastActivityDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Friend(
      id: '5',
      name: 'Michael Chen',
      avatarUrl: _avatar5,
      balance: -45.20,
      lastActivity: 'You owe for Restaurant',
      lastActivityDate: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Friend(
      id: '6',
      name: 'James Wilson',
      avatarUrl: _avatar6,
      balance: 125.00,
      lastActivity: 'Owes you for Rent',
      lastActivityDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  // Transactions list
  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      title: 'Dinner at Joe\'s Pizza',
      friendId: '3',
      friendName: 'Marcus',
      friendAvatar: _avatar3,
      amount: 24.50,
      type: TransactionType.owing,
      category: TransactionCategory.food,
      date: DateTime.now(),
      description: 'Split with Marcus',
    ),
    Transaction(
      id: '2',
      title: 'Grocery shopping',
      friendId: '2',
      friendName: 'Sarah',
      friendAvatar: _avatar2,
      amount: 15.00,
      type: TransactionType.owed,
      category: TransactionCategory.shopping,
      date: DateTime.now(),
      description: 'Sarah paid you',
    ),
    Transaction(
      id: '3',
      title: 'Movie tickets',
      friendId: '3',
      friendName: 'Marcus',
      friendAvatar: _avatar3,
      amount: 12.00,
      type: TransactionType.owing,
      category: TransactionCategory.entertainment,
      date: DateTime.now().subtract(const Duration(days: 1)),
      description: 'Cinema City',
    ),
    Transaction(
      id: '4',
      title: 'Gas Station',
      friendId: '1',
      friendName: 'Jordan',
      friendAvatar: _avatar1,
      amount: 42.80,
      type: TransactionType.owed,
      category: TransactionCategory.transport,
      date: DateTime.now().subtract(const Duration(days: 1)),
      description: 'Trip to Beach',
    ),
    Transaction(
      id: '5',
      title: 'Uber Ride',
      friendId: '7',
      friendName: 'David',
      friendAvatar: _avatar7,
      amount: 8.50,
      type: TransactionType.owing,
      category: TransactionCategory.transport,
      date: DateTime.now().subtract(const Duration(days: 1)),
      description: 'David paid',
    ),
    Transaction(
      id: '6',
      title: 'Dinner at Gusto',
      friendId: '1',
      friendName: 'Jordan',
      friendAvatar: _avatar1,
      amount: 22.50,
      type: TransactionType.owed,
      category: TransactionCategory.food,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: '7',
      title: 'Uber Ride',
      friendId: '5',
      friendName: 'Michael',
      friendAvatar: _avatar5,
      amount: 12.00,
      type: TransactionType.owed,
      category: TransactionCategory.transport,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Transaction(
      id: '8',
      title: 'Grocery Split',
      friendId: '2',
      friendName: 'Sarah',
      friendAvatar: _avatar2,
      amount: 10.50,
      type: TransactionType.owed,
      category: TransactionCategory.shopping,
      date: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Transaction(
      id: '9',
      title: 'Movie Tickets',
      friendId: '3',
      friendName: 'Marcus',
      friendAvatar: _avatar3,
      amount: 15.00,
      type: TransactionType.settled,
      category: TransactionCategory.entertainment,
      date: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  // Groups list
  final List<ExpenseGroup> _groups = [
    ExpenseGroup(
      id: '1',
      name: 'Roommates',
      icon: Icons.home_rounded,
      color: const Color(0xFF3B82F6),
      balance: -120.00,
      memberIds: ['1', '2', '3'],
    ),
    ExpenseGroup(
      id: '2',
      name: 'Bali Trip',
      icon: Icons.flight_rounded,
      color: const Color(0xFF10B981),
      balance: 450.00,
      memberIds: ['1', '2', '4', '5'],
    ),
    ExpenseGroup(
      id: '3',
      name: 'Foodies',
      icon: Icons.restaurant_rounded,
      color: const Color(0xFF8B5CF6),
      balance: 0.0,
      memberIds: ['2', '3', '6'],
    ),
  ];

  // Getters
  List<Friend> get friends => List.unmodifiable(_friends);
  List<Transaction> get transactions => List.unmodifiable(_transactions);
  List<ExpenseGroup> get groups => List.unmodifiable(_groups);

  double get totalBalance {
    return _friends.fold(0.0, (sum, friend) => sum + friend.balance);
  }

  double get totalOwed {
    return _friends
        .where((f) => f.balance > 0)
        .fold(0.0, (sum, friend) => sum + friend.balance);
  }

  double get totalOwing {
    return _friends
        .where((f) => f.balance < 0)
        .fold(0.0, (sum, friend) => sum + friend.balance.abs());
  }

  double get weeklyChange => 120.50; // Sample data

  List<Transaction> get todayTransactions {
    final today = DateTime.now();
    return _transactions.where((t) {
      return t.date.year == today.year &&
          t.date.month == today.month &&
          t.date.day == today.day;
    }).toList();
  }

  List<Transaction> get yesterdayTransactions {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _transactions.where((t) {
      return t.date.year == yesterday.year &&
          t.date.month == yesterday.month &&
          t.date.day == yesterday.day;
    }).toList();
  }

  List<Transaction> getTransactionsForFriend(String friendId) {
    return _transactions.where((t) => t.friendId == friendId).toList();
  }

  Friend? getFriendById(String id) {
    try {
      return _friends.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  void addTransaction(Transaction transaction) {
    _transactions.insert(0, transaction);
    notifyListeners();
  }

  void addFriend(Friend friend) {
    // Check if friend already exists
    final exists = _friends.any((f) => f.id == friend.id);
    if (!exists) {
      _friends.add(friend);
      notifyListeners();
    }
  }

  void addFriendsFromContacts(List<Friend> contacts) {
    for (final contact in contacts) {
      final exists = _friends.any((f) => f.id == contact.id);
      if (!exists) {
        _friends.add(contact);
      }
    }
    notifyListeners();
  }

  void removeFriend(String friendId) {
    _friends.removeWhere((f) => f.id == friendId);
    notifyListeners();
  }

  void updateFriendBalance(String friendId, double amount) {
    final index = _friends.indexWhere((f) => f.id == friendId);
    if (index != -1) {
      final friend = _friends[index];
      _friends[index] = friend.copyWith(
        balance: friend.balance + amount,
        lastActivityDate: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void settleUp(String friendId) {
    final index = _friends.indexWhere((f) => f.id == friendId);
    if (index != -1) {
      final friend = _friends[index];
      _friends[index] = friend.copyWith(
        balance: 0.0,
        lastActivity: 'Settled up',
        lastActivityDate: DateTime.now(),
      );
      notifyListeners();
    }
  }
}
