import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:neekersendemo/models/weather/weather.dart';
import 'package:http/http.dart' as http;
import 'package:neekersendemo/screens/city/city_page.dart';
import 'package:neekersendemo/screens/weather/weather_pages/weather_detail_page.dart';

class WeathersAllPage extends StatelessWidget {
  const WeathersAllPage({Key? key, required this.city}) : super(key: key);
  final String city;

  Future<List<Weather>> getWeathers(String city) async {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Week Weathers"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const CityPage(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: FutureBuilder<List<Weather>>(
        future: getWeathers(city),
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
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => WeatherDetailPage(
                            city: city, date: snapshot.data![index].date),
                      ),
                    );
                  },
                  child: Container(
                    height: 50.0,
                    color: double.parse(snapshot.data![index].degree) > 10
                        ? Colors.red[400]
                        : Colors.blueGrey,
                    margin: const EdgeInsets.only(bottom: 4.0),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 50.0,
                          width: 50.0,
                          child: Image.network(snapshot.data![index].icon,
                              fit: BoxFit.fill),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("${snapshot.data![index].degree} °C"),
                            Text(snapshot.data![index].description),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(snapshot.data![index].day),
                            Text(snapshot.data![index].date),
                          ],
                        ),
                      ],
                    ),
                  ),
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
