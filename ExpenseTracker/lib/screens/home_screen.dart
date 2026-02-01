import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/friend.dart';
import '../models/transaction.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/friend_tile.dart';
import '../widgets/transaction_tile.dart';
import 'friend_detail_screen.dart';
import 'contact_picker_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSelectionMode = false;
  final Set<String> _selectedTransactionIds = {};

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      _selectedTransactionIds.clear();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedTransactionIds.contains(id)) {
        _selectedTransactionIds.remove(id);
        if (_selectedTransactionIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedTransactionIds.add(id);
      }
    });
  }

  Future<void> _deleteSelectedTransactions(ExpenseProvider provider) async {
    final count = _selectedTransactionIds.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transactions?'),
        content: Text('Are you sure you want to delete $count transaction${count > 1 ? 's' : ''}? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await provider.deleteTransactions(_selectedTransactionIds.toList());
      setState(() {
        _isSelectionMode = false;
        _selectedTransactionIds.clear();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count transaction${count > 1 ? 's' : ''} deleted')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    // Filter transactions to show (e.g. recent 5, or all if needed)
    // For selection mode, we might want to show more, but user said "from recent transaction".
    // So we just stick to the list displayed.

    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(context, isDark, expenseProvider),
                const SizedBox(height: 20),

                // Balance Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BalanceCard(
                    totalBalance: expenseProvider.totalBalance,
                    totalOwed: expenseProvider.totalOwed,
                    totalOwing: expenseProvider.totalOwing,
                    weeklyChange: expenseProvider.weeklyChange,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Actions
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: QuickActions(),
                ),
                const SizedBox(height: 28),

                // Recent Friends Section
                _buildRecentFriendsSection(context, isDark, expenseProvider),
                const SizedBox(height: 28),

                // Recent Transactions Section
                _buildRecentTransactions(context, isDark, expenseProvider),
                const SizedBox(height: 100), // Bottom padding for nav bar
              ],
            ),
          ),
          
          // Selection Mode Floating Header (Optional overlay for easier actions)
          // Or just handle in the section header. Section header is better.
        ],
      ),
    );
  }

  Future<void> _pickProfileImage(BuildContext context, ExpenseProvider provider) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        provider.updateUserProfile(provider.userName, image.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  // ... (Header, Friends, Groups sections remain unchanged) ...
  Widget _buildHeader(
      BuildContext context, bool isDark, ExpenseProvider provider) {
    
    // Helper to determine image provider
    ImageProvider getImageProvider() {
      if (provider.userAvatar.startsWith('http')) {
        return NetworkImage(provider.userAvatar);
      } else {
        return FileImage(File(provider.userAvatar));
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // Editable Avatar
          GestureDetector(
            onTap: () => _pickProfileImage(context, provider),
            child: Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.white24 : Colors.grey[300]!,
                      width: 2,
                    ),
                    image: DecorationImage(
                      image: getImageProvider(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 1.5),
                    ),
                    child: const Icon(Icons.edit, size: 10, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                provider.userName,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Settings Button (Replaces Notification)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Icon(
                Icons.settings_outlined,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildRecentFriendsSection(
      BuildContext context, bool isDark, ExpenseProvider provider) {
      // ... Copy existing _buildRecentFriendsSection implementation ...
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Friends',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _addFromContacts(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_add_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Add',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (provider.friends.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isDark ? null : Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.people_outline_rounded,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No friends yet',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add friends from your contacts to start splitting expenses',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _addFromContacts(context),
                    icon: const Icon(Icons.person_add_rounded, size: 18),
                    label: const Text('Add from Contacts'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...provider.friends.take(4).map((friend) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: FriendTile(
                  friend: friend,
                  isDark: isDark,
                  onTap: () => _navigateToFriendDetail(context, friend),
                ),
              )),
      ],
    );
  }

  void _addFromContacts(BuildContext context) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (context) => const ContactPickerScreen(multiSelect: true),
      ),
    );

    if (result != null && result is List<Friend>) {
      final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
      expenseProvider.addFriendsFromContacts(result);
    }
  }



  Widget _buildRecentTransactions(
      BuildContext context, bool isDark, ExpenseProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _isSelectionMode
              ? Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black),
                      onPressed: _toggleSelectionMode,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedTransactionIds.length} Selected',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: _selectedTransactionIds.isEmpty 
                          ? null 
                          : () => _deleteSelectedTransactions(provider),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 12),
        if (provider.transactions.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                'No recent transactions',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
          )
        else
          ...provider.transactions.take(10).map((transaction) => Padding( // Increased limit for better usability
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: TransactionTile(
                  transaction: transaction,
                  isDark: isDark,
                  showAvatar: true,
                  isSelectionMode: _isSelectionMode,
                  isSelected: _selectedTransactionIds.contains(transaction.id),
                  onLongPress: () {
                    if (!_isSelectionMode) {
                      _toggleSelectionMode();
                      _toggleSelection(transaction.id);
                    }
                  },
                  onSelectionToggle: () => _toggleSelection(transaction.id),
                ),
              )),
      ],
    );
  }

  void _navigateToFriendDetail(BuildContext context, Friend friend) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FriendDetailScreen(friend: friend),
      ),
    );
  }
}
