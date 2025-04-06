import 'package:flutter/material.dart';
import 'login_page.dart';
import 'help_desk.dart';
import 'event_screen.dart';
import 'canteen_screen.dart';
import 'mess_screen.dart';
import 'scholoarship_screen.dart';
import 'lost_found_screen.dart';

class HomePage extends StatelessWidget {
  final String? userName;
  HomePage({this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage())),
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Help Desk'),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HelpDeskScreen())),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.blueAccent),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Hello ${userName ?? 'User'}",
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              ),
              child: Icon(Icons.account_circle, color: Colors.blueAccent, size: 30),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.greenAccent.shade100, Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "Unisphere",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 1,
                childAspectRatio: 2.0,
                mainAxisSpacing: 15,
                children: [
                  _buildCanteenMessPopup(context),
                  _buildFeatureButton(context, Icons.school, "Scholarships", Colors.purple),
                  _buildFeatureButton(context, Icons.map, "Lost & Found", Colors.pink),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventsScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event, color: Colors.blueAccent, size: 20),
                    SizedBox(width: 5),
                    Text("See what’s happening!!", style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context, IconData icon, String title, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              if (title == "Scholarships") return ScholarshipScreen();
              else if (title == "Lost & Found") return LostAndFoundPage();
              else return Scaffold(body: Center(child: Text("Screen not found")));
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: color.withOpacity(0.3),
              child: Icon(icon, size: 50, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildCanteenMessPopup(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Select Option"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => CanteenScreen()));
                  },
                  icon: Icon(Icons.fastfood),
                  label: Text("Canteen"),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => MessScreen()));
                  },
                  icon: Icon(Icons.restaurant_menu),
                  label: Text("Mess"),
                ),
              ],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.withOpacity(0.3),
              child: Icon(Icons.restaurant, size: 50, color: Colors.white),
            ),
            SizedBox(height: 12),
            Text("Canteen & Mess", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
