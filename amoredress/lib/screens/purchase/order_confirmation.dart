import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatelessWidget {
  final String orderId;
  final double totalAmount;
  final int itemCount;

  const OrderConfirmationPage({
    Key? key,
    required this.orderId,
    required this.totalAmount,
    required this.itemCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Order Confirmed'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 50),
              ),

              const SizedBox(height: 24),

              const Text(
                'Order Placed Successfully!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              const Text(
                'Thank you for your purchase',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Order Details Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildDetailRow('Order ID', orderId),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Items',
                        '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'Total Amount',
                        '\$${totalAmount.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Continue Shopping Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to home or main page
                    Navigator.pushNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Continue Shopping',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
