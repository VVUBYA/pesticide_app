import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> productData;

  ProductDetailPage(this.productData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productData['name']),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${productData['type']}'),
            SizedBox(height: 8.0),
            Text('Manufacturer: ${productData['manufacturer']}'),
            SizedBox(height: 8.0),
            Text('Active Ingredient: ${productData['activeIngredient']}'),
            SizedBox(height: 8.0),
            Text('Dosage: ${productData['dosage']}'),
            SizedBox(height: 8.0),
            Text('Restrictions: ${productData['restrictions']}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
