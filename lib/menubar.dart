import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; //
import 'login.dart';
import 'userprofile.dart';
import 'signup.dart';
import 'emergency_contacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuBarScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Bar'),
      ),
      body: CustomMenuBar(auth: _auth),
    );
  }
}

class CustomMenuBar extends StatefulWidget {
  final FirebaseAuth auth;

  CustomMenuBar({required this.auth});

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<CustomMenuBar> {
  String? userId; // Define userId variable
  String? displayName; // Define displayName variable

  @override
  void initState() {
    super.initState();
    // Get the current user's ID when the menu bar is created
    if (widget.auth.currentUser != null) {
      userId = widget.auth.currentUser!.uid;
      _fetchDisplayName();
    }
  }

  Future<void> _fetchDisplayName() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userSnapshot.exists) {
        displayName = userSnapshot['name'];
        setState(() {});
      }
    } catch (error) {
      print('Error fetching user name: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            color: Colors.blue,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    // Display user profile image here
                  ),
                  SizedBox(height: 10),
                  Text(
                    displayName ??
                        "User Name", // Display the displayName or "User Name" if null
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {
              if (userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ProfileScreen(userId: userId!);
                    },
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () async {
              await widget.auth.signOut();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text("Notifications"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text("Emergency Contacts"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext content) {
                    return EmergencyContactsScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
