import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/friend.dart';
import '../models/transaction.dart';
import '../widgets/transaction_tile.dart';
import '../widgets/upi_payment_button.dart';
import '../widgets/contact_avatar.dart';

class FriendDetailScreen extends StatelessWidget {
  final Friend friend;

  const FriendDetailScreen({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final transactions = expenseProvider.getTransactionsForFriend(friend.id);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.chevron_left_rounded,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            size: 32,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_horiz_rounded,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Avatar
            ContactAvatar(
              friend: friend,
              size: 120,
              borderColor: isDark
                  ? const Color(0xFF374151)
                  : const Color(0xFFE2E8F0),
              borderWidth: 4,
            ),
            const SizedBox(height: 20),

            // Name
            Text(
              friend.name,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1E293B),
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),

            // Balance Text
            Text(
              _getBalanceText(friend),
              style: TextStyle(
                color: friend.isSettled
                    ? Colors.grey
                    : (friend.owesYou
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444)),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 28),

            // Settle Up Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: friend.isSettled
                    ? null
                    : () => _showSettleUpDialog(context, friend, expenseProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      isDark ? const Color(0xFF374151) : Colors.grey[300],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.account_balance_wallet_rounded, size: 22),
                label: const Text(
                  'Settle Up',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // GPay button - only show when you owe them money
            if (friend.youOwe)
              UpiPaymentButton(
                phoneNumber: friend.phoneNumber ?? '',
                amount: friend.balance.abs(),
                payeeName: friend.name,
              ),
            if (friend.youOwe)
              const SizedBox(height: 16),
            const SizedBox(height: 32),

            // Recent Transactions Header
            Row(
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
                    'View All',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Transactions List
            if (transactions.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 48,
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No transactions yet',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...transactions.take(5).map((transaction) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TransactionTile(
                      transaction: transaction,
                      isDark: isDark,
                      showAvatar: false,
                    ),
                  )),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _getBalanceText(Friend friend) {
    if (friend.isSettled) return 'All settled up!';
    final absBalance = friend.balance.abs().toStringAsFixed(2);
    if (friend.owesYou) {
      return '${friend.name.split(' ').first} owes you ₹$absBalance';
    }
    return 'You owe ${friend.name.split(' ').first} ₹$absBalance';
  }

  void _showSettleUpDialog(
      BuildContext context, Friend friend, ExpenseProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settle Up'),
        content: Text(
            'Mark all balances with ${friend.name} as settled?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.settleUp(friend.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Settle'),
          ),
        ],
      ),
    );
  }
}
