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
      name: "JEMBE",
      category: "Herbicides",
      imageURL:
          "https://bukoolachemicals.com/wp-content/uploads/2023/03/Jembe-01.png",
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
      category: "Fertilizer",
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
      category: "Fertilizer",
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
    Pesticide(
      name: "STRIKER",
      category: "Insecticides",
      imageURL:
          "https://bukoolachemicals.com/wp-content/uploads/2023/03/striker-01-1.png",
      description:
          "For control of insect pests like cutworms, coffee twig borer, maize stalk borer, loopers, potato psyllids, white flies, cabbage moth, false codling moths etc..",
      usage: [],
    ),
    Pesticide(
      name: "ANT-KILLER",
      category: "Insecticides",
      imageURL:
          "https://bukoolachemicals.com/wp-content/uploads/2023/03/Anti-killer-01.png",
      description:
          "An organophosphate based termiticide/insecticide with outstanding and versatile control of a wide range of insect and arthropods pests."
          "Ant killer is used on crops, soil, livestock, public health, and other pest control operations"
          "It is effective by contact, ingestion, and vapor.",
      usage: [
        "The application Rate depends on the type of pest, size, and age, the volume of spray-applied per unit surface.",
        "Please read labels before use e.g. Ants, termites, Anthills, Building foundation, Banana planting material; ."
            "Application:",
        "Mix 150-250ml per 20L of water",
        "For termites in sugarcane and other crops mix 60-100ml per 20L of water and apply on the target"
      ],
    ),
    Pesticide(
      name: "AMETRYNE",
      category: "Herbicides",
      imageURL:
          "https://bukoolachemicals.com/wp-content/uploads/2023/03/AMETRYNE-01.png",
      description:
          "Ametryne is a selective herbicide for control of broadleaf and grass weeds in pineapple, sugarcane, bananas and plantains.",
      usage: [
        "Applications may be made pre-emergence or and post-emergence.",
        "It can also be used as a post-directed spray in corn and as a potato vine desiccant. In addition, it can be used for total vegetation control."
            "Application:",
        "Mix 200-250ml of Ametryne per 20L of water.",
      ],
    ),
    Pesticide(
      name: "BACTERIMYCIN",
      category: "Bacterialcides",
      imageURL:
          "https://bukoolachemicals.com/wp-content/uploads/2023/06/Bactericyin.jpg",
      description:
          "An exceptional immune modulator that imparts resistance to plants against bacterial diseases like leaf blight, black arm, cankers, angular leaf spot, seedling blight, and many more in cotton, citrus, chillies, tomatoes, onions, other vegetables, and fruits.",
      usage: [
        "Mix 1 teaspoon in 20L of water and apply on the crop. Bacterimycin is compatible with most pesticides."
      ],
    ),
    Pesticide(
      name: "BUTANIL-70",
      category: "Herbicides",
      imageURL:
          "https://bukoolachemicals.com/wp-content/uploads/2023/03/Butanil-01.png",
      description:
          "This is a selective pre and post-emergence herbicide for control of weeds in rice.,It is used against numerous grasses and broadleaved weeds in rice and wheat",
      usage: [
        "Application:",
        "Mix 200-250ml of Butanil-70 per 20L of water.",
      ],
    ),
    Pesticide(
      name: "DUDU CYPER 5% EC",
      category: "Insecticide",
      imageURL:
          "https://bukoolachemicals.com/wp-content/uploads/2023/03/dudu-cyper-01.png",
      description:
          "This product has a rapid knockdown effect and will give substantial control over time.",
      usage: [
        "The recommended dosage will vary according to pest and local conditions. As an indication, the dosage will vary from 20 -55ml per 20L of water on Lettuce, celery, and deciduous fruits to 40- 80ml per 20L of water on coffee, tomatoes, potatoes, and cabbage. See the leaf on the container for details.",
      ],
    ),
    Pesticide(
      name: "FANGOCIL",
      category: "Fungicide",
      imageURL:
          "https://bukoolachemicals.com/wp-content/uploads/2023/06/Fangocil.jpg",
      description:
          "Use Fangocil especially when environmental conditions allow for the rapid development of fungal spores",
      usage: [
        "Mix 80g per 20L of water. Avoid over-application and misuse of products to prevent the development of resistance.",
      ],
    ),
    Pesticide(
      name: "HARVESTER",
      category: "Fungicide",
      imageURL:
          "https://bukoolachemicals.com/wp-content/uploads/2023/06/HARVESTER.jpg",
      description:
          "Haverster is a systemic fungicide for control of Oomycete diseases through foliar application in horticultural and other crops. Harvester is renowned for controlling Downy mildew, blight and damping off in crops like cucurbits, grapes, tomatoes, potatoes and pepper.",
      usage: [
        "The enhanced photosynthetic activity enables vigor and growth. Plants start producing its own natural PGR’s",
        "More flowers, pods, and fruits. Prevents premature dropping of flowers and fruits"
            "Application:",
        "Mix 40-60ml of Harvester in 20L of water and apply on crop to control fungal diseases.",
      ],
    ),
    Pesticide(
      name: "WeedMaster",
      category: "Herbicide",
      imageURL:
          "https://bukoolachemicals.com/wp-content/uploads/2023/03/Weed-master-01.png",
      description:
          "The most widely used agricultural herbicide for general weed control. Weedmaster effectively controls brushes, soft annual weeds, and stubborn perennial weeds and grasses like a spear, couch, and star grasses.",
      usage: [
        "Application:",
        "Mix 40-60ml of Harvester in 20L of water and apply on crop to control fungal diseases.",
      ],
    ),
    Pesticide(
      name: "INDOFIL M-45",
      category: "Fungicide",
      imageURL:
          "https://bukoolachemicals.com/wp-content/uploads/2023/06/Indofil.jpg",
      description:
          "It is a combined fungicide that prevents many fungal diseases in a wide range of field crops, fruits, nuts, vegetables, and ornamentals. Indofil is widely used to prevent fungal diseases in tomatoes, potatoes, and peppers.",
      usage: [
        "When disease infestation is severe, alternate with or turn to curative Brands like Harvester, Harvestor XL or Fangocil."
            "Application:",
        "Mix 40-80g of Indofil in 20L of water and apply on crop routinely.",
      ],
    ),
    Pesticide(
      name: "MICRO FOOD (AC)",
      category: "Fertilizer",
      imageURL:
          "https://bukoolachemicals.com/wp-content/uploads/2023/06/HARVESTER.jpg",
      description:
          "This product the essential micro-nutrients for proper crop function and growth. These nutrients, including Iron, Manganese, Zinc, Copper, Molybdenum, Boron, and Magnesium are all supplied in readily available forms for plant uptake. ",
      usage: [
        "Depending upon the crop in question, the 1st application is recommended during the vegetative stage, 2nd during flowering and 3rd during the initial stage of fruit set."
            "Application:",
        "Mix 40-60ml of MICRO FOOD (AC) in 20L of water and apply on crop to control fungal diseases.",
      ],
    ),
    Pesticide(
      name: "JEMBE",
      category: "Herbicide",
      imageURL:
          "https://bukoolachemicals.com/wp-content/uploads/2023/03/Jembe-01.png",
      description:
          "JEMBE is a water-soluble non-selective herbicide that mixes well with water to be applied as a foliar spray for the control of most herbaceous plants. It is actively absorbed through immature bark and leaves of most plants and trees. Always make sure that only undesirable plants are treated.",
      usage: [
        "Wash hands before eating, drinking, or using the toilet."
            "Remove clothes immediately if pesticide gets inside."
            "Do not re-use or re-fill pesticide containers."
            "Tripple rinse promptly after emptying"
            "Application:",
        "Half fill the spray tank with clean water and add 150-200mls of JEMBE in a 15 to 20 Litres respectively.",
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
