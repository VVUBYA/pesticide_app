import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'login.dart';
import 'userprofile.dart';
import 'signup.dart';

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

  @override
  void initState() {
    super.initState();
    // Get the current user's ID when the menu bar is created
    if (widget.auth.currentUser != null) {
      userId = widget.auth.currentUser!.uid;
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
                    "User Name",
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
        ],
      ),
    );
  }
}
