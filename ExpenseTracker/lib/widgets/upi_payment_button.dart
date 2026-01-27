import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// A reusable button widget that initiates a Google Pay (UPI) transaction.
class UpiPaymentButton extends StatelessWidget {
  const UpiPaymentButton({super.key});

  /// Initiates the UPI payment process using the `url_launcher` package.
  ///
  /// This function constructs a UPI URI with the specific parameters required
  /// for the transaction (payee, amount, note, etc.) and attempts to launch
  /// an external application (like Google Pay) to handle the request.
  Future<void> payWithGPay(BuildContext context) async {
    // defined payment details
    const String payeeAddress = 'abc@upi';
    const String payeeName = 'Test Merchant';
    const String transactionNote = 'Order123';
    const String amount = '100';
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
        'am': amount,
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
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
           // Using a generic icon as we don't have the GPay vector asset handy, 
           // but keeping it semantic.
          Icon(Icons.payment, size: 20),
          SizedBox(width: 8),
          Text(
            'Pay with GPay',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
