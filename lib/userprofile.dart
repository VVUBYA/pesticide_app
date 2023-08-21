import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginScreen();
          }
          return ProfileScreen(userId: user.uid);
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String userId;

  ProfileScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: UserProfileDisplay(userId: userId),
    );
  }
}

class UserProfileDisplay extends StatelessWidget {
  final String userId;

  UserProfileDisplay({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading user data'));
        }

        var userData = snapshot.data?.data() as Map<String, dynamic>?;

        if (userData == null) {
          return Center(child: Text('No user data found'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${userData['name']}'),
            SizedBox(height: 16),
            Text('Email: ${userData['email']}'),
            SizedBox(height: 16),
            Text('Contact Number: ${userData['contactNumber']}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return EditUserProfileScreen(
                        userId: userId,
                        name: userData['name'],
                        email: userData['email'],
                        contactNumber: userData['contactNumber'],
                      );
                    },
                  ),
                );
              },
              child: Text('Edit User Profile'),
            ),
          ],
        );
      },
    );
  }
}

class EditUserProfileScreen extends StatelessWidget {
  final String userId;
  final String name;
  final String email;
  final String contactNumber;

  EditUserProfileScreen({
    required this.userId,
    required this.name,
    required this.email,
    required this.contactNumber,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController emailController = TextEditingController(text: email);
    TextEditingController contactNumberController =
        TextEditingController(text: contactNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name:'),
            TextFormField(
              controller: nameController,
            ),
            SizedBox(height: 16),
            Text('Email:'),
            TextFormField(
              controller: emailController,
            ),
            SizedBox(height: 16),
            Text('Contact Number:'),
            TextFormField(
              controller: contactNumberController,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement the code to update user profile here
              },
              child: Text('Update User Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
