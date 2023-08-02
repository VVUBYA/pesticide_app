import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = 'ccb872857c5fc8ccc25aae9e3f07009a';
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String city = 'Kampala';
  static const String country = 'UG';

  static Future<Map<String, dynamic>> fetchWeatherData() async {
    final String apiUrl =
        '$baseUrl?q=$city,$country&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch weather data');
    }
  }
}

class WeatherUpdate {
  final String date;
  final String description;
  final double temperature;

  WeatherUpdate({
    required this.date,
    required this.description,
    required this.temperature,
  });
}

class WeatherUpdatesScreen extends StatefulWidget {
  WeatherUpdatesScreen({Key? key}) : super(key: key);

  @override
  _WeatherUpdatesScreenState createState() => _WeatherUpdatesScreenState();
}

class _WeatherUpdatesScreenState extends State<WeatherUpdatesScreen> {
  late Future<Map<String, dynamic>> weatherData;

  @override
  void initState() {
    super.initState();
    weatherData = WeatherService.fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Updates'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to fetch weather data'));
          } else {
            final weatherUpdate = WeatherUpdate(
              date: DateTime.now().toString(),
              description: snapshot.data!['weather'][0]['description'],
              temperature: snapshot.data!['main']['temp'].toDouble(),
            );

            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.cloud),
                  title: Text(weatherUpdate.date),
                  subtitle: Text(weatherUpdate.description),
                  trailing:
                      Text('${weatherUpdate.temperature.toStringAsFixed(1)}°C'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
