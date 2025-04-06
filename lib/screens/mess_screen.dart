import 'package:flutter/material.dart';

import 'weekly_menu_screen.dart';
import 'special_items_screen.dart';

class MessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mess'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTopButton(context, Icons.calendar_today, "Weekly Menu", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WeeklyMenuScreen()),
                  );
                }),
                SizedBox(width: 50),
                _buildTopButton(context, Icons.star, "Special\nThis Week", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SpecialItemsScreen()),
                  );
                }),
              ],
            ),
            SizedBox(height: 30),
            Text("Today's Menu",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            _buildMenuCard(
              title: "Breakfast",
              titleColor: Colors.lightBlue,
              items: ["Aloo Poori", "Boiled egg / Omlette", "Beverages: Tea, Coffee, Milk"],
            ),
            SizedBox(height: 25),
            _buildMenuCard(
              title: "Lunch",
              titleColor: Colors.orange,
              items: ["Rajma Chawal", "Aloo Gobi", "Roti", "Beverages: Tea, Coffee"],
            ),
            SizedBox(height: 30),
            _buildMenuCard(
              title: "Dinner",
              titleColor: Colors.purple,
              items: ["Dum Aloo", "Dal", "Roti", "Rice", "Beverages: Tea, Coffee"],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopButton(BuildContext context, IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black),
      label: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightGreenAccent,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildMenuCard({required String title, required List<String> items, required Color titleColor}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: titleColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: titleColor)),
          SizedBox(height: 10),
          ...items.map((item) => Row(
            children: [
              Text("• ", style: TextStyle(fontSize: 16)),
              Expanded(child: Text(item, style: TextStyle(fontSize: 16))),
            ],
          )),
        ],
      ),
    );
  }
}
