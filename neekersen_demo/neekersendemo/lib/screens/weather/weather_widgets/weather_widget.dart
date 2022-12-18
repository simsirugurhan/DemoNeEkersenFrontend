import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neekersendemo/models/weather/weather.dart';
import 'package:http/http.dart' as http;
import 'package:neekersendemo/screens/weather/weathers_all_page.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({Key? key, required this.city}) : super(key: key);
  final String city;

  Future<List<Weather>> getWeather(String city) async {
    var url = Uri.parse('http://10.0.2.2:5248/api/Weather?city=$city');
    var response = await http.get(url);
    //print('Response status: ${response.statusCode}');
    var responseBody = jsonDecode(response.body);
    var responser = responseBody['result'];

    List<Weather> weathers = [];
    for (var i in responser) {
      Weather weather = Weather(
        day: i['day'],
        description: i['description'],
        degree: i['degree'],
        icon: i['icon'],
        date: i['date'],
      );
      weathers.add(weather);
    }

    return weathers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Weather>>(
      future: getWeather(city),
      builder: (context, snapshot) {
        //List<Weather>? snap = snapshot.data;

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
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return InkWell(
            onTap: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      WeathersAllPage(city: city),
                ),
              );
            },
            child: Container(
              height: 50.0,
              color: double.parse(snapshot.data!.first.degree) > 10
                  ? Colors.red[400]
                  : Colors.blueGrey,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: Image.network(snapshot.data!.first.icon,
                        fit: BoxFit.fill),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("${snapshot.data!.first.degree} °C"),
                      Text(snapshot.data!.first.description),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(snapshot.data!.first.day),
                      Text(snapshot.data!.first.date),
                    ],
                  )
                ],
              ),
            ),
          );
        }
        return const Text("Any Weather Data!");
      },
    );
  }
}
