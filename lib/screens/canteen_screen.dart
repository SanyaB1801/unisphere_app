import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:math';
import 'view_cart_screen.dart';

class CanteenScreen extends StatefulWidget {
  @override
  _CanteenScreenState createState() => _CanteenScreenState();
}

class _CanteenScreenState extends State<CanteenScreen> {
  late Interpreter interpreter;
  List<String> foodItems = [
    'Veg. Burger',
    'Veg. Pizza',
    'Veg. Chowmein',
    'Sandwich',
    'Chicken Biryani',
    'Salad',
    'Fruit Chaat',
    'Dal Chawal',
  ];

  Map<String, Map<String, dynamic>> menuItems = {
    'Veg. Burger': {'price': 30, 'count': 0, 'icon': Icons.fastfood},
    'Veg. Pizza': {'price': 70, 'count': 0, 'icon': Icons.local_pizza},
    'Veg. Chowmein': {'price': 50, 'count': 0, 'icon': Icons.ramen_dining},
    'Sandwich': {'price': 50, 'count': 0, 'icon': Icons.breakfast_dining},
    'Chicken Biryani': {'price': 150, 'count': 0, 'icon': Icons.set_meal},
    'Salad': {'price': 40, 'count': 0, 'icon': Icons.eco},
    'Fruit Chaat': {'price': 35, 'count': 0, 'icon': Icons.local_florist},
    'Dal Chawal': {'price': 45, 'count': 0, 'icon': Icons.rice_bowl},
  };

  List<Map<String, dynamic>> hotItems = [];

  final timeSegments = ['morning', 'afternoon', 'evening', 'night'];

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    interpreter = await Interpreter.fromAsset('demand_model.tflite');
    _predictTopItems();
  }

  String getCurrentTimeSegment() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    if (hour < 21) return 'evening';
    return 'night';
  }

  int encodeTime(String time) => timeSegments.indexOf(time);

  int encodeFood(String food) => foodItems.indexOf(food);

  Future<void> _predictTopItems() async {
    int dayOfWeek = DateTime.now().weekday % 7; // Sunday = 0
    String currentTime = getCurrentTimeSegment();

    List<Map<String, dynamic>> predictions = [];

    for (String food in foodItems) {
      // Input: [day, encoded time, encoded food]
      var input = [
        [dayOfWeek.toDouble(), encodeTime(currentTime).toDouble(), encodeFood(food).toDouble()]
      ];

      var output = List.filled(1, 0.0).reshape([1, 1]);
      interpreter.run(input, output);

      predictions.add({'label': food, 'score': output[0][0]});
    }

    predictions.sort((a, b) => b['score'].compareTo(a['score']));
    setState(() {
      hotItems = predictions.take(6).toList();
    });
  }

  void updateItem(String item, int delta) {
    setState(() {
      menuItems[item]!['count'] += delta;
      if (menuItems[item]!['count'] < 0) menuItems[item]!['count'] = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalItems = menuItems.values.fold(0, (sum, item) => sum + (item['count'] as int));

    return Scaffold(
      appBar: AppBar(
        title: Text('Canteen', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _sectionTitle("Healthy Items", Colors.green.shade800),
            _buildHealthySection(),
            SizedBox(height: 16),
            _sectionTitle("What's Hot Now 🔥", Colors.red.shade700, fontSize: 20),
            _buildHotNowSection(),
            SizedBox(height: 20),
            _sectionTitle("All Dishes", Colors.black),
            Column(
              children: menuItems.keys.map((item) => _buildMenuItem(item)).toList(),
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: totalItems > 0
          ? GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewCartScreen(cartItems: menuItems),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          color: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Added $totalItems item(s) to cart', style: TextStyle(color: Colors.white)),
              Row(
                children: [
                  Text('View Cart', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 8),
                  Icon(Icons.shopping_cart, color: Colors.white),
                ],
              )
            ],
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildHotNowSection() {
    return Container(
      color: Colors.red.shade50,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 130,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: hotItems.length,
          itemBuilder: (context, index) {
            final item = hotItems[index];
            final label = item['label'];
            final icon = menuItems[label]?['icon'] ?? Icons.fastfood;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.redAccent),
                    ),
                    child: Icon(icon, color: Colors.redAccent, size: 36),
                  ),
                  SizedBox(height: 4),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem(String itemName) {
    int price = menuItems[itemName]!['price'];
    int count = menuItems[itemName]!['count'];
    IconData iconData = menuItems[itemName]!['icon'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Icon(iconData, size: 30, color: Colors.deepOrange),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text('$itemName\nRs. $price', style: TextStyle(fontSize: 14)),
          ),
          count == 0
              ? IconButton(
            icon: Icon(Icons.add),
            onPressed: () => updateItem(itemName, 1),
          )
              : Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => updateItem(itemName, -1),
              ),
              Text('$count'),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => updateItem(itemName, 1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthySection() {
    List<Map<String, dynamic>> healthyItems = [
      {'label': 'Salad', 'icon': Icons.eco},
      {'label': 'Fruit Chaat', 'icon': Icons.local_florist},
      {'label': 'Dal Chawal', 'icon': Icons.rice_bowl},
    ];

    return Container(
      color: Colors.green.shade50,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: healthyItems.map((item) {
          return Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green),
                ),
                child: Icon(item['icon'], color: Colors.green, size: 30),
              ),
              SizedBox(height: 4),
              Text(item['label'], style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _sectionTitle(String title, Color color, {double fontSize = 18}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: color,
          ),
        ),
      ),
    );
  }
}