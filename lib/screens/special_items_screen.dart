import 'package:flutter/material.dart';

class SpecialItemsScreen extends StatelessWidget {
  final List<String> specialItems = [
    "Paneer Tikka",
    "Butter Chicken",
    "Kaju Curry",
    "Shahi Paneer",
    "Gajar Halwa",
    "Rasmalai",
    "Biryani",
    "Kheer",
    "Tandoori Roti"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Special This Week")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: specialItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.star, color: Colors.orange),
              title: Text(specialItems[index]),
            );
          },
        ),
      ),
    );
  }
}
