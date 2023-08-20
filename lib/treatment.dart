import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'Spray Diary App',
    home: SprayDiaryPage(),
  ));
}

class SprayDiaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spray Diary'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('sprayEntries').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final entries = snapshot.data?.docs ?? [];

          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No entries found'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index].data() as Map<String, dynamic>;
              return EntryTile(entry: entry);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSprayEntryScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class EntryTile extends StatelessWidget {
  final Map<String, dynamic> entry;

  EntryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(entry['status'] ?? ''),
        subtitle: Text(entry['observations'] ?? ''),
      ),
    );
  }
}

class AddSprayEntryScreen extends StatefulWidget {
  @override
  _AddSprayEntryScreenState createState() => _AddSprayEntryScreenState();
}

class _AddSprayEntryScreenState extends State<AddSprayEntryScreen> {
  String windDirection = 'North';
  String sprayStatus = 'scheduled';
  DateTime? startDate;
  DateTime? finishDate;
  bool neighborsNotified = false;
  String observation = '';
  String instructions = '';
  String operatorName = '';
  String supervisorName = '';
  bool glassesChecked = false;
  bool glovesChecked = false;
  bool hatChecked = false;
  bool bootsChecked = false;
  bool respiratorChecked = false;
  bool overallsChecked = false;
  bool spraysuitChecked = false;
  bool firstAidKitChecked = false;
  bool apronChecked = false;
  bool safeHelmetChecked = false;
  String target = '';
  String targetDescription = '';
  double temperature = 0.0;
  double humidity = 0.0;
  double cloudCover = 0.0;
  double windSpeed = 0.0;
  bool anyRain = false;
  String spraySite = '';
  String growthStage = '';
  String sprayUnit = '';
  double numTanksSprayed = 0;
  String selectedCrop = ''; // Selected crop from the list
  String selectedField = ''; // Selected field from the list

  List<String> cropList = []; // List of crops
  List<String> fieldList = []; // List of fields

  @override
  void initState() {
    super.initState();
    fetchCropList();
    fetchFieldList();
  }

  Future<void> fetchCropList() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('crops').get();
      setState(() {
        cropList =
            querySnapshot.docs.map((doc) => doc.get('name') as String).toList();
      });
    } catch (e) {
      print('Error fetching crop list: $e');
    }
  }

  Future<void> fetchFieldList() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('fields').get();
      setState(() {
        fieldList =
            querySnapshot.docs.map((doc) => doc.get('name') as String).toList();
      });
    } catch (e) {
      print('Error fetching field list: $e');
    }
  }

  Future<void> addFieldData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('sprayEntries')
          .add({
        'direction': windDirection,
        'status': sprayStatus,
        'startdate': startDate,
        'finishdate': finishDate,
        'neighbornotified': neighborsNotified,
        'observations': observation,
        'instructions': instructions,
        'operator': operatorName,
        'supervisor': supervisorName,
        'numtunks': numTanksSprayed,
        'spraysuit': spraysuitChecked,
        'stage': growthStage,
        'target': target,
        'temperature': temperature,
        'unit': sprayUnit,
        'site': spraySite,
        'overalls': overallsChecked,
        'respirator': respiratorChecked,
        'humidity': humidity,
        'helmet': safeHelmetChecked,
        'hat': hatChecked,
        'gloves': glovesChecked,
        'glasses': glassesChecked,
        'firstaid': firstAidKitChecked,
        'description': targetDescription,
        'apron': apronChecked,
        'boots': bootsChecked,
        'any rain': anyRain,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Spray entry added successfully'),
        ),
      );

      Navigator.pop(context); // Close the entry screen
    } catch (e) {
      print('Error adding spray entry: $e');
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
        title: Text(''),
        actions: [
          TextButton(
            onPressed: () {
              addFieldData(); // Call addFieldData when Save Changes is pressed
            },
            child: Text(
              'Save Changes',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spray Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                _buildStatusButton('Scheduled', 'scheduled'),
                _buildStatusButton('In Progress', 'in_progress'),
                _buildStatusButton('Sprayed', 'sprayed'),
              ],
            ),
            SizedBox(height: 20),
            _buildDateTimePicker('Start Date/Time', startDate, (date) {
              setState(() {
                startDate = date;
              });
            }),
            _buildDateTimePicker('Finish Date/Time', finishDate, (date) {
              setState(() {
                finishDate = date;
              });
            }),
            _buildCheckBox('Neighbors Notified', neighborsNotified, (newValue) {
              setState(() {
                neighborsNotified = newValue ?? false;
              });
            }),
            _buildTextField('Comments/Observation', observation),
            _buildTextField('Instructions', instructions),
            SizedBox(height: 20),
            Text(
              'Operator & Supervisor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildTextField('Operator', operatorName),
            _buildTextField('Supervisor', supervisorName),
            SizedBox(height: 20),
            Text(
              'Operator Safety',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildCheckBox('Glasses/Goggles', glassesChecked, (value) {
              setState(() {
                glassesChecked = false;
              });
            }),
            _buildCheckBox('Gloves', glovesChecked, (newValue) {
              setState(() {
                glovesChecked = newValue ?? false;
              });
            }),
            _buildCheckBox('Hat', hatChecked, (newValue) {
              setState(() {
                hatChecked = newValue ?? false;
              });
            }),
            _buildCheckBox('Boots', bootsChecked, (newValue) {
              setState(() {
                bootsChecked = newValue ?? false;
              });
            }),
            _buildCheckBox('Respirator/Mask', respiratorChecked, (newValue) {
              setState(() {
                respiratorChecked = newValue ?? false;
              });
            }),
            _buildCheckBox('Overalls', overallsChecked, (newValue) {
              setState(() {
                overallsChecked = newValue ?? false;
              });
            }),
            _buildCheckBox('Spraysuit', spraysuitChecked, (newValue) {
              setState(() {
                spraysuitChecked = newValue ?? false;
              });
            }),
            _buildCheckBox('First Aid Kit', firstAidKitChecked, (newValue) {
              setState(() {
                firstAidKitChecked = newValue ?? false;
              });
            }),
            _buildCheckBox('Apron', apronChecked, (newValue) {
              setState(() {
                apronChecked = newValue ?? false;
              });
            }),
            _buildCheckBox('Safe Helmet', safeHelmetChecked, (newValue) {
              setState(() {
                safeHelmetChecked = newValue ?? false;
              });
            }),
            SizedBox(height: 20),
            Text(
              'Target',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildTextField('Target', target),
            _buildTextField('Target Description', targetDescription),
            SizedBox(height: 20),
            Text(
              'Weather Conditions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildNumericField('Temperature (°C)', temperature),
            _buildNumericField('Humidity (%)', humidity),
            _buildNumericField('Cloud Cover (%)', cloudCover),
            _buildNumericField('Wind Speed (km/h)', windSpeed),
            _buildDropdown(
              'Wind Direction',
              windDirection,
              [
                'North',
                'Northeast',
                'East',
                'Southeast',
                'South',
                'Southwest',
                'West',
                'Northwest',
              ],
              (newValue) {
                setState(() {
                  windDirection = newValue ?? '';
                });
              },
            ),
            _buildCheckBox('Any Rain?', anyRain, (newValue) {
              setState(() {
                anyRain = newValue ?? false;
              });
            }),
            SizedBox(height: 20),
            Text(
              'Spray Sites',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildTextField('Site/Area', spraySite),
            _buildTextField('Growth Stage', growthStage),
            _buildTextField('Spray Unit', sprayUnit),
            _buildNumericField('Num. Tanks Sprayed', numTanksSprayed),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String label, String value) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            sprayStatus = value;
          });
        },
        style: ElevatedButton.styleFrom(
          primary: sprayStatus == value ? Colors.blue : Colors.grey,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildDateTimePicker(String label, DateTime? selectedDate,
      void Function(DateTime?) onDateTimeSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null) {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );

              if (pickedTime != null) {
                DateTime pickedDateTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute);
                onDateTimeSelected(pickedDateTime);
              }
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(selectedDate != null
                ? DateFormat.yMd().add_Hm().format(selectedDate)
                : ''),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckBox(
    String label,
    bool? value,
    void Function(bool?) onChanged,
  ) {
    return Row(
      children: [
        Checkbox(
          value: value ?? false,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          onChanged: (newValue) {
            setState(() {
              value = newValue;
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildNumericField(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          onChanged: (newValue) {
            setState(() {
              value = double.tryParse(newValue) ?? 0.0;
            });
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String? currentValue, // Change the type to nullable String
    List<String> options,
    void Function(String?)
        onChanged, // Change the argument type to void Function(String?)
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DropdownButton<String>(
          value: currentValue,
          onChanged: onChanged,
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}
