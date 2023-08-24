import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addCrop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'addfield.dart';
import 'pesticide_identfication_section.dart';

void main() {
  runApp(MyApp());
}

class Crop {
  final String id;
  final DateTime datePlanted;
  final int daysToMaturity;
  final String field;
  final String name;
  final int quantityPlanted;
  final List<String> variety;

  Crop({
    required this.id,
    required this.datePlanted,
    required this.daysToMaturity,
    required this.field,
    required this.name,
    required this.quantityPlanted,
    required this.variety,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SprayProductListCard(),
            ],
          ),
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

class SprayProductListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext content) {
                return SprayProductsPage();
              },
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.dangerous, size: 100, color: Colors.brown),
              SizedBox(height: 20),
              Text('Spray Products List', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}

class CropListPage extends StatefulWidget {
  @override
  _CropListPageState createState() => _CropListPageState();
}

class _CropListPageState extends State<CropListPage> {
  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Crop List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('crops')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No crops added yet!'),
            );
          }

          final cropDocs = snapshot.data!.docs;

          List<Crop> crops = cropDocs.map((doc) {
            final cropData = doc.data() as Map<String, dynamic>;
            return Crop(
              id: doc.id,
              datePlanted: cropData['datePlanted'] is Timestamp
                  ? cropData['datePlanted'].toDate()
                  : DateTime.now(),
              daysToMaturity:
                  cropData['daysToMaturity'] ?? 0, // Provide default value
              field: cropData['field'] ?? 'Unknown Field',
              name: cropData['name'] ?? 'Unnamed Crop',
              quantityPlanted: cropData['quantityPlanted'] ?? 0,
              variety: List<String>.from(cropData['variety'] ?? []),
            );
          }).toList();

          return ListView.builder(
            itemCount: crops.length,
            itemBuilder: (context, index) {
              final crop = crops[index];

              return ListTile(
                title: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CropDetailsPage(crop: crop),
                      ),
                    );
                  },
                  child: Text(crop.name),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Field: ${crop.field}'),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCrop = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PesticideDatabaseScreen()),
          );

          if (newCrop != null) {
            // Handle updating the crop list or trigger a refresh
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class CropDetailsPage extends StatelessWidget {
  final Crop crop;

  CropDetailsPage({required this.crop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Details'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Name: ${crop.name}'),
          ),
          ListTile(
            title: Text('Date Planted: ${crop.datePlanted}'),
          ),
          ListTile(
            title: Text('Days to Maturity: ${crop.daysToMaturity}'),
          ),
          ListTile(
            title: Text('Field: ${crop.field}'),
          ),
          ListTile(
            title: Text('Quantity Planted: ${crop.quantityPlanted}'),
          ),
          ListTile(
            title: Text('Variety: ${crop.variety.join(", ")}'),
          ),
          // Display other fields and options here
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

// ... (Previous code remains the same)

class FieldListPage extends StatefulWidget {
  @override
  _FieldListPageState createState() => _FieldListPageState();
}

class _FieldListPageState extends State<FieldListPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _fields = []; // List to hold field data

  @override
  void initState() {
    super.initState();
    fetchFields();
  }

  Future<void> fetchFields() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('fields')
          .get();
      setState(() {
        _fields = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error fetching field data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Fields',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    // Reset search
                  },
                ),
              ),
              onChanged: (value) {
                // Handle search query
              },
            ),
          ),
          if (_fields.isEmpty)
            Expanded(
              child: Center(
                child: Text('No fields added yet!',
                    style: TextStyle(fontSize: 20)),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _fields.length,
                itemBuilder: (context, index) {
                  final field = _fields[index];
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FieldDetailsPage(field: field),
                        ),
                      );
                    },
                    title: Text(field['name'] ?? 'Unnamed Field'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Type: ${field['type'] ?? ''}'),
                      ],
                    ),
                    // Add more details or actions as needed
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddFieldPage()),
          ).then((value) {
            // Handle adding new field
            if (value == true) {
              fetchFields(); // Refresh the list after adding a field
            }
          });
        },
        icon: Icon(Icons.add),
        label: Text('Add Field'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class FieldDetailsPage extends StatelessWidget {
  final Map<String, dynamic> field;

  FieldDetailsPage({required this.field});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Field Details'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Name: ${field['name'] ?? 'Unnamed Field'}'),
          ),
          ListTile(
            title: Text('Type: ${field['type'] ?? ''}'),
          ),
          ListTile(
            title: Text('Size: ${field['size'] ?? ''}'),
          ),
          ListTile(
            title: Text('Status: ${field['status'] ?? ''}'),
          ),
          ListTile(
            title: Text('Light Profile: ${field['lightProfile'] ?? ''}'),
          ),
          ListTile(
            title: Text('Notes: ${field['notes'] ?? ''}'),
          ),
          // Display other fields and options here
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
