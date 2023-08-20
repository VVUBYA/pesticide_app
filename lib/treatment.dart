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
                  Text(
                    'The week of 14-20 Aug 2023',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('No entries found for this period'),
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

  void _saveEntry() async {
    try {
      await FirebaseFirestore.instance.collection('sprayEntries').add({
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
        'any': anyRain,
      });

      Navigator.pop(context); // Close the entry screen
    } catch (error) {
      print('Error saving entry: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Spray Entry'),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Save changes logic
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
            _buildCheckBox('Neighbors Notified', neighborsNotified),
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
            //_buildCheckBox('Glasses/Goggles', glassesChecked, (value) {
            //setState(() {
            //glassesChecked = false;
            //});
            //}),
            _buildCheckBox('Gloves', glovesChecked),
            _buildCheckBox('Hat', hatChecked),
            _buildCheckBox('Boots', bootsChecked),
            _buildCheckBox('Respirator/Mask', respiratorChecked),
            _buildCheckBox('Overalls', overallsChecked),
            _buildCheckBox('Spraysuit', spraysuitChecked),
            _buildCheckBox('First Aid Kit', firstAidKitChecked),
            _buildCheckBox('Apron', apronChecked),
            _buildCheckBox('Safe Helmet', safeHelmetChecked),
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
            _buildWeatherButton(),
            _buildNumericField('Temperature (°C)', temperature),
            _buildNumericField('Humidity (%)', humidity),
            _buildNumericField('Cloud Cover (%)', cloudCover),
            _buildNumericField('Wind Speed (km/h)', windSpeed),
            _buildDropdown('Wind Direction', windDirection, [
              'North',
              'Northeast',
              'East',
              'Southeast',
              'South',
              'Southwest',
              'West',
              'Northwest',
            ]),
            _buildCheckBox('Any Rain?', anyRain),
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

  Widget _buildCheckBox(String label, bool value) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (newValue) {
            setState(() {
              value = newValue ?? false;
            });
          },
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
      String label, String currentValue, List<String> options) {
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
          onChanged: (newValue) {
            setState(() {
              currentValue = newValue ?? '';
            });
          },
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

  Widget _buildWeatherButton() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            // TODO: Implement weather access
          },
          child: Text('Get Weather'),
        ),
        SizedBox(width: 10),
        Text('Weather data will be displayed here'),
      ],
    );
  }
}
