import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'userprofile.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<void> _signUpWithEmailPassword(BuildContext context) async {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Create user profile in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': fullNameController.text,
          'email': emailController.text,
          'contactNumber': phoneController.text,
          'linkedFarms': [], // Initialize with an empty array
        });

        // Navigate to ProfileScreen with the user's ID
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfileScreen(userId: userCredential.user!.uid),
          ),
        );
      } catch (e) {
        // Handle errors here, such as displaying an error message
        print("Error during signup: $e");
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Pop the current screen to go back
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/logo.jpg',
                  height: size.height * 0.2), // Set the desired height
              Text(
                'Get On Board!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20, // Choose an appropriate size for Headline1
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Create your profile to start your journey.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              Form(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: fullNameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_outlined),
                          labelText: 'Full Name',
                          hintText: 'Full Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: 'Email',
                          hintText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.numbers),
                          labelText: 'Phone No',
                          hintText: 'Phone No',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.fingerprint),
                          labelText: 'Password',
                          hintText: 'Password',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: null,
                            icon: Icon(Icons.remove_red_eye_sharp),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _signUpWithEmailPassword(context);
                          },
                          child: Text('SIGNUP'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('OR'),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: Image.asset('assets/images/google-logo.png',
                          width: 50.0),
                      onPressed: () {},
                      label: Text('SIGN UP WITH GOOGLE'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext content) {
                            return LoginScreen();
                          },
                        ),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Already Have An Account? ',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: const [
                          TextSpan(
                            text: 'LOGIN',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
