import 'package:flutter/material.dart';

class PesticideEntry {
  String name;
  String field;
  DateTime dateApplied;
  double areaTreated;
  double rate;
  double totalAmountApplied;
  String cropTreated;
  String disposalMethod;
  String notes;

  PesticideEntry({
    required this.name,
    required this.field,
    required this.dateApplied,
    required this.areaTreated,
    required this.rate,
    required this.totalAmountApplied,
    required this.cropTreated,
    required this.disposalMethod,
    required this.notes,
  });
}

class Field {
  String name;

  Field({required this.name});
}

class PesticideTrackerScreen extends StatefulWidget {
  @override
  _PesticideTrackerScreenState createState() => _PesticideTrackerScreenState();
}

class _PesticideTrackerScreenState extends State<PesticideTrackerScreen> {
  List<Field> fields = [];
  List<PesticideEntry> pesticideEntries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesticide Tracker'),
      ),
      body: Column(
        children: [
          // Field Selection Dropdown
          DropdownButtonFormField<String>(
            value: fields.isEmpty ? null : fields[0].name,
            items: fields.map((field) {
              return DropdownMenuItem<String>(
                value: field.name,
                child: Text(field.name),
              );
            }).toList(),
            onChanged: (value) {
              // Handle field selection
              if (value != null) {
                _showAddPesticideEntryDialog(value);
              }
            },
          ),
          // Pesticide Entries List
          Expanded(
            child: ListView.builder(
              itemCount: pesticideEntries.length,
              itemBuilder: (context, index) {
                PesticideEntry entry = pesticideEntries[index];
                return ListTile(
                  title: Text(entry.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Field: ${entry.field}'),
                      Text('Date Applied: ${entry.dateApplied}'),
                      Text('Area Treated: ${entry.areaTreated}'),
                      Text('Rate (mls per 20 liters): ${entry.rate}'),
                      Text('Total Amount Applied: ${entry.totalAmountApplied}'),
                      Text('Crop Treated: ${entry.cropTreated}'),
                      Text('Disposal Method: ${entry.disposalMethod}'),
                      Text('Notes: ${entry.notes}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        pesticideEntries.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFieldDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddFieldDialog() {
    Field newField = Field(name: '');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Field'),
          content: TextFormField(
            decoration: InputDecoration(labelText: 'Field Name'),
            onChanged: (value) {
              newField.name = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  fields.add(newField);
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAddPesticideEntryDialog(String selectedField) {
    PesticideEntry newEntry = PesticideEntry(
      name: '',
      field: selectedField,
      dateApplied: DateTime.now(),
      areaTreated: 0,
      rate: 0,
      totalAmountApplied: 0,
      cropTreated: '',
      disposalMethod: '',
      notes: '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Pesticide Entry'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Pesticide Name'),
                  onChanged: (value) {
                    newEntry.name = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Area Treated'),
                  onChanged: (value) {
                    newEntry.areaTreated = double.tryParse(value) ?? 0;
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Rate (mls per 20 liters)'),
                  onChanged: (value) {
                    newEntry.rate = double.tryParse(value) ?? 0;
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Total Amount Applied'),
                  onChanged: (value) {
                    newEntry.totalAmountApplied = double.tryParse(value) ?? 0;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Crop Treated'),
                  onChanged: (value) {
                    newEntry.cropTreated = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Disposal Method'),
                  onChanged: (value) {
                    newEntry.disposalMethod = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Notes'),
                  onChanged: (value) {
                    newEntry.notes = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  pesticideEntries.add(newEntry);
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
