import 'package:flutter/foundation.dart';

class CartItem {
  final String name;
  final double price;
  final String image;
  final String size;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.image,
    this.size = '10',
    this.quantity = 1,
  });
}

class CartModel extends ChangeNotifier {
  static final CartModel _instance = CartModel._internal();
  factory CartModel() => _instance;
  CartModel._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get tax => subtotal * 0.08;

  double get total => subtotal + tax;

  void addItem(String name, double price, String image) {
    // Check if item already exists
    int existingIndex = _items.indexWhere((item) => item.name == name);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(
        name: name,
        price: price,
        image: image,
      ));
    }
    notifyListeners();
  }

  void incrementQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      }
      notifyListeners();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
