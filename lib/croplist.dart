import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Crop {
  final String id;
  final String name;
  final DateTime datePlanted;
  final String field;
  final double quantityPlanted;
  final double maturityDays;

  Crop({
    required this.id,
    required this.name,
    required this.datePlanted,
    required this.field,
    required this.quantityPlanted,
    required this.maturityDays,
  });
}

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

class CropListItem extends StatelessWidget {
  final Crop crop;

  CropListItem({required this.crop});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CropDetailsPage(crop: crop),
            ),
          );
        },
        child: Text(crop.name),
      ),
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
          CropListCard(),
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

        List<Crop> crops = cropDocs.map((doc) {
          Map<String, dynamic> cropData = doc.data() as Map<String, dynamic>;
          return Crop(
            id: doc.id,
            name: cropData['name'] ?? 'Unknown Crop',
            datePlanted: cropData['datePlanted'].toDate(),
            field: cropData['field'],
            quantityPlanted: cropData['quantityPlanted'],
            maturityDays: cropData['maturityDays'],
          );
        }).toList();

        return ListView.builder(
          itemCount: crops.length,
          itemBuilder: (context, index) {
            return CropListItem(
              crop: crops[index],
            );
          },
        );
      },
    );
  }
}

class CropDetailsPage extends StatelessWidget {
  final Crop crop;

  CropDetailsPage({required this.crop});

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
            Text('Crop Name: ${crop.name}'),
            Text('Date Planted: ${crop.datePlanted}'),
            Text('Field: ${crop.field}'),
            Text('Quantity Planted: ${crop.quantityPlanted}'),
            Text('Days to Maturity: ${crop.maturityDays}'),
            // Add other fields here
          ],
        ),
      ),
    );
  }
}
