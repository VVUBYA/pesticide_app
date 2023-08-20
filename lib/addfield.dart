import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddFieldPage extends StatefulWidget {
  @override
  _AddFieldPageState createState() => _AddFieldPageState();
}

class _AddFieldPageState extends State<AddFieldPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _fieldName;
  String? _fieldType = 'Field/outdoor'; // Default value
  String? _lightProfile = 'full sun';
  String? _fieldStatus = 'available'; // Default value
  double? _fieldSize;
  String? _notes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Field'),
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
                    _fieldName = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Field Name'),
              ),
              DropdownButtonFormField<String>(
                value: _fieldType,
                items: [
                  'Field/outdoor',
                  'greenhouse',
                  'grow tent',
                ].map((fieldType) {
                  return DropdownMenuItem<String>(
                    value: fieldType,
                    child: Text(fieldType),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _fieldType = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Field Type'),
              ),
              DropdownButtonFormField<String>(
                value: _lightProfile,
                items: [
                  'full sun',
                  'full to partial sun',
                  'partial sun',
                  'partial shade',
                  'full shade',
                ].map((lightProfile) {
                  return DropdownMenuItem<String>(
                    value: lightProfile,
                    child: Text(lightProfile),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _lightProfile = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Light Profile'),
              ),
              DropdownButtonFormField<String>(
                value: _fieldStatus,
                items: [
                  'available',
                  'partially cultivated',
                  'fully cultivated',
                ].map((fieldStatus) {
                  return DropdownMenuItem<String>(
                    value: fieldStatus,
                    child: Text(fieldStatus),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _fieldStatus = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Field Status'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _fieldSize = double.parse(value ?? '0');
                },
                decoration: InputDecoration(labelText: 'Field Size (Optional)'),
              ),
              TextFormField(
                onSaved: (value) {
                  _notes = value;
                },
                decoration: InputDecoration(labelText: 'Notes'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: addFieldData,
                child: Text('Add Field'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addFieldData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      String userId =
          FirebaseAuth.instance.currentUser!.uid; // Get current user's ID

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('fields')
          .add({
        'name': _fieldName,
        'type': _fieldType,
        'light profile': _lightProfile,
        'status': _fieldStatus,
        'size': _fieldSize,
        'notes': _notes,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Field data added successfully'),
        ),
      );

      _formKey.currentState!.reset();
      Navigator.pop(context); // Redirect back to the previous screen
    } catch (e) {
      print('Error adding field data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: AddFieldPage(),
  ));
}
