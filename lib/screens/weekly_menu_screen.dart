import 'package:flutter/material.dart';

class WeeklyMenuScreen extends StatelessWidget {
  final Map<String, List<String>> weeklyMenu = {
    "Monday": ["Poha", "Rajma Rice", "Paneer Butter Masala"],
    "Tuesday": ["Upma", "Chole Bhature", "Aloo Matar"],
    "Wednesday": ["Idli Sambar", "Fried Rice", "Mix Veg"],
    "Thursday": ["Aloo Paratha", "Dal Makhani", "Chana Masala"],
    "Friday": ["Bread Butter", "Pulao", "Kadhi Pakora"],
    "Saturday": ["Cornflakes", "Veg Biryani", "Palak Paneer"],
    "Sunday": ["Boiled Egg", "Chicken Curry", "Gulab Jamun"]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weekly Menu")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: weeklyMenu.length,
        itemBuilder: (context, index) {
          String day = weeklyMenu.keys.elementAt(index);
          List<String> items = weeklyMenu[day]!;
          return Card(
            margin: EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(day, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items.map((e) => Text("• $e")).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
