import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'userprofile.dart';
import 'signup.dart';
import 'emergency_contacts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MenuBarScreen(),
    );
  }
}

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
  User? currentUser;
  late Future<DocumentSnapshot> userSnapshot;

  @override
  void initState() {
    super.initState();
    currentUser = widget.auth.currentUser;
    userSnapshot = getUserInfo(currentUser?.uid);
  }

  Future<DocumentSnapshot> getUserInfo(String? userId) async {
    if (userId != null) {
      return FirebaseFirestore.instance.collection('users').doc(userId).get();
    }
    throw Exception("User ID is null");
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<DocumentSnapshot>(
        future: userSnapshot,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error loading user data');
          } else {
            var displayName = snapshot.data?['displayName'] ?? 'User Name';
            return Column(
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
                          displayName,
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
                    if (currentUser?.uid != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return ProfileScreen(userId: currentUser!.uid);
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
            );
          }
        },
      ),
    );
  }
}
