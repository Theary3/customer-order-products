import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_provider.dart';
import 'order_confirmation.dart'; 

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isLoading = false;

  static const Map<String, String> imagesByName = {
    'Floral Summer Dress': '1.jpg',
    'Classic Denim Jacket': '2.jpg',
    'Leather Crossbody Bag': '4.jpg',
    'White Sneakers': '21.jpg',
    'Satin Blouse': '8.jpg',
    'Ankle Boots': '14.jpg',
    'Slim Fit Chinos': '11.jpg',
    'Men Outfit': '13.jpg',
    'Kids Collection': '15.jpg',
    'Casual V-Neck T-Shirt': '22.jpg',
    'High Waist Leggings': '23.jpg',
    'Lightweight Flat Sandals': '24.jpg',
    'Basic Cotton T-Shirt': '25.jpg',
    '	Lightweight Windbreaker': '26.jpg',
    'Sports Cap': '27.jpg',
    'Floral Maxi Dress': 'Floral Maxi Dress.jpg',
    'Casual Polo Shirt': 'Casual Polo Shirt.jpg',
    'Graphic T-Shirt': 'Graphic T-Shirt1.jpg',
    'Wool Scarf': 'Wool Scarf.jpg',
    'Running Shoes': 'Running Shoes.jpg',
    'Leather Handbag': 'Leather Handbag.jpg',
    'Winter Coat': 'Winter Coat.jpg',
    'Sneakers': 'Sneakers.jpg',
    'Chiffon Blouse': 'Chiffon Blouse1.jpg',
    'Leather Belt': 'Leather Belt.jpg',
    'Denim Overalls': 'Denim Overalls.jpg',
    'Leather Loafers': 'Leather Loafers.jpg',
    'Baseball Cap': 'Baseball Cap.jpg',
    'Pleated Skirt': 'Pleated Skirt.jpg',
    'Graphic Hoodie': 'Graphic Hoodie.jpg',
    'Rain Jacket': '1Rain Jacket.jpg',
    'Winter Boots': 'Winter Boots.jpg',
    'Leather Gloves': 'Leather Gloves.jpg',
    'Knitted Sweater': 'Knitted Sweater.jpg',
    'Chino Shorts': 'Chino Shorts.jpg',
    'Cotton Pajamas': 'Cotton Pajamas.jpg',
    'Sandals': 'sandals.jpg',
  };

  String _generateOrderId() {
    final random = Random();
    return 'ORD${DateTime.now().millisecondsSinceEpoch}${random.nextInt(999)}';
  }

  Future<void> _buyProduct(int productId, int quantity, int customerId) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/buy');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'product_id': productId,
          'quantity': quantity,
          'customer_id': customerId,
        }),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(result['error'] ?? 'Failed to buy');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
    print(
      'Buying productId=$productId, quantity=$quantity, customerId=$customerId',
    );
    print('productId type: ${productId.runtimeType}');
    print('quantity type: ${quantity.runtimeType}');
    print('customerId type: ${customerId.runtimeType}');
  }

  Future<void> _buyAll() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final items = cartProvider.items.values.toList();

    if (items.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getInt('id'); 

      if (customerId == null) {
        _showSnackBar('Customer ID not found. Please log in again.');
        return;
      }

  
      for (var item in items) {
        await _buyProduct(item.productId, item.quantity, customerId);
      }

      final totalAmount = cartProvider.totalPrice;
      final itemCount = items.length;
      final orderId = _generateOrderId();

      cartProvider.clear();

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OrderConfirmationPage(
            orderId: orderId,
            totalAmount: totalAmount,
            itemCount: itemCount,
          ),
        ),
      );
    } catch (e) {
      if (mounted) _showSnackBar(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _updateQuantity(String cartKey, int newQuantity, int stock) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    if (newQuantity < 1) return;

    if (newQuantity > stock) {
      _showSnackBar('Cannot exceed available stock');
      return;
    }

    cartProvider.updateQuantity(cartKey, newQuantity);
  }

  Widget _buildCartItem(CartItem item, int index) {
    final filename = imagesByName[item.name.trim()] ?? '1.jpg';
    final imagePath = 'assets/images/$filename';

    final cartKey = '${item.productId}_${item.color}_${item.size}';
    final itemTotal = item.price * item.quantity;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.color} / ${item.size}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${itemTotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity Controls
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 180, 180, 180)!,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: () => _updateQuantity(
                            cartKey,
                            item.quantity - 1,
                            item.stock,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () => _updateQuantity(
                            cartKey,
                            item.quantity + 1,
                            item.stock,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            SizedBox(height: 8),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              tooltip: 'Remove item',
              onPressed: () {
                final cartProvider = Provider.of<CartProvider>(
                  context,
                  listen: false,
                );
                cartProvider.removeItem(cartKey);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(double totalPrice, bool hasItems) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),

      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),

                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading || !hasItems ? null : _buyAll,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Buy All',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final cartItems = cartProvider.items.values.toList();
        final totalPrice = cartProvider.totalPrice;
        final hasItems = cartItems.isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Cart'),
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
  TextButton(
    onPressed: () {
      final cartProvider = Provider.of<CartProvider>(
        context,
        listen: false,
      );
      if (cartProvider.items.isEmpty) {
        _showSnackBar('Cart is already empty');
        return;
      }

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Clear Cart'),
          content: Text(
            'Are you sure you want to remove all items from the cart?',
          ),
          actions: [
TextButton(
  onPressed: () => Navigator.of(ctx).pop(),
  child: Text(
    'Cancel',
    style: TextStyle(color: Colors.black),
  ),
),
ElevatedButton(
  onPressed: () {
    cartProvider.clear();
    Navigator.of(ctx).pop();
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.brown,
  ),
  child: Text(
    'Clear All',
    style: TextStyle(color: Colors.white),
  ),
),

          ],
        ),
      );
    },
    child: Text(
      'Clear All',
      style: TextStyle(color: Colors.white), 
    ),
  ),
],

            
          ),
          body: Column(
            children: [
              Expanded(
                child: hasItems
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) =>
                            _buildCartItem(cartItems[index], index),
                      )
                    : _buildEmptyCart(),
              ),
              if (hasItems) _buildCheckoutSection(totalPrice, hasItems),
            ],
          ),
        );
      },
    );
  }
}
