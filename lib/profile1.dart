import 'package:classico/addProject.dart';
import 'package:classico/dashboard.dart';
import 'package:classico/login.dart';
import 'package:classico/message1.dart';
import 'package:classico/profile1.dart';
import 'package:classico/profile2.dart';
import 'package:classico/search.dart';
import 'package:classico/search3.dart';
import 'package:classico/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'user_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  User? _user;
  Future<Map<String, dynamic>>? _userDataFuture;
  int _selectedIndex = 0;
  String _selectedOption = 'Applied Projects';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _userDataFuture = _userService.getUser(_user!.uid);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
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
        // Handle profile action here
        break;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you wanna log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProjectDetails() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(_selectedOption == 'Applied Projects'
              ? 'applied_projects'
              : 'projects')
          .where('email', isEqualTo: _user?.email)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var documents = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: documents.length,
          itemBuilder: (context, index) {
            var data = documents[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['project_name'] ?? 'No Project Name'),
              subtitle: Text(data['description'] ?? 'No Description'),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: _userDataFuture != null
          ? FutureBuilder<Map<String, dynamic>>(
              future: _userDataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> userData = snapshot.data!;
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              if (userData['profilePicture'] != null &&
                                  userData['profilePicture'].isNotEmpty)
                                CachedNetworkImage(
                                  imageUrl: userData['profilePicture'],
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )
                              else
                                Icon(Icons.account_circle,
                                    size: 100), // Default icon if no image
                              SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    userData['firstName'] ?? 'No Name',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(userData['email'] ?? 'No Email'),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            userData['description'] ?? 'No Description',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 20),
                          DropdownButton<String>(
                            value: _selectedOption,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedOption = newValue!;
                              });
                            },
                            items: <String>[
                              'Applied Projects',
                              'Uploaded Projects'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          _buildProjectDetails(),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Center(child: Text('No data available'));
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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

class UserService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getUser(String uid) async {
    DocumentSnapshot userData =
        await _firestore.collection('users').doc(uid).get();
    if (userData.exists) {
      Map<String, dynamic> userDataMap =
          userData.data() as Map<String, dynamic>;
      String? profilePicture = userDataMap['profilePicture'];
      if (profilePicture != null && profilePicture.isNotEmpty) {
        try {
          String downloadUrl = await _storage
              .ref('user_images/$profilePicture')
              .getDownloadURL();
          userDataMap['profilePicture'] = downloadUrl;
        } catch (e) {
          // Handle errors like object not found
          print("Error fetching image URL: $e");
          userDataMap['profilePicture'] =
              ''; // Set to an empty string or a default value
        }
      } else {
        userDataMap['profilePicture'] =
            ''; // Default value if profilePicture is null or empty
      }
      return userDataMap;
    } else {
      return {};
    }
  }
}
