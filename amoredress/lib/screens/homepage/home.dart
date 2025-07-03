import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../image/products_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  Set<int> _favorites = <int>{};
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    fetchProductGroups();
  }
Widget _buildProductCard(Map<String, dynamic> product, int index) {

  String imageAsset = 'assets/images/default.jpg';

  if (product['name'] != null && imageMap.containsKey(product['name'])) {
    imageAsset = imageMap[product['name']]!;
  }

  bool isFavorite = _favorites.contains(index);

  return GestureDetector(
    onTap: () => _navigateToProductDetail(product['name']),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
             
                  child: Image.asset(
                    imageAsset,
  
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '\$${product['max_price'].toString()}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[400],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Future<void> fetchProductGroups() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/products/groups');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        setState(() {
          _products = jsonList.map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item)).toList();
          _isLoading = false;
          _error = null;
        });
      } else {
        setState(() {
          _error = 'Failed to load products (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching products: $e';
        _isLoading = false;
      });
    }
  }

  void _toggleFavorite(int index) {
    setState(() {
      if (_favorites.contains(index)) {
        _favorites.remove(index);
      } else {
        _favorites.add(index);
      }
    });
  }

  void _navigateTo(String route) {
    Navigator.pushNamed(context, route);
  }

  void _navigateToProductDetail(String productName) {
    final encodedName = Uri.encodeComponent(productName);
    Navigator.pushNamed(context, '/product/$encodedName');
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        break;
      case 1:
        _navigateTo('/favorites');
        break;
      case 2:
        _navigateTo('/profile');
        break;
      case 3:
        _navigateTo('/addproduct');
        break;
    }
  }

  int _getCrossAxisCount() {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    return 2;
  }

  final List<Map<String, dynamic>> _categories = [
    {'icon': FontAwesomeIcons.fire, 'label': 'Trending'},
    {'icon': FontAwesomeIcons.shirt, 'label': 'T-shirt'},
    {'icon': FontAwesomeIcons.userTie, 'label': 'Suit'},
    {'icon': FontAwesomeIcons.shoePrints, 'label': 'Shoes'},
    {'icon': FontAwesomeIcons.mars, 'label': 'Men'},
    {'icon': FontAwesomeIcons.venus, 'label': 'Women'},
    {'icon': FontAwesomeIcons.child, 'label': 'Kids'},
    {'icon': FontAwesomeIcons.glasses, 'label': 'Accessories'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Icon(Icons.location_on, size: 18, color: Theme.of(context).primaryColor),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              '123 Street, Phnom Penh, Cambodia',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _buildAppBarAction(FontAwesomeIcons.magnifyingGlass, () => _navigateTo('/search')),
          const SizedBox(width: 8),
          _buildAppBarAction(FontAwesomeIcons.bagShopping, () => _navigateTo('/cart')),
        ],
      ),
    );
  }

  Widget _buildAppBarAction(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(icon: FaIcon(icon, size: 18), onPressed: onPressed, color: Colors.black87),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AutoSwappingBanner(images: [
            'assets/images/3.jpg',
            'assets/images/banner1.jpg',
            'assets/images/banner2.jpg',
          ]),
          const SizedBox(height: 24),
          _buildCategoriesSection(),
          const SizedBox(height: 24),
          _buildProductsSection(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Categories'),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) => _buildCategoryItem(_categories[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 241, 237, 227),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Center(
              child: FaIcon(
                category['icon'],
                size: 24,
                color: const Color.fromARGB(255, 78, 51, 42),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category['label'],
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Autumn Collection'),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: _products.length,
            itemBuilder: (context, index) => _buildProductCard(_products[index], index),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6E4222)),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: _onBottomNavTap,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF6E4222),
      unselectedItemColor: Colors.grey[600],
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}

class _AutoSwappingBanner extends StatefulWidget {
  final List<String> images;
  const _AutoSwappingBanner({required this.images});

  @override
  State<_AutoSwappingBanner> createState() => _AutoSwappingBannerState();
}

class _AutoSwappingBannerState extends State<_AutoSwappingBanner> {
  late PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller.hasClients) {
        _currentPage = (_currentPage + 1) % widget.images.length;
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: widget.images.length,
              itemBuilder: (context, index) => Image.asset(
                widget.images[index],
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
                ),
              ),
            ),
            const Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('New Collection', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Discover the latest trends', style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
