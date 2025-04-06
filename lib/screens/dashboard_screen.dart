import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final String email;

  DashboardScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Center(
        child: Text(
          'Welcome, $email!',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
