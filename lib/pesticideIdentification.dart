import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pesticide Identification',
      home: PesticideIdentificationPage(),
    );
  }
}

class Pesticide {
  final String name;
  final String category;
  final String imageURL;
  final String description;
  final List<String> usage;

  Pesticide({
    required this.name,
    required this.category,
    required this.imageURL,
    required this.description,
    required this.usage,
  });
}

class PesticideIdentificationPage extends StatefulWidget {
  @override
  _PesticideIdentificationPageState createState() =>
      _PesticideIdentificationPageState();
}

class _PesticideIdentificationPageState
    extends State<PesticideIdentificationPage> {
  final List<Pesticide> allPesticides = [
    Pesticide(
      name: "24D-AMINE-720 G/L",
      category: "Herbicides",
      imageURL:
          "https://bukoolachemicals.com/wp-content/uploads/2023/05/24D-01-01.png",
      description:
          "Selective systemic herbicide readily absorbed by foliage accumulating at growing points of shoots and roots to inhibit further growth of...",
      usage: [
        "2,4-D is used for post-emergence control of annual and perennial broadleaved weeds in cereals, grasslands, established turf, and aquatic weeds.",
        "Application:",
        "In the mixture, use 30-50ml per 20L",
        "For brushes and shrubs in pastures, use 100-150ml per 20 Liters of water",
        "For pre-emergence in Sugarcane, use 200ml per 20L"
      ],
    ),
    Pesticide(
      name: "AGRi GOLD",
      category: "Fungicides",
      imageURL:
          "https://bukoolachemicals.com/wp-content/uploads/2023/06/AgriGold.jpg",
      description:
          "A wonder product that prevents flower shedding, promotes more flower formation and bumper yield while enhancing healthy fruit formation and...",
      usage: [
        "A wonder product that prevents flower shedding, promotes more flower formation and bumper yield while enhancing healthy fruit formation and vegetative growth. Agri gold is recommended in all flowering crops like tomatoes, peppers, beans, cotton, coffee",
      ],
    ),
    Pesticide(
      name: "ALLWIN Top",
      category: "Herbicides",
      imageURL:
          "https://bukoolachemicals.com/wp-content/uploads/2023/06/Alwin-top.jpg",
      description:
          "ALLWIN TOP ensures enhanced photosynthetic activity which enables vigor and growth...",
      usage: [
        "The enhanced photosynthetic activity enables vigor and growth. Plants start producing its own natural PGR’s",
        "More flowers, pods, and fruits. Prevents premature dropping of flowers and fruits"
            "Application:",
        "Mix 40g per 20L of water and spray on crop foliage.",
      ],
    ),
  ];

  List<Pesticide> displayedPesticides = [];

  @override
  void initState() {
    super.initState();
    displayedPesticides = List.from(allPesticides);
  }

  void filterPesticides(String query) {
    setState(() {
      displayedPesticides = allPesticides.where((pesticide) {
        final nameLower = pesticide.name.toLowerCase();
        final categoryLower = pesticide.category.toLowerCase();
        final descriptionLower = pesticide.description.toLowerCase();
        final usageLower = pesticide.usage.join(' ').toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower) ||
            categoryLower.contains(searchLower) ||
            descriptionLower.contains(searchLower) ||
            usageLower.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesticide Identification'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => filterPesticides(value),
              decoration: InputDecoration(
                labelText: 'Search Pesticides',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedPesticides.length,
              itemBuilder: (context, index) {
                return PesticideCardWidget(displayedPesticides[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PesticideCardWidget extends StatelessWidget {
  final Pesticide pesticide;

  PesticideCardWidget(this.pesticide);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            pesticide.imageURL,
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pesticide.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(pesticide.category),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(pesticide.name),
                          content: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.network(
                                  pesticide.imageURL,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 16),
                                Text(pesticide.description),
                                SizedBox(height: 16),
                                Text("Usage:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                for (String usage in pesticide.usage)
                                  Text(usage),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Read more'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
