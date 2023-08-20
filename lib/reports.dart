import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SprayReportScreen extends StatelessWidget {
  final Map<String, dynamic> sprayData;

  SprayReportScreen({required this.sprayData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spray Report'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spray Report',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Date: ${DateFormat.yMd().add_Hm().format(DateTime.now())}'),
            Text('Operator: ${sprayData['operator']}'),
            Text('Supervisor: ${sprayData['supervisor']}'),
            SizedBox(height: 16),
            Text(
              'Spray Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Spray Status: ${sprayData['status']}'),
            Text(
                'Start Date/Time: ${DateFormat.yMd().add_Hm().format(sprayData['startdate'])}'),
            Text(
                'Finish Date/Time: ${DateFormat.yMd().add_Hm().format(sprayData['finishdate'])}'),
            Text(
                'Neighbors Notified: ${sprayData['neighbornotified'] ? 'Yes' : 'No'}'),
            Text('Comments/Observation: ${sprayData['observations']}'),
            Text('Instructions: ${sprayData['instructions']}'),
            SizedBox(height: 16),
            Text(
              'Safety Equipment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Gloves: ${sprayData['gloves'] ? 'Yes' : 'No'}'),
            Text('Hat: ${sprayData['hat'] ? 'Yes' : 'No'}'),
            Text('Boots: ${sprayData['boots'] ? 'Yes' : 'No'}'),
            Text('Respirator/Mask: ${sprayData['respirator'] ? 'Yes' : 'No'}'),
            Text('Overalls: ${sprayData['overalls'] ? 'Yes' : 'No'}'),
            Text('Spraysuit: ${sprayData['spraysuit'] ? 'Yes' : 'No'}'),
            Text('First Aid Kit: ${sprayData['firstaid'] ? 'Yes' : 'No'}'),
            Text('Apron: ${sprayData['apron'] ? 'Yes' : 'No'}'),
            Text('Safe Helmet: ${sprayData['helmet'] ? 'Yes' : 'No'}'),
            SizedBox(height: 16),
            Text(
              'Target Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Target: ${sprayData['target']}'),
            Text('Target Description: ${sprayData['description']}'),
            SizedBox(height: 16),
            Text(
              'Weather Conditions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Temperature (°C): ${sprayData['temperature']}'),
            Text('Humidity (%): ${sprayData['humidity']}'),
            Text('Cloud Cover (%): ${sprayData['cloud']}'),
            Text('Wind Speed (km/h): ${sprayData['windspeed']}'),
            Text('Wind Direction: ${sprayData['direction']}'),
            Text('Any Rain? ${sprayData['anyrain'] ? 'Yes' : 'No'}'),
            SizedBox(height: 16),
            Text(
              'Spray Site Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Site/Area: ${sprayData['site']}'),
            Text('Growth Stage: ${sprayData['stage']}'),
            Text('Spray Unit: ${sprayData['unit']}'),
            Text('Number of Tanks Sprayed: ${sprayData['numtanks']}'),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Spray Report App',
    home: SprayReportScreen(
      sprayData: {
        'operator': 'John Doe',
        'supervisor': 'Jane Smith',
        'status': 'scheduled',
        'startdate': DateTime.now(),
        'finishdate': DateTime.now(),
        'neighbornotified': true,
        'observations': 'Observations...',
        'instructions': 'Instructions...',
        'gloves': true,
        'hat': false,
        'boots': true,
        'respirator': false,
        'overalls': true,
        'spraysuit': true,
        'firstaid': false,
        'apron': true,
        'helmet': false,
        'target': 'Weeds',
        'description': 'Broadleaf weeds',
        'temperature': 25.5,
        'humidity': 70.0,
        'cloud': 30.0,
        'windspeed': 10.0,
        'direction': 'North',
        'anyrain': false,
        'site': 'Field A',
        'stage': 'Vegetative',
        'unit': 'Backpack Sprayer',
        'numtanks': 3,
      },
    ),
  ));
}
