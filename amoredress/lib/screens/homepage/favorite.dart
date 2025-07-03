import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Men', 'Women', 'Kids', 'Accessories'];
  
  List<FavoriteItem> favorites = [
    FavoriteItem(
      id: 1,
      name: 'Autumn Dress',
      price: 12.50,
      category: 'Women',
      image: 'assets/images/1.jpg',
      inStock: true,
    ),
    FavoriteItem(
      id: 2,
      name: 'Leather Jacket',
      price: 45.99,
      category: 'Men',
      image: 'assets/images/4.jpg',
      inStock: false,
    ),
    FavoriteItem(
      id: 3,
      name: 'Kids Sweater',
      price: 18.50,
      category: 'Kids',
      image: 'assets/images/15.jpg',
      inStock: true,
    ),
    FavoriteItem(
      id: 4,
      name: 'Men Sweatshirt',
      price: 39.90,
      category: 'Men',
      image: 'assets/images/14.jpg',
      inStock: true,
    ),
  ];

  List<FavoriteItem> get filteredItems {
    if (selectedFilter == 'All') return favorites;
    return favorites.where((item) => item.category == selectedFilter).toList();
  }

  void removeFavorite(int id) {
    setState(() {
      favorites.removeWhere((item) => item.id == id);
    });
    _showSnackBar('Removed from favorites');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Favorites',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final isSelected = selectedFilter == filters[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      filters[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF6E4222),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = filters[index];
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFF6E4222),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFF6E4222) : Colors.grey.shade300,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),

          // Items count
          if (filteredItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '${filteredItems.length} item${filteredItems.length != 1 ? 's' : ''}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Favorites list
          Expanded(
            child: filteredItems.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return FavoriteItemCard(
                        item: filteredItems[index],
                        onRemove: () => removeFavorite(filteredItems[index].id),
                        onAddToCart: () => _showSnackBar('Added to cart'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding items to your wishlist',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6E4222),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Browse Products'),
          ),
        ],
      ),
    );
  }
}

class FavoriteItem {
  final int id;
  final String name;
  final double price;
  final String category;
  final String image;
  final bool inStock;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
    required this.inStock,
  });
}

class FavoriteItemCard extends StatelessWidget {
  final FavoriteItem item;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const FavoriteItemCard({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: Image.asset(
                  item.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[400],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.inStock ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.inStock ? 'In Stock' : 'Out of Stock',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: item.inStock ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action buttons
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
                  onPressed: onRemove,
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    minimumSize: const Size(32, 32),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 80,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: item.inStock ? onAddToCart : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6E4222),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: item.inStock ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}