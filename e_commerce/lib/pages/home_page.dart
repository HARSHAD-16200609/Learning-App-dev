import 'dart:ui';
import 'package:e_commerce/pages/cart.dart';
import 'package:e_commerce/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class home_page extends StatefulWidget {
   home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  final CartModel _cart = CartModel();
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> products = [
    {
      'image': '5daa00d9_afae_4125_a95c_fc71923b81c3.webp',
      'name': 'Air Max 270',
      'description': 'The forward-thinking design of this iconic shoe',
      'price': 2195.0,
      'priceDisplay': '\$2,195',
    },
    {
      'image': '447ce43b_9ffb_49ca_b1af_ba209877be22.webp',
      'name': 'Air Jordan',
      'description': 'Classic style meets modern comfort',
      'price': 2295.0,
      'priceDisplay': '\$2,295',
    },
    {
      'image': 'b5bf7176_9aaa_4e63_8bcd_50f809fc1dab.webp',
      'name': 'Nike Zoom',
      'description': 'Engineered for speed and performance',
      'price': 2095.0,
      'priceDisplay': '\$2,095',
    },
    {
      'image': 'e6da41fa_1be4_4ce5_b89c_22be4f1f02d4.webp',
      'name': 'Nike React',
      'description': 'Ultimate cushioning for all-day comfort',
      'price': 1995.0,
      'priceDisplay': '\$1,995',
    },
    {
      'image': 'NK_NKHQ4614_101_198726385898_1.webp',
      'name': 'Pegasus',
      'description': 'A trusted companion for every run',
      'price': 2150.0,
      'priceDisplay': '\$2,150',
    },
    {
      'image': 'NK_NKIM0542_100_198728663048_1.webp',
      'name': 'Infinity Run',
      'description': 'Built for the long haul',
      'price': 2250.0,
      'priceDisplay': '\$2,250',
    },
  ];

  void _addToCart(Map<String, dynamic> product) {
    _cart.addItem(
      product['name'],
      product['price'],
      product['image'],
    );
    setState(() {}); // Refresh UI to update cart count
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product added to cart!'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("N I K E",
              style: TextStyle(fontFamily: "times new roman",fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width:200,
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    size: 30,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/cart');
                  },
                ),

                // Badge
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Center(
                      child: Text(
                        '${_cart.itemCount}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )

          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[100],
        child:Center(
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                SvgPicture.asset(
                  'assets/images/nike-4-logo-svgrepo-com.svg',
                  width: 160,
                  height: 160,
                ),
                ListTile(
                  leading:Icon(Icons.home,size:25),
                  title: Text("H O M E",style: TextStyle(fontFamily: "times new roman",fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading:Icon(Icons.info,size:25),
                  title: Text("A B O U T ",style: TextStyle(fontFamily: "times new roman",fontWeight: FontWeight.bold)),
                )
              ]
            ),
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
            ),

            // Tagline
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'everyone likes... some far longer than others',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ),

            SizedBox(height: 20),

            // Hot Picks Section Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Hot Picks ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: "times new roman",
                        ),
                      ),
                      Text(
                        '🔥',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),

                ],
              ),
            ),

            SizedBox(height: 16),

            // Horizontal Scrolling Product Cards - Full Width
            Container(
              height: 400,
              child: PageView.builder(
                controller: _pageController,
                itemCount: products.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: _buildProductCard(products[index]),
                  );
                },
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),

      // Floating Bottom Navigation Bar
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Home/Shop Button (Active)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home, color: Colors.black, size: 20),
                      SizedBox(width: 6),
                      Text(
                        'Shop',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: 8),
                
                // Cart Button (Inactive)
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/cart'),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  'assets/images/${product['image'] ?? ''}',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          // Product Details
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Description
                  Text(
                    product['description'] ?? '',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Product Name and Price/Button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Product Name
                      Text(
                        product['name'] ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: "times new roman",
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 4),

                      // Price and Button Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product['priceDisplay'] ?? '\$0',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Add to Cart Button
                          GestureDetector(
                            onTap: () => _addToCart(product),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



