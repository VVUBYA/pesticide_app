import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login.dart';
import 'signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Set the initial route here
      routes: {
        '/': (context) => WelcomeScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        // Add more routes if needed
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => NotFoundPage());
      },
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/images/logo.PNG', height: height * 0.6),
            Column(
              children: [
                Text(
                  'SAFELY USE YOUR PESTICIDES',
                  style: TextStyle(
                    fontSize: 20, // Choose an appropriate size for Headline1
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Lets put your pesticide application on the right way',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
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
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.black),
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                    ),
                    child: Text('Login'.toUpperCase()),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext content) {
                            return SignUpScreen();
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      side: BorderSide(color: Colors.black),
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                    ),
                    child: Text('Signup'.toUpperCase()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for not found page
class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Not Found'),
      ),
      body: Center(
        child: Text('Oops! Page not found.'),
      ),
    );
  }
}
