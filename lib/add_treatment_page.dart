import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTreatmentPage extends StatefulWidget {
  @override
  _AddTreatmentPageState createState() => _AddTreatmentPageState();
}

class _AddTreatmentPageState extends State<AddTreatmentPage> {
  DateTime? _selectedDate;
  String? _selectedTreatmentType;
  String? _selectedField;
  String? _selectedCrop;
  String? _selectedPesticideProduct;
  String? _selectedQuantity;
  String? _selectedStatus;
  String? _notes;

  final List<String> _treatmentTypes = [
    'Herbicide',
    'Fungicide',
    'Insecticide'
  ];
  List<String> _fields = [];
  List<String> _crops = [];
  List<String> _pesticideProducts = [];
  List<String> _quantities = ['5 ml', '10 ml', '20 ml', '30 ml'];
  final List<String> _status = ['Pending', 'Completed'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTreatment() async {
    try {
      await FirebaseFirestore.instance
          .collection('users/DRq7p0rLc9gJ5TVa3s0T0gh7wlT2/treatments')
          .add({
        'date': _selectedDate,
        'status': _selectedStatus,
        'type': _selectedTreatmentType,
        'field': _selectedField,
        'crop': _selectedCrop,
        'pesticide': _selectedPesticideProduct,
        'quantity': _selectedQuantity,
        'notes': _notes,
      });

      Navigator.pop(context); // Close the form page
    } catch (e) {
      print('Error adding treatment: $e');
      // Handle errors, show an error message, or take appropriate action
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  void _fetchDropdownData() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc('DRq7p0rLc9gJ5TVa3s0T0gh7wlT2')
          .get();

      List<String> fetchedFields = await FirebaseFirestore.instance
          .collection('users/${userSnapshot.id}/fields')
          .get()
          .then((querySnapshot) {
        return querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      });

      List<String> fetchedCrops = await FirebaseFirestore.instance
          .collection('users/${userSnapshot.id}/crops')
          .get()
          .then((querySnapshot) {
        return querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      });

      List<String> fetchedPesticideProducts = await FirebaseFirestore.instance
          .collection('users/${userSnapshot.id}/treatments')
          .get()
          .then((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => doc['pesticide'] as String)
            .toList();
      });

      setState(() {
        _fields = fetchedFields;
        _crops = fetchedCrops;
        _pesticideProducts = fetchedPesticideProducts;
      });
    } catch (e) {
      print('Error fetching dropdown data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Treatment'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(_selectedDate == null
                  ? 'Select Treatment Date'
                  : 'Treatment Date: ${_selectedDate.toString().split(' ')[0]}'),
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Treatment Type'),
                DropdownButton<String>(
                  value: _selectedTreatmentType,
                  hint: Text('Select Treatment Type'),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedTreatmentType = newValue;
                    });
                  },
                  items: _treatmentTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Field'),
                DropdownButton<String>(
                  value: _selectedField,
                  hint: Text('Select Field'),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedField = newValue;
                    });
                  },
                  items: _fields
                      .map((field) => DropdownMenuItem(
                            value: field,
                            child: Text(field),
                          ))
                      .toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Crop'),
                DropdownButton<String>(
                  value: _selectedCrop,
                  hint: Text('Select Crop'),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCrop = newValue;
                    });
                  },
                  items: _crops
                      .map((crop) => DropdownMenuItem(
                            value: crop,
                            child: Text(crop),
                          ))
                      .toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pesticide Product'),
                DropdownButton<String>(
                  value: _selectedPesticideProduct,
                  hint: Text('Select Pesticide Product'),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPesticideProduct = newValue;
                    });
                  },
                  items: _pesticideProducts
                      .map((product) => DropdownMenuItem(
                            value: product,
                            child: Text(product),
                          ))
                      .toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quantity'),
                DropdownButton<String>(
                  value: _selectedQuantity,
                  hint: Text('Select Quantity'),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedQuantity = newValue;
                    });
                  },
                  items: _quantities
                      .map((quantity) => DropdownMenuItem(
                            value: quantity,
                            child: Text(quantity),
                          ))
                      .toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status'),
                DropdownButton<String>(
                  value: _selectedStatus,
                  hint: Text('Select Status'),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedStatus = newValue;
                    });
                  },
                  items: _status
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Notes'),
              onChanged: (value) {
                setState(() {
                  _notes = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveTreatment,
              child: Text('Add Treatment'),
            ),
          ],
        ),
      ),
    );
  }
}
