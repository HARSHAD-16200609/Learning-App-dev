import 'dart:io';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/friend.dart';
import '../widgets/contact_avatar.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final bool isDark;
  final bool showAvatar;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.isDark,
    this.showAvatar = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showTransactionDetails(context),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
          border: isDark
              ? null
              : Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1,
                ),
        ),
        child: Row(
          children: [
            // Always show Contact Avatar
            Builder(
              builder: (context) {
                final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
                final friend = expenseProvider.friends.firstWhere(
                  (f) => f.id == transaction.friendId,
                  orElse: () => Friend(
                    id: transaction.friendId,
                    name: transaction.friendName,
                    avatarUrl: transaction.friendAvatar,
                  ),
                );
                
                return ContactAvatar(
                  friend: friend,
                  size: 44,
                  borderColor: _getCategoryColor().withValues(alpha: 0.5),
                  borderWidth: 2,
                );
              },
            ),
            const SizedBox(width: 14),

            // Title and Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          transaction.title,
                          style: TextStyle(
                            color: isDark ? Colors.white : const Color(0xFF1E293B),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (transaction.receiptImagePath != null) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.attachment_rounded,
                          size: 14,
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _getSubtitle(),
                    style: TextStyle(
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Amount and Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transaction.amountText,
                  style: TextStyle(
                    color: _getAmountColor(),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  transaction.statusText,
                  style: TextStyle(
                    color: isDark ? Colors.grey[500] : Colors.grey[500],
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Text(
          transaction.title,
          style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1E293B)),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Amount: ${transaction.amountText}',
                style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey[800], fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Date: ${_getSubtitle()}',
                style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
              if (transaction.description != null && transaction.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Note: ${transaction.description}',
                  style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                ),
              ],
              const SizedBox(height: 16),
              if (transaction.receiptImagePath != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Receipt:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(transaction.receiptImagePath!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 100,
                            width: double.infinity,
                            color: isDark ? Colors.white10 : Colors.grey[200],
                            child: Center(
                              child: Text(
                                'Image not found',
                                style: TextStyle(color: isDark ? Colors.white54 : Colors.grey[500]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getAmountColor() {
    switch (transaction.type) {
      case TransactionType.owed:
        return const Color(0xFF10B981);
      case TransactionType.owing:
        return const Color(0xFFEF4444);
      case TransactionType.settled:
        return Colors.grey;
    }
  }

  Color _getCategoryColor() {
    switch (transaction.category) {
      case TransactionCategory.food:
        return const Color(0xFFEAB308);
      case TransactionCategory.transport:
        return const Color(0xFF8B5CF6);
      case TransactionCategory.shopping:
        return const Color(0xFF10B981);
      case TransactionCategory.entertainment:
        return const Color(0xFF6366F1);
      case TransactionCategory.utilities:
        return const Color(0xFF06B6D4);
      case TransactionCategory.other:
        return const Color(0xFF64748B);
    }
  }

  IconData _getCategoryIcon() {
    switch (transaction.category) {
      case TransactionCategory.food:
        return Icons.restaurant_rounded;
      case TransactionCategory.transport:
        return Icons.directions_car_rounded;
      case TransactionCategory.shopping:
        return Icons.shopping_cart_rounded;
      case TransactionCategory.entertainment:
        return Icons.movie_rounded;
      case TransactionCategory.utilities:
        return Icons.bolt_rounded;
      case TransactionCategory.other:
        return Icons.receipt_rounded;
    }
  }

  String _getSubtitle() {
    final time = _formatTime(transaction.date);
    if (transaction.description != null) {
      return '$time · ${transaction.description}';
    }
    return time;
  }

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}
