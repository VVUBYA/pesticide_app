import 'package:flutter/material.dart';
import 'pesticide_identfication_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class PesticideListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SprayProductsPage()),
          );
        },
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.grass, size: 100, color: Colors.green),
              SizedBox(height: 20),
              Text('Spray Products', style: TextStyle(fontSize: 20)),
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
        title: Text('Crop List'),
      ),
      body: CropList(),
    );
  }
}

class CropList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('crops').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<QueryDocumentSnapshot> cropDocs = snapshot.data!.docs;

        if (cropDocs.isEmpty) {
          return Center(
            child: Text('No crops added yet!'),
          );
        }

        return ListView.builder(
          itemCount: cropDocs.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> cropData =
                cropDocs[index].data() as Map<String, dynamic>;

            return ListTile(
              title: Text(cropData['name'] ?? 'Unknown Crop'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CropDetailsPage(cropData: cropData),
                  ),
                );
              },
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('crops')
                      .doc(cropDocs[index].id)
                      .delete();
                },
              ),
            );
          },
        );
      },
    );
  }
}

class CropDetailsPage extends StatelessWidget {
  final Map<String, dynamic> cropData;

  CropDetailsPage({required this.cropData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Crop Name: ${cropData['name']}'),
            Text('Date Planted: ${cropData['datePlanted']}'),
            Text('Field: ${cropData['field']}'),
            Text('Quantity Planted: ${cropData['quantityPlanted']}'),
            Text('Days to Maturity: ${cropData['daysToMaturity']}'),
            // Add other fields here
          ],
        ),
      ),
    );
  }
}
