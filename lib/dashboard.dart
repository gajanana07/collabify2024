import 'package:classico/addProject.dart';
import 'package:classico/message1.dart';
import 'package:classico/profile1.dart';
import 'package:flutter/material.dart';
import 'package:classico/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _appliedProjects = [];
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _fetchAppliedProjectsFromFirestore();
    _fetchUserNameFromFirestore();
  }

  void _fetchAppliedProjectsFromFirestore() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('Fetching applied projects for user: ${user.email}');
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('applied_projects')
            .where('email', isEqualTo: user.email)
            .get();

        final List<Map<String, dynamic>> projects = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          print('Fetched project: $data');
          return {
            'project_name': data['project_name'] ?? 'No title',
            'description': data['project_description'] ?? 'No description',
            'tags': data['project_tags'] ?? 'No tags',
            'timestamp': (data['project_timestamp'] as Timestamp?)
                    ?.toDate()
                    .toString() ??
                'No date',
            'email': data['email'] ?? 'No email',
          };
        }).toList();

        setState(() {
          _appliedProjects = projects;
        });
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error fetching applied projects from Firestore: $e');
      // Handle error appropriately here
    }
  }

  void _fetchUserNameFromFirestore() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('Fetching user name for user: ${user.uid}');
        final DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        final data = snapshot.data() as Map<String, dynamic>;
        print('Fetched user data: $data');
        setState(() {
          _userName = data['firstName'] ?? 'Unknown';
        });
      } else {
        print('User not logged in');
      }
    } catch (e) {
      print('Error fetching user name from Firestore: $e');
      // Handle error appropriately here
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        // No change for dashboard, already on the Dashboard screen
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddProjectPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MessagesScreen(
                    selectedIndex: _selectedIndex,
                    onItemTapped: _onItemTapped,
                  )),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  void _onProjectTapped(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProjectDetailsScreen(project: _appliedProjects[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $_userName!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Applied Projects',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _appliedProjects.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _onProjectTapped(index);
                    },
                    child: ProjectCard(project: _appliedProjects[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF009FFF),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;

  ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(project['project_name']),
        subtitle: Text(project['description']),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(project['tags']),
            Text(project['timestamp']),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> project;

  ProjectDetailsScreen({required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project['project_name'] ?? 'No title'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(project['description'] ?? 'No description'),
            SizedBox(height: 16.0),
            Text(
              'Skills Required',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(project['tags'] ?? 'No tags'),
            SizedBox(height: 16.0),
            Text(
              'Posted On',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(project['timestamp'] ?? 'No date'),
          ],
        ),
      ),
    );
  }
}
