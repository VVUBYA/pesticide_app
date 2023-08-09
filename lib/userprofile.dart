import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId =
        'KTAVSGJn1edYpqMePIt5QkFs44s2'; // Replace with the actual user ID
    return MaterialApp(
      home: ProfileScreen(userId: userId),
    );
  }
}

class UserProfile {
  String id;
  String name;
  String email;
  String contactNumber;
  List<String> linkedFarms;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.linkedFarms,
  });
}

class ProfileScreen extends StatefulWidget {
  final String userId;

  ProfileScreen({required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late UserProfile userProfile;

  @override
  void initState() {
    super.initState();
    // Initialize user profile by fetching it from Firestore based on the provided user ID
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      DocumentSnapshot profileSnapshot =
          await _firestore.collection('users').doc(widget.userId).get();
      if (profileSnapshot.exists) {
        Map<String, dynamic> profileData =
            profileSnapshot.data() as Map<String, dynamic>;
        setState(() {
          userProfile = UserProfile(
            id: widget.userId,
            name: profileData['name'],
            email: profileData['email'],
            contactNumber: profileData['contactNumber'],
            linkedFarms: List<String>.from(profileData['linkedFarms']),
          );
        });
      }
    } catch (error) {
      print('Error fetching user profile: $error');
    }
  }

  Future<void> addUserProfile() async {
    try {
      await _firestore.collection('users').doc(userProfile.id).set({
        'name': userProfile.name,
        'email': userProfile.email,
        'contactNumber': userProfile.contactNumber,
        'linkedFarms': userProfile.linkedFarms,
      });
      print('User profile added successfully.');
    } catch (error) {
      print('Error adding user profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userProfile == null) {
      // Display a loading indicator while fetching user profile
      return Scaffold(
        appBar: AppBar(
          title: Text('User Profile'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name:'),
            TextFormField(
              initialValue: userProfile.name,
              onChanged: (value) {
                setState(() {
                  userProfile.name = value;
                });
              },
            ),
            SizedBox(height: 16),
            Text('Contact Number:'),
            TextFormField(
              initialValue: userProfile.contactNumber,
              onChanged: (value) {
                setState(() {
                  userProfile.contactNumber = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addUserProfile,
              child: Text('Add User Profile'),
            ),
            SizedBox(height: 16),
            Text('Linked Farms: ${userProfile.linkedFarms.join(', ')}'),
          ],
        ),
      ),
    );
  }
}
