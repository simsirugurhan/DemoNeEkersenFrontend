import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neekersendemo/models/activity/activity.dart';
import 'package:neekersendemo/screens/home/home_pages/activity_create_page.dart';
import 'package:neekersendemo/screens/home/home_pages/activity_detail_page.dart';
import 'package:neekersendemo/screens/weather/weather_widgets/weather_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.city}) : super(key: key);
  final String city;

  Future<List<Activity>> getActivities() async {
    var url = Uri.parse("http://10.0.2.2:5248/api/Activity");
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body);

    List<Activity> activities = [];
    for (var act in responseBody) {
      Activity activity = Activity(
          id: act['id'].toString(),
          title: act['title'],
          date: act['date'].toString(),
          description: act['description'],
          category: act['category'],
          city: act['city'],
          venue: act['venue']);
      activities.add(activity);
    }
    return activities;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ne Ekersen"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        ActivityCreatePage(city: city),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WeatherWidget(city: city),
          Expanded(
            child: FutureBuilder<List<Activity>>(
              future: getActivities(),
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
                  List<Activity> activities = snapshot.data!;

                  return ListView.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      Activity activity = activities[index];

                      return InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  ActivityDetailPage(
                                      id: activity.id,
                                      title: activity.title,
                                      city: city),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 4.0),
                          color: Colors.blue[300],
                          height: 50.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(activity.title),
                                  Text(activity.venue)
                                ],
                              ),
                              Text(activity.date.toString()),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Text("Any Activity Data!");
              },
            ),
          )
        ],
      ),
    );
  }
}
