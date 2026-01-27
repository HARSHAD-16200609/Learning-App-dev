import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/expense_provider.dart';
import '../models/friend.dart';
import '../models/transaction.dart' as model;
import 'contact_picker_screen.dart';

class AddTransactionScreen extends StatefulWidget {
  final double? initialAmount;
  final String? initialDescription;
  final DateTime? initialDate;
  final String? initialFriendId;
  final bool? initialPaidByMe;

  const AddTransactionScreen({
    super.key,
    this.initialAmount,
    this.initialDescription,
    this.initialDate,
    this.initialFriendId,
    this.initialPaidByMe,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  
  // Multi-select support
  final Set<String> _selectedFriendIds = {};
  
  // Custom Split support
  bool _isEqualSplit = true;
  final Map<String, TextEditingController> _splitControllers = {};

  bool _iPaid = true;
  DateTime _selectedDate = DateTime.now();
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
        text: widget.initialAmount?.toStringAsFixed(2) ?? '0.00');
    _descriptionController =
        TextEditingController(text: widget.initialDescription ?? '');
    
    if (widget.initialFriendId != null) {
      _selectedFriendIds.add(widget.initialFriendId!);
    }
    
    _iPaid = widget.initialPaidByMe ?? true;
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate!;
    }
    
    _amountController.addListener(_updateSplitAmounts);
  }

  @override
  void dispose() {
    _amountController.removeListener(_updateSplitAmounts);
    _amountController.dispose();
    _descriptionController.dispose();
    for (var controller in _splitControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateSplitAmounts() {
    if (_isEqualSplit && _selectedFriendIds.isNotEmpty) {
       // Logic handled in build or save usually, 
       // but here we might want to update UI if we showed calculated split.
       // For now, no-op, we calculate on save or render.
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final primaryColor = Theme.of(context).colorScheme.primary;

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
        title: Text(
          'Add Transaction',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Friends
                  // (Simplified for brevity, same as before)
                   Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: isDark
                          ? null
                          : Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Icon(
                          Icons.search_rounded,
                          color: isDark ? Colors.grey[500] : Colors.grey[400],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search friends',
                              hintStyle: TextStyle(
                                color:
                                    isDark ? Colors.grey[500] : Colors.grey[400],
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color:
                                  isDark ? Colors.white : const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Friend Selection
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // +2 for 'Me' (start) and 'Add' (end)
                      itemCount: expenseProvider.friends.length + 2,
                      itemBuilder: (context, index) {
                        // 1. "Me" Option (Index 0)
                        if (index == 0) {
                          return _buildFriendAvatar(
                            context,
                            'Me',
                            expenseProvider.userAvatar,
                            isSelected: _selectedFriendIds.isEmpty,
                            onTap: () {
                               setState(() {
                                 _selectedFriendIds.clear();
                                 for (var c in _splitControllers.values) c.dispose();
                                 _splitControllers.clear();
                               });
                            },
                            isDark: isDark,
                            showBorder: true,
                          );
                        }

                        // 2. "Add Friend" Option (Last Index)
                        if (index == expenseProvider.friends.length + 1) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push<dynamic>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ContactPickerScreen(multiSelect: true),
                                      ),
                                    );
                                    if (result != null && result is List<Friend>) {
                                      expenseProvider.addFriendsFromContacts(result);
                                      // Add newly picked friends to selection
                                      setState(() {
                                        for (var f in result) {
                                          if (!_selectedFriendIds.contains(f.id)) {
                                            _selectedFriendIds.add(f.id);
                                            _splitControllers[f.id] = TextEditingController();
                                          }
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                                        width: 1,
                                      ),
                                      color: isDark ? Colors.white10 : Colors.grey[100],
                                    ),
                                    child: Icon(
                                      Icons.add_rounded,
                                      color: isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Add',
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // 3. Friend List Options (Index 1..N)
                        final friend = expenseProvider.friends[index - 1];
                        final isSelected = _selectedFriendIds.contains(friend.id);
                        return _buildFriendAvatar(
                          context,
                          friend.name.split(' ').first,
                          friend.avatarUrl,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedFriendIds.remove(friend.id);
                                _splitControllers[friend.id]?.dispose();
                                _splitControllers.remove(friend.id);
                              } else {
                                _selectedFriendIds.add(friend.id);
                                _splitControllers[friend.id] = TextEditingController();
                              }
                            });
                          },
                          isDark: isDark,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Amount
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'AMOUNT',
                          style: TextStyle(
                            color: isDark ? Colors.grey[500] : Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\₹',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            IntrinsicWidth(
                              child: TextField(
                                controller: _amountController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1E293B),
                                  fontSize: 56,
                                  fontWeight: FontWeight.w700,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Split Configuration (Only if multiple friends selected)
                  if (_selectedFriendIds.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'SPLIT METHOD',
                          style: TextStyle(
                            color: isDark ? Colors.grey[500] : Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                        // Toggle
                        Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => setState(() => _isEqualSplit = true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: _isEqualSplit ? primaryColor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Equal',
                                    style: TextStyle(
                                      color: _isEqualSplit ? Colors.white : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _isEqualSplit = false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  margin: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: !_isEqualSplit ? primaryColor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Custom',
                                    style: TextStyle(
                                      color: !_isEqualSplit ? Colors.white : (isDark ? Colors.grey[400] : Colors.grey[600]),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    if (_isEqualSplit)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ?  Colors.white10 : Colors.grey[200]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, size: 18, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Checking split for ${_selectedFriendIds.length} friends.\n'
                                'Each will pay: ₹${((double.tryParse(_amountController.text) ?? 0) / _selectedFriendIds.length).toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: _selectedFriendIds.map((id) {
                          final friend = expenseProvider.getFriendById(id);
                          if (friend == null) return const SizedBox.shrink();
                          
                          // Ensure controller exists
                          if (!_splitControllers.containsKey(id)) {
                            _splitControllers[id] = TextEditingController();
                          }
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(friend.avatarUrl),
                                  radius: 16,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    friend.name,
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isDark ? Colors.white24 : Colors.grey[300]!,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '₹',
                                        style: TextStyle(
                                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: TextField(
                                          controller: _splitControllers[id],
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            isDense: true,
                                          ),
                                          style: TextStyle(
                                            color: isDark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 24),
                  ],

                  // Who Paid Toggle
                  Text(
                    'Who paid?',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: isDark
                          ? null
                          : Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _iPaid = true),
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: _iPaid ? primaryColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'I paid',
                                  style: TextStyle(
                                    color: _iPaid
                                        ? Colors.white
                                        : (isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[600]),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _iPaid = false),
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color:
                                    !_iPaid ? primaryColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'They paid',
                                  style: TextStyle(
                                    color: !_iPaid
                                        ? Colors.white
                                        : (isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[600]),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    "WHAT'S IT FOR?",
                    style: TextStyle(
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: isDark
                          ? null
                          : Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Icon(
                          Icons.receipt_long_rounded,
                          color: isDark ? Colors.grey[500] : Colors.grey[400],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              hintText: 'Dinner, movie, groceries...',
                              hintStyle: TextStyle(
                                color:
                                    isDark ? Colors.grey[500] : Colors.grey[400],
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color:
                                  isDark ? Colors.white : const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Date
                  Text(
                    'DATE',
                    style: TextStyle(
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: isDark
                            ? null
                            : Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 1,
                              ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          Icon(
                            Icons.calendar_today_rounded,
                            color: isDark ? Colors.grey[500] : Colors.grey[400],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _formatDate(_selectedDate),
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1E293B),
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: isDark ? Colors.grey[500] : Colors.grey[400],
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Save Button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_rounded, size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Save Transaction',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendAvatar(
    BuildContext context,
    String name,
    String avatarUrl, {
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    bool showBorder = false,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(avatarUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                color: isSelected
                    ? primaryColor
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (selectedDay == today) {
      return 'Today, ${_getMonthName(date.month)} ${date.day}';
    }
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  void _saveTransaction() {
    if (_selectedFriendIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one friend')),
      );
      return;
    }
    
    final totalAmount = double.tryParse(_amountController.text) ?? 0.0;
    if (totalAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    // Validate Split
    Map<String, double> finalAmounts = {};
    if (!_isEqualSplit) {
       double currentSum = 0;
       for (var id in _selectedFriendIds) {
          final amt = double.tryParse(_splitControllers[id]?.text ?? '0') ?? 0;
          finalAmounts[id] = amt;
          currentSum += amt;
       }
       // Allow 0.5 difference for rounding flexibility
       if ((currentSum - totalAmount).abs() > 0.5) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Split total (₹${currentSum.toStringAsFixed(2)}) does not match Total (₹${totalAmount.toStringAsFixed(2)})')),
          );
          return;
       }
    } else {
       final splitAmt = totalAmount / _selectedFriendIds.length;
       for (var id in _selectedFriendIds) {
          finalAmounts[id] = splitAmt;
       }
    }

    final provider = Provider.of<ExpenseProvider>(context, listen: false);

    for (var friendId in _selectedFriendIds) {
      final friend = provider.getFriendById(friendId);
      if (friend == null) continue;

      final amount = finalAmounts[friendId]!;
      if (amount <= 0.01) continue; // Skip near-zero amounts
      
      final transaction = model.Transaction(
        id: const Uuid().v4(),
        title: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : 'Expense',
        friendId: friend.id,
        friendName: friend.name.split(' ').first,
        friendAvatar: friend.avatarUrl,
        amount: amount,
        type: _iPaid ? model.TransactionType.owed : model.TransactionType.owing,
        category: model.TransactionCategory.other,
        date: _selectedDate,
        description: _descriptionController.text,
      );

      provider.addTransaction(transaction);

      // Update friend balance
      final balanceChange = _iPaid ? amount : -amount;
      provider.updateFriendBalance(friend.id, balanceChange);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction saved successfully')),
    );
  }
}
