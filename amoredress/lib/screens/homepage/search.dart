import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<Product> allProducts = [
    Product(
      image: 'assets/images/1.jpg',
      name: 'Autumn Dress',
      price: 29.99,
      category: ProductCategory.women,
    ),
    Product(
      image: 'assets/images/2.jpg',
      name: 'Sweater Collection',
      price: 15.00,
      category: ProductCategory.women,
    ),
    Product(
      image: 'assets/images/3.jpg',
      name: 'Leather Coat',
      price: 45.50,
      category: ProductCategory.men,
    ),
    Product(
      image: 'assets/images/14.jpg',
      name: 'Classy Men Outfit',
      price: 39.90,
      category: ProductCategory.men,
    ),
    Product(
      image: 'assets/images/4.jpg',
      name: 'Denim Jacket for Women',
      price: 39.90,
      category: ProductCategory.women,
    ),
    Product(
      image: 'assets/images/14.jpg',
      name: 'Men Sweatshirt',
      price: 39.90,
      category: ProductCategory.men,
    ),
    Product(
      image: 'assets/images/5.jpg',
      name: 'Kids Summer Tee',
      price: 12.99,
      category: ProductCategory.kids,
    ),
    Product(
      image: 'assets/images/6.jpg',
      name: 'Premium Blazer',
      price: 89.99,
      category: ProductCategory.men,
    ),
  ];

  List<Product> _displayedProducts = [];
  String _searchQuery = '';
  FilterOption _selectedFilter = FilterOption.all;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _displayedProducts = List.from(allProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    setState(() {
      _displayedProducts = allProducts.where((product) {
        final matchesSearch = product.name.toLowerCase().contains(
          _searchQuery.toLowerCase(),
        );
        final matchesFilter = _doesProductMatchFilter(product);

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  bool _doesProductMatchFilter(Product product) {
    switch (_selectedFilter) {
      case FilterOption.all:
        return true;
      case FilterOption.men:
        return product.category == ProductCategory.men;
      case FilterOption.women:
        return product.category == ProductCategory.women;
      case FilterOption.kids:
        return product.category == ProductCategory.kids;
      case FilterOption.under20:
        return product.price < 20;
      case FilterOption.between20And40:
        return product.price >= 20 && product.price <= 40;
      case FilterOption.above40:
        return product.price > 40;
    }
  }

  void _onSearchChanged(String value) {
    _searchQuery = value;
    _filterProducts();
  }

  void _onFilterSelected(FilterOption filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _filterProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Products',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),

        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(child: _buildProductGrid()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          PopupMenuButton<FilterOption>(
            icon: const Icon(Icons.filter_list),
            onSelected: _onFilterSelected,
            itemBuilder: (context) => FilterOption.values
                .map(
                  (filter) => PopupMenuItem(
                    value: filter,
                    child: Text(filter.displayName),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    if (_displayedProducts.isEmpty) {
      return const Center(
        child: Text(
          'No products found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _displayedProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        return ProductCard(product: _displayedProducts[index]);
      },
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    return 2;
  }
}

class Product {
  final String image;
  final String name;
  final double price;
  final ProductCategory category;

  const Product({
    required this.image,
    required this.name,
    required this.price,
    required this.category,
  });
}

enum ProductCategory { men, women, kids }

enum FilterOption {
  all,
  men,
  women,
  kids,
  under20,
  between20And40,
  above40;

  String get displayName {
    switch (this) {
      case FilterOption.all:
        return 'All';
      case FilterOption.men:
        return 'Men';
      case FilterOption.women:
        return 'Women';
      case FilterOption.kids:
        return 'Kids';
      case FilterOption.under20:
        return 'Under \$20';
      case FilterOption.between20And40:
        return '\$20 - \$40';
      case FilterOption.above40:
        return 'Above \$40';
    }
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                product.image,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
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
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
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
