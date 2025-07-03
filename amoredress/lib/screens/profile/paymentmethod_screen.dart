import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Payment Methods'),
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'Credit & Debit Card',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.credit_card, size: 24, color: Color(0xff997054)),
                SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  child:  Text('Add New Card',
                  ),
                ),
                 SizedBox(width: 50),
                TextButton(
                  onPressed: () {
                    
                  },
                  child:  Text('Link'),
                ),
              ],
            ),
             SizedBox(height: 32),
             Text(
              'More Payment Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 16),
            ListTile(
              leading: Image.asset(
                'assets/images/aba.jpg', 
                width: 30,
                height: 30,
              ),
              title:  Text('ABA'),
              trailing: TextButton(
                onPressed: () {
                  //ABA link
                },
                child:  Text('Link'),
              ),
            ),
            
             Divider(),
             ListTile(
              leading: Image.asset(
                'assets/images/paypal.png', 
                width: 30,
                height: 30,
              ),
              title: const Text('PayPal'),
              trailing: TextButton(
                onPressed: () {
                  //  PayPal link
                },
                child:Text('Link'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}