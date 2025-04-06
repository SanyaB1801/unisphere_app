import 'package:flutter/material.dart';

class HelpDeskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Help Desk")),
      body: Center(
        child: Text("How can we assist you?", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
