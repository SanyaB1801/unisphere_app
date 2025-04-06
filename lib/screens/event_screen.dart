import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Campus Events")),
      body: Center(
        child: Text("See What’s Happening!", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
