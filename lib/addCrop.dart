import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  List<String> cropNames = [];
  List<String> fieldNames = [];

  @override
  void initState() {
    super.initState();
    fetchCropNames();
    fetchFieldNames();
  }

  Future<void> fetchCropNames() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('crop').get();
      setState(() {
        cropNames =
            querySnapshot.docs.map((doc) => doc.get('name') as String).toList();
      });
    } catch (e) {
      print('Error fetching crop names: $e');
    }
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
      String userId =
          FirebaseAuth.instance.currentUser!.uid; // Get current user's ID

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('crops')
          .add({
        'name': _selectedCropName,
        'date planted': _selectedPlantingDate,
        'field': _selectedField,
        'quantity planted': _quantityPlanted,
        'days to maturity': _maturityDays,
        // Add other fields from your Firestore structure here
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Crop data added successfully'),
        ),
      );

      _formKey.currentState!.reset();
      Navigator.pop(context); // Redirect back to the previous screen
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
              DropdownButtonFormField<String>(
                value: _selectedCropName,
                items: cropNames
                    .map((cropName) => DropdownMenuItem(
                          value: cropName,
                          child: Text(cropName),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCropName = value;
                    // Fetch varieties for selected crop
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
