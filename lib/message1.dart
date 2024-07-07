import 'package:classico/addProject.dart';
import 'package:classico/dashboard.dart';
import 'package:classico/message1.dart';
import 'package:classico/message2.dart';
import 'package:classico/profile1.dart';
import 'package:classico/search3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'search.dart';

class MessagesScreen extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  MessagesScreen({required this.selectedIndex, required this.onItemTapped});

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  void _onItemTapped(int index) {
    widget.onItemTapped(index); // Call the parent function to handle navigation

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
        // No change for dashboard, already on the home screen
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddProjectPage()),
        );
        // Handle add action here
        break;
      case 3:

        // Handle message action here
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        // Handle profile action here
        break;
      // Handle profile action here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: ListView(
        children: [
          MessageTile(
            name: 'Rajkumar',
            message: 'Nice! Sorry for the spelling...',
            imageUrl:
                'https://via.placeholder.com/150', // Replace with actual image URL
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen()), // Navigate to ChatScreen
              );
            },
          ),
          MessageTile(
            name: 'Niyathi',
            message: 'http://www.werephrase.com',
            imageUrl:
                'https://via.placeholder.com/150', // Replace with actual image URL
            isHighlighted: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen()), // Navigate to ChatScreen
              );
            },
          ),
          MessageTile(
            name: 'Mohan',
            message: 'Hope it will work in the week...',
            imageUrl:
                'https://via.placeholder.com/150', // Replace with actual image URL
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen()), // Navigate to ChatScreen
              );
            },
          ),
          MessageTile(
            name: 'Gayathri',
            message: 'Thank you! It really shine with...',
            imageUrl:
                'https://via.placeholder.com/150', // Replace with actual image URL
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen()), // Navigate to ChatScreen
              );
            },
          ),
          MessageTile(
            name: 'Tarun',
            message: 'Yes I know',
            imageUrl:
                'https://via.placeholder.com/150', // Replace with actual image URL
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen()), // Navigate to ChatScreen
              );
            },
          ),
          MessageTile(
            name: 'Anand',
            message: 'It will be online in 2 days',
            imageUrl:
                'https://via.placeholder.com/150', // Replace with actual image URL
            isHighlighted: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen()), // Navigate to ChatScreen
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '', // Set label to an empty string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '', // Set label to an empty string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '', // Set label to an empty string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: '', // Set label to an empty string
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '', // Set label to an empty string
          ),
        ],
        currentIndex: widget.selectedIndex,
        onTap: _onItemTapped, // Use the local function to handle navigation
        selectedItemColor: Color(0xFF009FFF), // selected item color
        unselectedItemColor: Colors.grey, // unselected item color
        type: BottomNavigationBarType.fixed, // to show all items
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String name;
  final String message;
  final String imageUrl;
  final bool isHighlighted;
  final VoidCallback onTap; // Add onTap callback

  MessageTile({
    required this.name,
    required this.message,
    required this.imageUrl,
    this.isHighlighted = false,
    required this.onTap, // Add onTap to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isHighlighted ? Colors.blue.shade100 : Colors.transparent,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(name),
        subtitle: Text(message),
        onTap: onTap, // Use onTap callback to navigate to ChatScreen
      ),
    );
  }
}
