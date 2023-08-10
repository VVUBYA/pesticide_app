import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Crop {
  final String name;
  final String harvestUnit;
  final String notes;

  Crop({
    required this.name,
    required this.harvestUnit,
    required this.notes,
  });
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

class FarmManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farm Management'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CropListCard(),
              FieldListCard(),
            ],
          ),
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

class FieldListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FieldListPage()),
          );
        },
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.landscape, size: 100, color: Colors.brown),
              SizedBox(height: 20),
              Text('Field List', style: TextStyle(fontSize: 20)),
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Crop List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Center(
            child: Text('No crops added yet!', style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCropPage()),
              );
            },
            icon: Icon(Icons.add),
            label: Text('Add Crop'),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class CropDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop List'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Name: Crop Name'),
          ),
          ListTile(
            title: Text('Harvest Unit: Harvest Unit'),
          ),
          ListTile(
            title:
                Text('Varieties: 0'), // You can update this value dynamically
          ),
          ListTile(
            title: Text('Planting: 0'), // You can update this value dynamically
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show a bottom sheet with options
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.remove_red_eye),
                    title: Text('View Details'),
                    onTap: () {
                      // Handle view details
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit Record'),
                    onTap: () {
                      // Handle edit record
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Add Variety'),
                    onTap: () {
                      // Handle add variety
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add_circle),
                    title: Text('Add Planting'),
                    onTap: () {
                      // Handle add planting
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Delete'),
                    onTap: () {
                      // Handle delete
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.more_vert),
      ),
    );
  }
}

class AddCropPage extends StatefulWidget {
  @override
  _AddCropPageState createState() => _AddCropPageState();
}

class _AddCropPageState extends State<AddCropPage> {
  final TextEditingController _cropNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String _harvestUnit = 'quantity'; // Default value

  @override
  void dispose() {
    _cropNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveCrop() {
    String cropName = _cropNameController.text;
    String notes = _notesController.text;

    if (cropName.isNotEmpty && _harvestUnit.isNotEmpty) {
      Crop newCrop = Crop(
        name: cropName,
        harvestUnit: _harvestUnit,
        notes: notes,
      );

      // Here you can add the newCrop to your crops list or save it using your preferred storage mechanism.
      // For now, let's just print the details.
      print('New Crop: $newCrop');
    }

    Navigator.pop(context); // Go back after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Crop'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveCrop,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _cropNameController,
              decoration: InputDecoration(labelText: 'Name of Crop'),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _harvestUnit,
              decoration: InputDecoration(labelText: 'Harvest Unit'),
              onChanged: (value) {
                setState(() {
                  _harvestUnit = value!;
                });
              },
              items: [
                'quantity',
                'bales',
                'bunches',
                'bushels',
                'gallons',
                'grams',
                'kilograms',
                'litres',
                'tonnes',
                'boxes',
                'sacks',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(labelText: 'Write Notes'),
            ),
          ],
        ),
      ),
    );
  }
}

class FieldListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Field List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Center(
            child: Text('No fields added yet!', style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFieldPage()),
          );
        },
        icon: Icon(Icons.add),
        label: Text('Add Field'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class AddFieldPage extends StatefulWidget {
  @override
  _AddFieldPageState createState() => _AddFieldPageState();
}

class _AddFieldPageState extends State<AddFieldPage> {
  String _fieldName = '';
  String _fieldType = 'Field/outdoor'; // Default value
  String _lightProfile = 'full sun'; // Default value
  String _fieldStatus = 'available'; // Default value
  double _fieldSize = 0;
  String _notes = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Field'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Handle save
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name of Field'),
              onChanged: (value) {
                setState(() {
                  _fieldName = value;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _fieldType,
              decoration: InputDecoration(labelText: 'Field Type'),
              onChanged: (value) {
                setState(() {
                  _fieldType = value!;
                });
              },
              items: [
                'Field/outdoor',
                'greenhouse',
                'grow tent',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _lightProfile,
              decoration: InputDecoration(labelText: 'Light Profile'),
              onChanged: (value) {
                setState(() {
                  _lightProfile = value!;
                });
              },
              items: [
                'full sun',
                'full to partial sun',
                'partial sun',
                'partial shade',
                'full shade',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _fieldStatus,
              decoration: InputDecoration(labelText: 'Field Status'),
              onChanged: (value) {
                setState(() {
                  _fieldStatus = value!;
                });
              },
              items: [
                'available',
                'partially cultivated',
                'fully cultivated',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Field Size (Optional)'),
              onChanged: (value) {
                setState(() {
                  _fieldSize = double.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(labelText: 'Write Notes'),
              onChanged: (value) {
                setState(() {
                  _notes = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
