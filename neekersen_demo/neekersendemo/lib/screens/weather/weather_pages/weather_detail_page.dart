import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neekersendemo/models/weather/detail_weather.dart';
import 'package:http/http.dart' as http;

class WeatherDetailPage extends StatelessWidget {
  const WeatherDetailPage({Key? key, required this.city, required this.date})
      : super(key: key);
  final String city;
  final String date;

  Future<List<DetailWeather>> getWeathersDetail(String city) async {
    var url = Uri.parse('http://10.0.2.2:5248/api/Weather?city=$city');
    var response = await http.get(url);
    //print('Response status: ${response.statusCode}');
    var responseBody = jsonDecode(response.body);
    var responser = responseBody['result'];

    List<DetailWeather> weatherDetails = [];
    for (var i in responser) {
      DetailWeather detailWeather = DetailWeather(
        date: i['date'],
        day: i['day'],
        degree: i['degree'],
        description: i['description'],
        humidity: i['humidity'],
        icon: i['icon'],
        max: i['max'],
        min: i['min'],
        night: i['night'],
        status: i['status'],
      );

      if (detailWeather.date == date) {
        weatherDetails.add(detailWeather);
      }
    }

    return weatherDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Weather"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<DetailWeather>>(
        future: getWeathersDetail(city),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("error fetching data"),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: Image.network(snapshot.data!.first.icon,
                          fit: BoxFit.fill),
                    ),
                    Container(
                      height: 40.0,
                      color: Colors.brown[400],
                      margin: const EdgeInsets.only(bottom: 4.0),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text("Date: ${snapshot.data!.first.date}"),
                    ),
                    Container(
                      height: 40.0,
                      color: Colors.brown[400],
                      margin: const EdgeInsets.only(bottom: 4.0),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text("Day: ${snapshot.data!.first.day}"),
                    ),
                    Container(
                      height: 40.0,
                      color: Colors.brown[400],
                      margin: const EdgeInsets.only(bottom: 4.0),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text("Degree: ${snapshot.data!.first.degree} °C"),
                    ),
                    Container(
                      height: 40.0,
                      color: Colors.brown[400],
                      margin: const EdgeInsets.only(bottom: 4.0),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text(
                          "Description: ${snapshot.data!.first.description}"),
                    ),
                    Container(
                      height: 40.0,
                      color: Colors.brown[400],
                      margin: const EdgeInsets.only(bottom: 4.0),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text("Humidity: ${snapshot.data!.first.humidity}"),
                    ),
                    Container(
                      height: 40.0,
                      color: Colors.brown[400],
                      margin: const EdgeInsets.only(bottom: 4.0),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text("Max: ${snapshot.data!.first.max}"),
                    ),
                    Container(
                      height: 40.0,
                      color: Colors.brown[400],
                      margin: const EdgeInsets.only(bottom: 4.0),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text("Min: ${snapshot.data!.first.min}"),
                    ),
                    Container(
                      height: 40.0,
                      color: Colors.brown[400],
                      margin: const EdgeInsets.only(bottom: 4.0),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text("Night: ${snapshot.data!.first.night}"),
                    ),
                    Container(
                      height: 40.0,
                      color: Colors.brown[400],
                      margin: const EdgeInsets.only(bottom: 4.0),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text("Status: ${snapshot.data!.first.status}"),
                    ),
                  ],
                );
              },
            );
          }
          return const Text("Any Weather Data!");
        },
      ),
    );
  }
}
