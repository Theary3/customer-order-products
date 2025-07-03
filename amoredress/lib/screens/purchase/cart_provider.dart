import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartItem {
  final int productId;
  final String name;
  final double price;
  
  final String imagePath;
  final String color;
  final String size;
  int quantity;
  final int stock;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.color,
    required this.size,
    this.quantity = 1,
    required this.stock,
  });
}
// // Mock assets and descriptions
// Map<int, String> productImages = {
//     1: 'assets/images/1.jpg',
//     2: 'assets/images/3.jpg',
//     3: 'assets/images/4.jpg',
//     4: 'assets/images/14.jpg',
//     9: 'assets/images/1.jpg',
//     27: 'assets/images/2.jpg',
//     33:  'assets/images/4.jpg',
//     36: 'assets/images/21.jpg',
//     41: 'assets/images/8.jpg',
//     46: 'assets/images/14.jpg',
//     51:  'assets/images/11.jpg',
//     65: 'assets/images/13.jpg',
//     66:  'assets/images/15.jpg',
//     68: 'assets/images/22.jpg',
//     73: 'assets/images/23.jpg',
//     79: 'assets/images/24.jpg',
//     80:  'assets/images/25.jpg',
//    79: 'assets/images/26.jpg',
//     80: 'assets/images/27.jpg',

// };

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  Map<String, CartItem> get items => _items;

  String _getKey(int productId, String color, String size) => '${productId}_${color}_${size}';

  int get itemCount => _items.length;

  double get totalPrice {
    return _items.values.fold(
      0.0,
      (sum, item) => sum + item.price * item.quantity,
    );
  }

  void addItem(int productId, String name, double price, String imagePath, int stock, int quantity, String color, String size) {
    final key = _getKey(productId, color, size);

    if (_items.containsKey(key)) {
      if (_items[key]!.quantity + quantity <= stock) {
        _items[key]!.quantity += quantity;
      } else {
        _items[key]!.quantity = stock;
      }
    } else {
      _items[key] = CartItem(
        productId: productId,
        name: name,
        price: price,
        imagePath: imagePath,
        stock: stock,
        quantity: quantity,
        color: color,
        size: size,
      );
    }
    notifyListeners();
  }

List<MapEntry<String, CartItem>> get itemEntries => _items.entries.toList();

  void updateQuantity(String key, int newQuantity) {
    if (_items.containsKey(key)) {
      if (newQuantity <= 0) {
        _items.remove(key);
      } else {
        final existing = _items[key]!;
        _items[key] = CartItem(
          productId: existing.productId,
          name: existing.name,
          price: existing.price,
          imagePath: existing.imagePath,
          stock: existing.stock,
          quantity: newQuantity,
          color: existing.color,
          size: existing.size,
        );
      }
      notifyListeners();
    }
  }

  void removeItem(String key) {
    _items.remove(key);
    notifyListeners();
  }

  void decreaseQuantity(String key) {
    if (_items.containsKey(key)) {
      if (_items[key]!.quantity > 1) {
        _items[key]!.quantity--;
      } else {
        _items.remove(key);
      }
      notifyListeners();
    }
  }
  void increaseQuantity(String key) {
  if (_items.containsKey(key)) {
    final item = _items[key]!;
    if (item.quantity < item.stock) {
      item.quantity++;
      notifyListeners();
    }
  }
}


  void clear() {
    _items.clear();
    notifyListeners();
  }

 Future<bool> buyAll() async {
  const String apiUrl = "http://10.0.2.2:8000/api/buy";


  for (var item in _items.values) {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'product_id': item.productId,
          'quantity': item.quantity,
        }),
      );

      if (response.statusCode != 200) {
        debugPrint('Purchase failed for product ${item.productId}: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Exception during purchase: $e');
      return false;
    }
  }

  clear();
  return true;
}

}
