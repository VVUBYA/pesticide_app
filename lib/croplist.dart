import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FarmManagementScreen(),
    );
  }
}

class FarmManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farm Management'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CropListCard(),
              FieldListCard(),
            ],
          ),
          SizedBox(height: 20),
          // Add other sections here
        ],
      ),
    );
  }
}

class CropListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CropListPage()),
          );
        },
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.grass, size: 100, color: Colors.green),
              SizedBox(height: 20),
              Text('Crop List', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}

class FieldListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          // Handle onTap
        },
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.landscape, size: 100, color: Colors.brown),
              SizedBox(height: 20),
              Text('Field List', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}

class CropListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Crop List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Center(
            child: Text('No crops added yet!', style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Handle add crop
            },
            icon: Icon(Icons.add),
            label: Text('Add'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
