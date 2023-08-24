import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'productdetails.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spray Products Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SprayProductsPage(),
    );
  }
}

class SprayProductsPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spray Products'),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(''), // Replace with user initials
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Spray Products',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ProductsTable(),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  _showAddNewEntryDialog(context);
                },
                child: Text('Add New Entry'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddNewEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddProductDialog();
      },
    );
  }
}

class ProductsTable extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      return Center(
        child: Text('User not authenticated'),
      );
    }

    return Card(
      margin: EdgeInsets.all(16.0),
      elevation: 4.0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('products')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error loading data'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final products = snapshot.data?.docs ?? [];

            return DataTable(
              columnSpacing: 20.0, // Adjust the spacing between columns
              columns: [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Manufacturer')),
              ],
              rows: products.map((product) {
                final data = product.data() as Map<String, dynamic>;
                return DataRow(
                  cells: [
                    DataCell(
                      GestureDetector(
                        child: Text(data['name'] ?? ''),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                  data), // Pass product data to the detail page
                            ),
                          );
                        },
                      ),
                    ),
                    DataCell(Text(data['type'] ?? '')),
                    DataCell(Text(data['manufacturer'] ?? '')),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class AddProductDialog extends StatefulWidget {
  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _activeIngredientController = TextEditingController();
  final _restrictionsController = TextEditingController();
  final _dosageController = TextEditingController();
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Product'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _selectedType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
                items: <String>[
                  'Adjuvant',
                  'Fertilizer',
                  'Fungicide',
                  'Herbicide',
                  'Insecticide',
                  'Nematicide',
                  'Pesticide',
                  'Promoter',
                  'Regulator',
                  'Seed Treatment',
                  'Surfactant',
                  'Wetting Agent',
                  'Other',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Type',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a product type';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _manufacturerController,
                decoration: InputDecoration(
                  labelText: 'Manufacturer',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a manufacturer';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _activeIngredientController,
                decoration: InputDecoration(
                  labelText: 'Active Ingredient',
                ),
              ),
              TextFormField(
                controller: _dosageController,
                decoration: InputDecoration(
                  labelText: 'Dosage',
                ),
              ),
              TextFormField(
                controller: _restrictionsController,
                decoration: InputDecoration(
                  labelText: 'Restrictions/Withholding Period',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _saveForm();
          },
          child: Text('Save Changes'),
        ),
      ],
    );
  }

  Future<void> _saveForm() async {
    final user = _auth.currentUser;
    if (user == null) {
      print('User not authenticated');
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (_selectedType != null) {
        final data = {
          'type': _selectedType,
          'name': _nameController.text,
          'manufacturer': _manufacturerController.text,
          'activeIngredient': _activeIngredientController.text,
          'restrictions': _restrictionsController.text,
          'dosage': _dosageController.text,
        };

        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('products')
              .add(data);

          Navigator.of(context).pop(); // Close the dialog after saving
        } catch (e) {
          print('Error saving data: $e');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a product type')),
        );
      }
    }
  }
}
