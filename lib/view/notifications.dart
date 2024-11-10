import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Center( // Center the entire body
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
            children: [
              Text('Notifications', style: TextStyle(fontSize: 24)),
              SizedBox(height: 20),
              Expanded( // Allows for a list to take the available space
                child: ListView(
                  children: [
                    ListTile(
                      title: Text('Staking period ending in 5 days'),
                      trailing: Switch(
                        value: true,
                        onChanged: (bool value) {},
                      ),
                    ),
                    ListTile(
                      title: Text('New staking option available'),
                      trailing: Switch(
                        value: false,
                        onChanged: (bool value) {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
