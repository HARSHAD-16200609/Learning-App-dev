import 'package:flutter/material.dart';

class cart extends StatefulWidget {
  cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {

  List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Nike Air Max 270',
      'price': 150.00,
      'quantity': 1,
      'image': '5daa00d9_afae_4125_a95c_fc71923b81c3.webp',
      'size': '10',
    },
    {
      'name': 'Nike Air Jordan',
      'price': 160.00,
      'quantity': 1,
      'image': '447ce43b_9ffb_49ca_b1af_ba209877be22.webp',
      'size': '9',
    },
    {
      'name': 'Nike Zoom',
      'price': 140.00,
      'quantity': 2,
      'image': 'b5bf7176_9aaa_4e63_8bcd_50f809fc1dab.webp',
      'size': '11',
    },
  ];

  void _incrementQuantity(int index) {
    setState(() {
      cartItems[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity']--;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  double _calculateSubtotal() {
    double subtotal = 0;
    for (var item in cartItems) {
      subtotal += item['price'] * item['quantity'];
    }
    return subtotal;
  }

  double _calculateTax() {
    return _calculateSubtotal() * 0.08; // 8% tax
  }

  double _calculateTotal() {
    return _calculateSubtotal() + _calculateTax();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "S H O P P I N G   C A R T",
          style: TextStyle(
            fontFamily: "times new roman",
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : Column(
        children: [
          // Cart Items List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItem(index);
              },
            ),
          ),

          // Price Summary and Checkout
          _buildCheckoutSection(),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
              fontFamily: "times new roman",
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Add some items to get started',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'Continue Shopping',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(int index) {
    final item = cartItems[index];

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/${item['image']}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "times new roman",
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Size: ${item['size']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${item['price'].toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),

                  // Quantity Controls
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, size: 18),
                              onPressed: () => _decrementQuantity(index),
                              padding: EdgeInsets.all(4),
                              constraints: BoxConstraints(),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '${item['quantity']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, size: 18),
                              onPressed: () => _incrementQuantity(index),
                              padding: EdgeInsets.all(4),
                              constraints: BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _removeItem(index),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Subtotal
            _buildPriceRow('Subtotal', _calculateSubtotal()),
            SizedBox(height: 12),

            // Tax
            _buildPriceRow('Tax (8%)', _calculateTax()),
            SizedBox(height: 12),

            Divider(thickness: 1.5),
            SizedBox(height: 12),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "times new roman",
                  ),
                ),
                Text(
                  '\$${_calculateTotal().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Show checkout confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Proceeding to checkout...'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'PROCEED  TO  CHECKOUT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white,
                    fontFamily: "times new roman",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
