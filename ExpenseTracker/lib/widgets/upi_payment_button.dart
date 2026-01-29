import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A reusable button widget that initiates a Google Pay (UPI) transaction.
class UpiPaymentButton extends StatelessWidget {
  final String phoneNumber;
  final double amount;
  final String payeeName;

  const UpiPaymentButton({
    super.key,
    required this.phoneNumber,
    required this.amount,
    required this.payeeName,
  });

  /// Initiates the UPI payment process using the `url_launcher` package.
  ///
  /// This function constructs a UPI URI with the specific parameters required
  /// for the transaction (payee, amount, note, etc.) and attempts to launch
  /// an external application (like Google Pay) to handle the request.
  Future<void> payWithGPay(BuildContext context) async {
    // Validate phone number
    if (phoneNumber.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contact phone number not available'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Construct UPI ID from phone number (assuming GPay format: phone@paytm or phone@okaxis)
    // You can modify this based on your preferred UPI provider
    final String payeeAddress = '$phoneNumber@paytm';
    final String transactionNote = 'Payment to $payeeName';
    final String amountStr = amount.toStringAsFixed(2);
    const String currency = 'INR';

    // Construct the UPI URI
    // The format is: upi://pay?pa=<payee>&pn=<name>&tn=<note>&am=<amount>&cu=<currency>
    final Uri upiUri = Uri(
      scheme: 'upi',
      host: 'pay',
      queryParameters: {
        'pa': payeeAddress,
        'pn': payeeName,
        'tn': transactionNote,
        'am': amountStr,
        'cu': currency,
      },
    );

    try {
      // Check if the device can handle the UPI scheme (requires <queries> in AndroidManifest)
      bool canLaunch = await canLaunchUrl(upiUri);

      if (canLaunch) {
         await launchUrl(
          upiUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback: Try to launch it anyway, as canLaunchUrl sometimes returns false negatives
        // on some Android versions locally or if the package visibility is restrictive.
        try {
          await launchUrl(
            upiUri,
            mode: LaunchMode.externalApplication,
          );
        } catch (e) {
             if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No UPI app found (e.g., Google Pay). Please install one to proceed.'),
                    backgroundColor: Colors.red,
                  ),
                );
             }
        }
      }
    } catch (e) {
      // Catch any other errors that might occur during the launch process
       if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not launch payment: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => payWithGPay(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, // GPay-ish theme
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
           // Using a generic icon as we don't have the GPay vector asset handy, 
           // but keeping it semantic.
          const Icon(Icons.payment, size: 20),
          const SizedBox(width: 8),
          Text(
            'Pay ₹${amount.toStringAsFixed(2)} with GPay',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
