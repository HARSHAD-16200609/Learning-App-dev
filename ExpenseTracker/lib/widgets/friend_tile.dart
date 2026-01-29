import 'package:flutter/material.dart';
import '../models/friend.dart';
import 'contact_avatar.dart';

class FriendTile extends StatelessWidget {
  final Friend friend;
  final bool isDark;
  final VoidCallback? onTap;

  const FriendTile({
    super.key,
    required this.friend,
    required this.isDark,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
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
            // Avatar using ContactAvatar
            ContactAvatar(
              friend: friend,
              size: 48,
              borderColor: _getBorderColor(),
              borderWidth: 2,
            ),
            const SizedBox(width: 14),

            // Name and Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    friend.lastActivity ?? friend.balanceText,
                    style: TextStyle(
                      color: _getBalanceColor(),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Amount and Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _getAmountText(),
                  style: TextStyle(
                    color: _getBalanceColor(),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (friend.lastActivityDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      _getTimeAgo(friend.lastActivityDate!),
                      style: TextStyle(
                        color: isDark ? Colors.grey[500] : Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Color _getBorderColor() {
    if (friend.isSettled) return Colors.grey.withValues(alpha: 0.3);
    if (friend.owesYou) return const Color(0xFF10B981).withValues(alpha: 0.5);
    return const Color(0xFFEF4444).withValues(alpha: 0.5);
  }

  Color _getBalanceColor() {
    if (friend.isSettled) return Colors.grey;
    if (friend.owesYou) return const Color(0xFF10B981);
    return const Color(0xFFEF4444);
  }

  String _getAmountText() {
    if (friend.isSettled) return '';
    final prefix = friend.owesYou ? '+' : '-';
    return '$prefix₹${friend.balance.abs().toStringAsFixed(2)}';
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inHours < 1) {
      return 'Just now';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      return weekdays[date.weekday - 1];
    } else {
      return '${date.month}/${date.day}';
    }
  }
}
