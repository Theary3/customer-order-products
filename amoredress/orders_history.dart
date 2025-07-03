import 'package:flutter/material.dart';

class OrdersHistory extends StatelessWidget {
  final List<Map<String, dynamic>> orders = [
    {
      'image': 'assets/images/3.jpg',
      'name': 'Leather Coat',
      'price': '45.50',
      'date': 'June 3, 2025',
      'status': 'Delivered'
    },
    {
      'image': 'assets/images/14.jpg',
      'name': 'Classy Men',
      'price': '39.90',
      'date': 'June 5, 2025',
      'status': 'Delivered'
    },
    {
      'image': 'assets/images/4.png',
      'name': 'Denim Jacket for Women',
      'price': '39.90',
      'date': 'June 10, 2025',
      'status': 'Pending'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        backgroundColor: Colors.brown[200],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  order['image'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(order['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${order['date']}'),
                  Text(
                    'Status: ${order['status']}',
                    style: TextStyle(
                      color: order['status'] == 'Delivered'
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
              trailing: Text('\$${order['price']}'),
            ),
          );
        },
      ),
    );
  }
}
