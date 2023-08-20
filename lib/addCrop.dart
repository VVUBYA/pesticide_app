import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class PesticideDatabaseScreen extends StatefulWidget {
  @override
  _PesticideDatabaseScreenState createState() =>
      _PesticideDatabaseScreenState();
}

class _PesticideDatabaseScreenState extends State<PesticideDatabaseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _selectedCropName;
  DateTime? _selectedPlantingDate;
  String? _selectedField;
  double? _quantityPlanted;
  double? _maturityDays;

  List<String> fieldNames = [];

  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchFieldNames();
  }

  Future<void> fetchFieldNames() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('field').get();
      setState(() {
        fieldNames =
            querySnapshot.docs.map((doc) => doc.get('name') as String).toList();
      });
    } catch (e) {
      print('Error fetching field names: $e');
    }
  }

  Future<void> addCropData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('crops')
          .add({
        'name': _selectedCropName,
        'datePlanted': _selectedPlantingDate,
        'field': _selectedField,
        'quantityPlanted': _quantityPlanted,
        'maturityDays': _maturityDays,
        // Add other fields from your Firestore structure here
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Crop data added successfully'),
        ),
      );

      _formKey.currentState!.reset();
    } catch (e) {
      print('Error adding crop data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Database'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _selectedCropName = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Crop Name'),
              ),
              SizedBox(height: 16),
              TextFormField(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _selectedPlantingDate = pickedDate;
                    });
                  }
                },
                controller: TextEditingController(
                    text: _selectedPlantingDate != null
                        ? _selectedPlantingDate.toString()
                        : ''),
                decoration: InputDecoration(labelText: 'Planting Date'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedField,
                items: fieldNames
                    .map((fieldName) => DropdownMenuItem(
                          value: fieldName,
                          child: Text(fieldName),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedField = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Field'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _quantityPlanted = double.parse(value ?? '0');
                },
                decoration: InputDecoration(labelText: 'Quantity Planted'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Day of maturity';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _maturityDays = double.parse(value ?? '0');
                },
                decoration: InputDecoration(labelText: 'Maturity Days'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: addCropData,
                child: Text('Add Crop Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PesticideDatabaseScreen(),
  ));
}
