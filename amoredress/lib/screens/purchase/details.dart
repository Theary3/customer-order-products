import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import '../image/products_image.dart';

class ProductDetailPage extends StatefulWidget {
  final String productName;

  const ProductDetailPage({Key? key, required this.productName})
    : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Map<String, dynamic> product = {};
  List<dynamic> variants = [];
  String? selectedColor, selectedSize;
  int quantity = 1, availableStock = 0;
  bool isLoading = true, isInWishlist = false;
  String? errorMessage;

  List<String> get productImages {
    if (product['images'] != null && product['images'] is List) {
      return List<String>.from(
        (product['images'] as List).map((e) => e.toString()),
      );
    }
    final imageEntry = productImagesByName[widget.productName];
    if (imageEntry is List<String>) {
      return imageEntry;
    } else if (imageEntry is String) {
      return [?imageEntry];
    }
    return ['1.jpg'];
  }

  late PageController _pageController;
  int _currentImageIndex = 0;
  Timer? _autoScrollTimer;
  List<String> sizeOrder = ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

  static const colors = {
    'red': Colors.red,
    'pink': Colors.pink,
    'blue': Colors.blue,
    'green': Colors.green,
    'black': Colors.black,
    'yellow': Colors.yellow,
    'brown': Color.fromARGB(255, 188, 103, 42),
    'beige': Color(0xFFF5F5DC),
    'white': Color.fromARGB(255, 234, 234, 234),
    'grey': Color.fromARGB(255, 244, 244, 244),
    'gray': Color.fromARGB(255, 139, 139, 139),
    'cream': Color.fromARGB(255, 253, 235, 198),
    'purple': Color.fromARGB(255, 213, 46, 255),
    'navy': Color.fromARGB(255, 55, 73, 119),
  };

  @override
  void initState() {
    super.initState();
    loadData();
    _pageController = PageController();
    _autoScrollTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && productImages.length > 1) {
        _currentImageIndex = (_currentImageIndex + 1) % productImages.length;
        _pageController.animateToPage(
          _currentImageIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  loadData() async {
    try {
      setState(() => isLoading = true);
      final encodedName = Uri.encodeComponent(widget.productName);
      final res = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/product_by_name/$encodedName'),
      );
      if (res.statusCode != 200) throw Exception('Failed to load');
      product = jsonDecode(res.body);
      if (product['name'] != null) {
        final varRes = await http.get(
          Uri.parse(
            'http://10.0.2.2:8000/api/product_variants?name=${product['name']}',
          ),
        );
        if (varRes.statusCode == 200) variants = jsonDecode(varRes.body);
      }
      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load product';
        isLoading = false;
      });
    }
  }

  updateStock() {
    final variant = (selectedColor != null && selectedSize != null)
        ? variants.firstWhere(
            (v) => v['color'] == selectedColor && v['size'] == selectedSize,
            orElse: () => null,
          )
        : null;
  setState(() {
    availableStock = variant != null ? variant['stock'] ?? 0 : 0;

    if (availableStock > 0) {
      if (quantity < 1) {
        quantity = 1; // Always at least 1 when stock available
      } else if (quantity > availableStock) {
        quantity = availableStock; // max available stock
      }
    } else {
      quantity = 0; // out of stock => quantity 0
    }

    });
  }

  toggleWishlist() {
    setState(() => isInWishlist = !isInWishlist);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isInWishlist ? 'Added to wishlist' : 'Removed from wishlist',
        ),
        backgroundColor: isInWishlist ? Colors.pink : Colors.grey,
      ),
    );
  }

  addToCart() {
    if (availableStock == 0) return;
    final variant = variants.firstWhere(
      (v) => v['color'] == selectedColor && v['size'] == selectedSize,
    );
    final imageName = productImagesByName[product['name']] ?? 'default.jpg';
    Provider.of<CartProvider>(context, listen: false).addItem(
      variant['product_id'],
      variant['name'],
      double.tryParse(variant['price'].toString()) ?? 0.0,
      'assets/images/$imageName',
      variant['stock'],
      quantity,
      variant['color'],
      variant['size'],
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $quantity item(s) to cart'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return Scaffold(
        appBar: AppBar(title: Text('Loading...')),
        body: Center(child: CircularProgressIndicator()),
      );
    if (errorMessage != null)
      return Scaffold(
        appBar: AppBar(title: Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage!),
              ElevatedButton(onPressed: loadData, child: Text('Retry')),
            ],
          ),
        ),
      );
    List<T> uniqueInOrder<T>(List<T> list) {
      final seen = <T>{};
      return list.where((element) => seen.add(element)).toList();
    }

    final uniqueColors = uniqueInOrder(
      variants.map((v) => v['color'] as String).toList(),
    );
    final rawSizes = variants.map((v) => v['size'] as String).toList();
    final uniqueSizes = uniqueInOrder(rawSizes)
      ..sort((a, b) {
        final indexA = sizeOrder.indexOf(a.toUpperCase());
        final indexB = sizeOrder.indexOf(b.toUpperCase());
    
        if (indexA == -1 && indexB == -1) return a.compareTo(b);
        if (indexA == -1) return 1;
        if (indexB == -1) return -1;
        return indexA.compareTo(indexB);
      });

    final canAddToCart =
        availableStock > 0 && selectedColor != null && selectedSize != null;
    final price = double.tryParse(product['price']?.toString() ?? '0') ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'] ?? 'Product Details'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              isInWishlist ? Icons.favorite : Icons.favorite_border,
              color: isInWishlist ? Colors.pink : Colors.white,
              size: 28,
            ),
            onPressed: toggleWishlist,
          ),
        ],
      ),
      body: SingleChildScrollView(
 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 250,
              color: const Color.fromARGB(210, 0, 0, 0),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: productImages.length,
                      onPageChanged: (index) =>
                          setState(() => _currentImageIndex = index),
                      itemBuilder: (context, index) {
                        return Image.asset(
                          'assets/images/${productImages[index]}',
                      
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.broken_image, size: 60),
                          ),
                        );
                      },
                    ),

                    Positioned(
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          productImages.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == index
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

       
            Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
              
           
            SizedBox(height: 16),
            Text(
              product['description'] ?? 'No description available',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 24),
            Text(
              'Select Color',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: uniqueColors
                  .map(
                    (color) => GestureDetector(
                      onTap: () {
                        setState(() => selectedColor = color);
                        updateStock();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: colors[color.toLowerCase()] ?? Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color == selectedColor
                                ? Colors.brown
                                : Colors.grey,
                            width: color == selectedColor ? 3 : 1,
                          ),
                        ),
                        child: color == selectedColor
                            ? Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 24),
            Text(
              'Select Size',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: uniqueSizes
                  .map(
                    (size) => GestureDetector(
                      onTap: () {
                        setState(() => selectedSize = size);
                        updateStock();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: size == selectedSize
                              ? Colors.brown
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: size == selectedSize
                                ? Colors.brown
                                : Colors.grey,
                          ),
                        ),
                        child: Text(
                          size,
                          style: TextStyle(
                            color: size == selectedSize
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),

            SizedBox(height: 20),
            if (selectedColor != null && selectedSize != null)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: availableStock > 0 ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: availableStock > 0 ? Colors.green : Colors.red,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      availableStock > 0 ? Icons.check_circle : Icons.error,
                      color: availableStock > 0 ? Colors.green : Colors.red,
                    ),
                    SizedBox(width: 8),
                    Text(
                      availableStock > 0
                          ? '$availableStock items available'
                          : 'Out of stock',
                      style: TextStyle(
                        color: availableStock > 0
                            ? Colors.green[700]
                            : Colors.red[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16),
            if (availableStock > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quantity:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: quantity > 1
                            ? () => setState(() => quantity--)
                            : null,
                      ),
                      Text(
                        '$quantity',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: quantity < availableStock
                            ? () => setState(() => quantity++)
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: canAddToCart ? addToCart : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAddToCart ? Colors.brown : Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  canAddToCart ? 'Add to Cart' : 'Select Options',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
              ],
              ),
          ),
          ],
        ),
      ),
    );
  }
}
