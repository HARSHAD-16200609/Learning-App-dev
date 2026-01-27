import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/friend.dart';
import '../models/transaction.dart';
import '../models/group.dart';

class ExpenseProvider extends ChangeNotifier {
  
  // Current user data
  String _userName = 'User';
  String _userAvatar = ''; // Empty string indicates no avatar/default

  String get userName => _userName;
  String get userAvatar => _userAvatar.isNotEmpty ? _userAvatar : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(_userName)}&background=random';

  // Friends list
  List<Friend> _friends = [];

  // Transactions list
  List<Transaction> _transactions = [];

  // Groups list
  List<ExpenseGroup> _groups = [];

  ExpenseProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadData();
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load User Profile
      _userName = prefs.getString('user_name') ?? 'User';
      _userAvatar = prefs.getString('user_avatar') ?? '';

      // Load Friends
      final friendsJson = prefs.getString('friends_data');
      if (friendsJson != null) {
        final List<dynamic> decoded = jsonDecode(friendsJson);
        _friends = decoded.map((e) => Friend.fromJson(e)).toList();
      }

      // Load Transactions
      final transactionsJson = prefs.getString('transactions_data');
      if (transactionsJson != null) {
        final List<dynamic> decoded = jsonDecode(transactionsJson);
        _transactions = decoded.map((e) => Transaction.fromJson(e)).toList();
      }
      
      // Use test data if empty
      if (_friends.isEmpty && _transactions.isEmpty) {
        _generateTestData();
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
      _friends = [];
      _transactions = [];
    }
    notifyListeners();
  }

  void _generateTestData() {
    _userName = 'Test User';
    
    _friends = [
      Friend(id: '1', name: 'Alice', avatarUrl: 'https://i.pravatar.cc/150?u=1', balance: 500.0),
      Friend(id: '2', name: 'Bob', avatarUrl: 'https://i.pravatar.cc/150?u=2', balance: -200.0),
      Friend(id: '3', name: 'Charlie', avatarUrl: 'https://i.pravatar.cc/150?u=3', balance: 0.0),
      Friend(id: '4', name: 'David', avatarUrl: 'https://i.pravatar.cc/150?u=4', balance: 150.0),
    ];

    _transactions = [
      Transaction(
        id: 't1', 
        title: 'Dinner', 
        friendId: '1', 
        friendName: 'Alice', 
        friendAvatar: 'https://i.pravatar.cc/150?u=1', 
        amount: 500.0, 
        type: TransactionType.owed, 
        category: TransactionCategory.food, 
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Transaction(
        id: 't2', 
        title: 'Movie Tickets', 
        friendId: '2', 
        friendName: 'Bob', 
        friendAvatar: 'https://i.pravatar.cc/150?u=2', 
        amount: 200.0, 
        type: TransactionType.owing, 
        category: TransactionCategory.entertainment, 
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Transaction(
        id: 't3', 
        title: 'Uber', 
        friendId: '4', 
        friendName: 'David', 
        friendAvatar: 'https://i.pravatar.cc/150?u=4', 
        amount: 150.0, 
        type: TransactionType.owed, 
        category: TransactionCategory.transport, 
        date: DateTime.now(),
      ),
    ];
    
    _saveFriends();
    _saveTransactions();
    _saveUserProfile();
  }

  Future<void> _saveUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _userName);
    await prefs.setString('user_avatar', _userAvatar);
  }

  Future<void> _saveFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_friends.map((e) => e.toJson()).toList());
    await prefs.setString('friends_data', encoded);
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_transactions.map((e) => e.toJson()).toList());
    await prefs.setString('transactions_data', encoded);
  }

  void updateUserProfile(String name, String? avatarUrl) {
    _userName = name;
    if (avatarUrl != null) {
      _userAvatar = avatarUrl;
    }
    _saveUserProfile();
    notifyListeners();
  }

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

  double get weeklyChange => 0.0; // Dynamic calculation pending

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
    _saveTransactions();
    notifyListeners();
  }

  void addFriend(Friend friend) {
    // Check if friend already exists
    final exists = _friends.any((f) => f.id == friend.id);
    if (!exists) {
      _friends.add(friend);
      _saveFriends();
      notifyListeners();
    }
  }

  void addFriendsFromContacts(List<Friend> contacts) {
    bool changed = false;
    for (final contact in contacts) {
      final exists = _friends.any((f) => f.id == contact.id);
      if (!exists) {
        _friends.add(contact);
        changed = true;
      }
    }
    if (changed) {
      _saveFriends();
      notifyListeners();
    }
  }

  void removeFriend(String friendId) {
    _friends.removeWhere((f) => f.id == friendId);
    _saveFriends();
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
      _saveFriends();
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
      _saveFriends();
      notifyListeners();
    }
  }
}
