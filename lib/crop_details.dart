import 'package:flutter/material.dart';

class CropDetailPage extends StatelessWidget {
  final Map<String, dynamic> cropData;

  CropDetailPage({required this.cropData});

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
