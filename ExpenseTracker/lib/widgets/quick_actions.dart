import 'package:flutter/material.dart';
import '../screens/ocr_screen.dart';
import '../screens/add_bill_screen.dart';
import '../screens/actual_groups_screen.dart';
import '../screens/split_bill_screen.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          context,
          Icons.add_rounded,
          'Add Bill',
          isDark,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddBillScreen()),
            );
          },
        ),
        _buildActionButton(
          context,
          Icons.document_scanner_rounded, // OCR Icon
          'Scan',
          isDark,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OCRScreen()),
            );
          },
        ),
        _buildActionButton(
          context,
          Icons.people_rounded,
          'Groups',
          isDark,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ActualGroupsScreen()),
            );
          },
        ),
        _buildActionButton(
          context,
          Icons.call_split_rounded,
          'Split',
          isDark,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SplitBillScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    bool isDark, {
    required VoidCallback onTap,
  }) {
    // ... existing implementation
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80, // Reduced width to fit 4 items
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
          border: isDark
              ? null
              : Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1,
                ),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: isDark ? 0.15 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1E293B),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
