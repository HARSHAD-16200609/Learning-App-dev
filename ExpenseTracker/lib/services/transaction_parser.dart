import 'package:intl/intl.dart';
import '../models/friend.dart';

class ParsedTransaction {
  final double? amount;
  final DateTime? date;
  final String? description;
  final String? friendId;
  final bool? isPaidByMe; // true = I paid (owed), false = They paid (owing)

  ParsedTransaction({
    this.amount,
    this.date,
    this.description,
    this.friendId,
    this.isPaidByMe,
  });
}

class TransactionParser {
  static ParsedTransaction parse(String text, List<Friend> friends) {
    if (text.isEmpty) return ParsedTransaction();

    double? amount;
    DateTime? date;
    String? friendId;
    bool? isPaidByMe;

    // 1. Extract Amount
    // Enhanced regex to capture various currency formats:
    // ₹ 1,234.56, Rs. 500, INR 500, $50.00, 500.00
    // Captures: 1: Symbol (optional), 2: Number
    final amountRegex = RegExp(r'(₹|Rs\.?|INR|\$)\s?([\d,]+\.?\d{0,2})|(\b\d{1,3}(?:,\d{3})*(?:\.\d{2})?\b)');
    
    final matches = amountRegex.allMatches(text);
    List<double> candidates = [];

    for (final match in matches) {
      String numberStr = '';
      bool hasSymbol = false;

      if (match.group(2) != null) {
        // Matched with symbol (Group 1 is symbol, Group 2 is number)
        numberStr = match.group(2)!;
        hasSymbol = true;
      } else if (match.group(3) != null) {
        // Matched raw number
        numberStr = match.group(3)!;
      }

      // Cleanup
      numberStr = numberStr.replaceAll(',', '');
      final val = double.tryParse(numberStr);

      if (val != null && val > 0) {
        // Filter out likely years (2020-2030) if they don't have decimals
        if (!numberStr.contains('.') && val >= 2000 && val <= 2030) continue;
        
        // Filter out phone numbers (large integers > 100000 generally aren't transaction amounts unless specific context)
        // Unless it has a currency symbol
        if (!hasSymbol && val > 100000 && !numberStr.contains('.')) continue;

        // Prioritize if it has a symbol or looks like a decimal amount
        if (hasSymbol) {
             // High confidence
             candidates.insert(0, val);
        } else if (numberStr.contains('.')) {
             candidates.add(val);
        } else {
             candidates.add(val);
        }
      }
    }
    
    // Select the best candidate
    // Heuristic: Max amount is usually the total
    if (candidates.isNotEmpty) {
      // Sort descending to find broad "Max" but be careful of sub-totals vs total. 
      // Often the largest number is the total.
      candidates.sort((a, b) => b.compareTo(a));
      amount = candidates.first;
    }

    // 2. Extract Date
    // Supported formats: dd/MM/yyyy, dd-MM-yyyy, yyyy-MM-dd, MMM dd, yyyy
    final datePatterns = [
      RegExp(r'\b(\d{1,2})[/-](\d{1,2})[/-](\d{4})\b'), // 25/12/2023
      RegExp(r'\b(\d{4})[/-](\d{1,2})[/-](\d{1,2})\b'), // 2023-12-25
      RegExp(r'\b(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\.?\s+(\d{1,2}),?\s+(\d{4})\b', caseSensitive: false), // Dec 25, 2023
    ];

    for (final regex in datePatterns) {
      final match = regex.firstMatch(text);
      if (match != null) {
        try {
          String matchString = match.group(0)!;
          // Attempt standard parsers
          List<String> formats = ['d/M/y', 'y-M-d', 'MMM d, y', 'MMM d y'];
          for (var fmt in formats) {
            try {
               date = DateFormat(fmt).parse(matchString.replaceAll(RegExp(r'[-/.]'), '/'));
               break;
            } catch (_) {}
          }
          if (date != null) break;
        } catch (_) {}
      }
    }

    // 3. Find Friend & Direction
    final lowerText = text.toLowerCase();
    
    for (final friend in friends) {
      final firstName = friend.name.split(' ').first.toLowerCase();
      final fullName = friend.name.toLowerCase();
      
      if (lowerText.contains(fullName) || lowerText.contains(firstName)) {
        friendId = friend.id;
        
        if (lowerText.contains('paid to $firstName') || lowerText.contains('sent to $firstName')) {
          isPaidByMe = true;
        } else if (lowerText.contains('received from $firstName') || lowerText.contains('$firstName paid') || lowerText.contains('from $firstName')) {
          isPaidByMe = false;
        }
        break; // Stop after first match
      }
    }
    
    // Default description
    String description = "Scanned Transaction";
    if (friendId != null) {
       // Optional: Add logic to extract merchant name
    }

    return ParsedTransaction(
      amount: amount,
      date: date ?? DateTime.now(),
      description: description,
      friendId: friendId,
      isPaidByMe: isPaidByMe ?? true, // Default to I paid
    );
  }
}
