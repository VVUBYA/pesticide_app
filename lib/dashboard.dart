import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'menubar.dart';
import 'pesticide_identfication_section.dart';
import 'safety_tips.dart';
import 'package:table_calendar/table_calendar.dart';
import 'reports.dart';
import 'usage_tracker.dart';
import 'emergency_contacts.dart';
import 'recent_activity.dart';
import 'usage_tracker.dart';
import 'weather.dart';
import 'activity_logger.dart';
import 'calender.dart';
import 'treatment.dart';
import 'pesticideIdentification.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showCalendar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Calendar'),
          content: Center(
            child: Text('This is the calendar screen'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the pop-up
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          // Custom App Bar
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/images/dashboard.jpg'), // Replace with your app bar background image
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.white, size: 40),
                      onPressed: () {
                        _scaffoldKey.currentState!
                            .openDrawer(); // Open the drawer
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today,
                          color: Colors.white, size: 40),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext content) {
                              return HomeCalendarPage();
                            },
                          ),
                        );
                        // Show the calendar as a pop-up
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Dashboard Content
          Expanded(
            flex: 8,
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              children: [
                DashboardCard(
                  title: 'Tips',
                  icon: Icons.lightbulb_outline,
                  onTap: () {
                    ActivityLogger.logActivity('Navigated to tips');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext content) {
                          return TipsPage();
                        },
                      ),
                    );
                  },
                ),
                DashboardCard(
                  title: 'Report',
                  icon: Icons.history,
                  onTap: () {
                    ActivityLogger.logActivity(
                        'Navigated to Recent Activities');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext content) {
                          return SprayEntryReportPage();
                        },
                      ),
                    );
                    // Implement navigation to recent activities screen
                    // Naviga
                  },
                ),
                DashboardCard(
                  title: 'Feild Tracker',
                  icon: Icons.list_alt,
                  onTap: () {
                    ActivityLogger.logActivity('Navigated to Field Tracker');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext content) {
                          return FarmManagementScreen();
                        },
                      ),
                    );
                  },
                ),
                DashboardCard(
                  title: 'Spray Records',
                  icon: Icons.file_copy_outlined,
                  onTap: () {
                    ActivityLogger.logActivity('Navigated to Treatments');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext content) {
                          return SprayDiaryPage();
                        },
                      ),
                    );

                    // Implement navigation to safety guidelines screen
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => SafetyGuidelinesScreen()));
                  },
                ),
                DashboardCard(
                  title: 'Pesticide Identification',
                  icon: Icons.bug_report,
                  onTap: () {
                    ActivityLogger.logActivity(
                        'Navigated to Pesticide Identification');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext content) {
                          return PesticideIdentificationPage();
                        },
                      ),
                    );

                    // Implement navigation to pest identification screen
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => PestIdentificationScreen()));
                  },
                ),
                DashboardCard(
                  title: 'Weather Updates',
                  icon: Icons.cloud,
                  onTap: () {
                    ActivityLogger.logActivity('Navigated to Weather Updates');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext content) {
                          return Weather();
                        },
                      ),
                    );
                    // Implement navigation to weather updates screen
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherUpdatesScreen()));
                  },
                ),

                // Add other DashboardCards here
              ],
            ),
          ),
        ],
      ),
      drawer: CustomMenuBar(auth: _auth), // Add the MenuBar to the drawer
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 48),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
