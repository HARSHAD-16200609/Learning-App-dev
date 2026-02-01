import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/friend.dart';
import '../models/transaction.dart';
import '../providers/expense_provider.dart';
import '../widgets/contact_avatar.dart';
import 'contact_picker_screen.dart';

class SplitBillScreen extends StatefulWidget {
  const SplitBillScreen({super.key});

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<Friend> _selectedFriends = [];
  bool _includeMe = true;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  double get _amountPerPerson {
    final amount = double.tryParse(_amountController.text) ?? 0;
    int count = _selectedFriends.length + (_includeMe ? 1 : 0);
    return count > 0 ? amount / count : 0;
  }

  void _addFriends() async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (context) => const ContactPickerScreen(multiSelect: true),
      ),
    );

    if (result != null && result is List<Friend>) {
      setState(() {
        for (var friend in result) {
          if (!_selectedFriends.any((f) => f.id == friend.id)) {
            _selectedFriends.add(friend);
          }
        }
      });
    }
  }

  void _splitBill() {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an amount'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedFriends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one friend to split with'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final double totalAmount = double.parse(_amountController.text);
    final double splitAmount = _amountPerPerson;
    final String description = _descriptionController.text.isEmpty ? 'Split Bill' : _descriptionController.text;
    final provider = Provider.of<ExpenseProvider>(context, listen: false);

    // Create transactions for each selected friend
    // Since I paid the full amount, they Owe me their share.
    for (final friend in _selectedFriends) {
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString() + friend.id,
        title: description,
        friendId: friend.id,
        friendName: friend.name,
        friendAvatar: friend.avatarUrl ?? '',
        amount: splitAmount,
        type: TransactionType.owed, // They owe me
        category: TransactionCategory.other,
        date: DateTime.now(),
        description: 'Split bill',
      );
      
      provider.addTransaction(transaction);
      provider.updateFriendBalance(friend.id, splitAmount);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bill split with ${_selectedFriends.length} friends!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Split Bill',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Amount
            Text(
              'Total Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                prefixText: '₹ ',
                prefixStyle: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
                hintText: '0.00',
                filled: true,
                fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),

            const SizedBox(height: 24),

            // Description
            Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: 'Dinner, Movie, etc.',
                hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[400]),
                filled: true,
                fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Split By Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  'Split With',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                TextButton.icon(
                  onPressed: _addFriends,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Add Friends'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                   // Me Option
                   _buildPersonRow(
                      context, 
                      name: 'You', 
                      isSelected: _includeMe, 
                      onTap: () => setState(() => _includeMe = !_includeMe)
                   ),
                   const Divider(),
                   if (_selectedFriends.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'No friends selected',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      )
                   else
                     ..._selectedFriends.map((friend) => Padding(
                       padding: const EdgeInsets.only(bottom: 8.0),
                       child: _buildFriendRow(context, friend),
                     )),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Amount Per Person Display
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount per person',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${_amountPerPerson.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_selectedFriends.length + (_includeMe ? 1 : 0)}',
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 24, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Split Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _splitBill,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Split Bill',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonRow(BuildContext context, {required String name, required bool isSelected, required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
             CircleAvatar(
               backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
               child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
             ),
             const SizedBox(width: 12),
             Text(name, style: TextStyle(
               color: isDark ? Colors.white : Colors.black,
               fontWeight: FontWeight.w600,
               fontSize: 16,
             )),
             const Spacer(),
             if (isSelected) 
               Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
             else 
               Icon(Icons.circle_outlined, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendRow(BuildContext context, Friend friend) {
     final isDark = Theme.of(context).brightness == Brightness.dark;
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 8.0),
       child: Row(
         children: [
            ContactAvatar(friend: friend, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                friend.name,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                   fontWeight: FontWeight.w600,
                   fontSize: 16,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () {
                setState(() {
                  _selectedFriends.remove(friend);
                });
              },
            ),
         ],
       ),
     );
  }
}

