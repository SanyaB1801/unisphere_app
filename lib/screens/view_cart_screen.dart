// view_cart_screen.dart
import 'package:flutter/material.dart';

class ViewCartScreen extends StatelessWidget {
  final Map<String, Map<String, dynamic>> cartItems;

  ViewCartScreen({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    int totalAmount = 0;
    cartItems.forEach((key, value) {
      totalAmount += ((value['count'] ?? 0) as int) * ((value['price'] ?? 0) as int);

    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: cartItems.entries
                  .where((entry) => entry.value['count'] > 0)
                  .map((entry) {
                String itemName = entry.key;
                int count = entry.value['count'];
                int price = entry.value['price'];
                return ListTile(
                  title: Text(itemName),
                  subtitle: Text('Quantity: $count'),
                  trailing: Text('Rs. ${count * price}'),
                );
              }).toList(),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Rs. $totalAmount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Booking Successful'),
                    content: Text('Your order has been booked!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('OK'),
                      )
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment),
                  SizedBox(width: 8),
                  Text('Book My Order'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

