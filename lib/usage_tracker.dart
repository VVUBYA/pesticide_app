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
                _showAddPesticideDialog(value);
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
                  subtitle: Text(
                      'Field: ${entry.field}\nDate Applied: ${entry.dateApplied}\nNotes: ${entry.notes}'),
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

  void _showAddPesticideDialog(String selectedField) {
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
                ListTile(
                  title: Text('Date Applied'),
                  subtitle: Text('${newEntry.dateApplied}'),
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2030),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        newEntry.dateApplied = selectedDate;
                      });
                    }
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
