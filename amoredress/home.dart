import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'icon': FontAwesomeIcons.fire, 'label': 'Trending'},
    {'icon': FontAwesomeIcons.shirt, 'label': 'T-shirt'},
    {'icon': FontAwesomeIcons.userTie, 'label': 'Suit'},
    {'icon': FontAwesomeIcons.shoePrints, 'label': 'Shoes'},
    {'icon': FontAwesomeIcons.mars, 'label': 'Men'},
    {'icon': FontAwesomeIcons.venus, 'label': 'Women'},
    {'icon': FontAwesomeIcons.child, 'label': 'Kids'},
    {'icon': FontAwesomeIcons.glasses, 'label': 'Accessories'},
  ];

  final List<Map<String, dynamic>> products = [
    {'image': 'assets/images/1.jpg', 'name': 'Autumn dress', 'price': '29.99'},
    {
      'image': 'assets/images/2.jpg',
      'name': 'Sweater Collection',
      'price': '15.00',
    },
    {'image': 'assets/images/3.jpg', 'name': 'Leather Coat', 'price': '45.50'},
    {'image': 'assets/images/14.jpg', 'name': 'Classy Men', 'price': '39.90'},
    {
      'image': 'assets/images/4.png',
      'name': 'Denim Jacket for Women',
      'price': '39.90',
    },
    {
      'image': 'assets/images/14.jpg',
      'name': 'Men Sweat-shirt',
      'price': '39.90',
    },
    {
      'image': 'assets/images/4.png',
      'name': 'Denim Jacket for Women',
      'price': '39.90',
    },
    {
      'image': 'assets/images/4.png',
      'name': 'Denim Jacket for Women',
      'price': '39.90',
    },
    {
      'image': 'assets/images/4.png',
      'name': 'Denim Jacket for Women',
      'price': '39.90',
    },
    {
      'image': 'assets/images/4.png',
      'name': 'Denim Jacket for Women',
      'price': '39.90',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.location_on, size: 20),
            SizedBox(width: 4),
            Text(
              '123str, Phnom Penh Cambodia',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(	FontAwesomeIcons.magnifyingGlass,size: 20),
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.bagShopping,size: 20),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Poster
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              'assets/images/3.jpg',
              fit: BoxFit.cover,
              width: 400,
              height: 200,
            ),
          ),
          SizedBox(height: 16),

          // Categories// Categories Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 110, 66, 34),
              ),
            ),
          ),
          SizedBox(height: 12),
          // Categories (2-line horizontal layout)
          Padding(
            padding: const EdgeInsets.all(16),

            child: SizedBox(
              height: 130,
              child: Wrap(
                spacing: 25,
                runSpacing: 10,
                children: categories.map((category) {
                  return SizedBox(
                    width: 65, // fix item width to control wrapping
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color.fromARGB(
                            255,
                            239,
                            234,
                            233,
                          ),
                          child: Center(
                            // Center ensures perfect centering
                            child: Icon(
                              category['icon'],
                              size:
                                  24, // make this equal or slightly less than radius
                              color: const Color.fromARGB(255, 130, 74, 34),
                            ),
                          ),
                        ),

                        const SizedBox(height: 4),
                        Text(
                          category['label'],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(height: 16),
          // Categories// Categories Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Autumn Collection',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 110, 66, 34),
              ),
            ),
          ),
          SizedBox(height: 12),
          // Products Grid
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            physics: NeverScrollableScrollPhysics(),
            childAspectRatio: 0.75,
            children: List.generate(products.length, (index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/product${index + 1}');
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.asset(
                            product['image'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Text(
                          product['name'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '\$${product['price']}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.pinkAccent.shade400,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/favorites');
          } 
          else if (index == 2) {
            Navigator.pushNamed(context, '/history');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/aboutus');
          }else if (index == 4) {
            Navigator.pushNamed(context, '/profile');
          }
          
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'About Us'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
