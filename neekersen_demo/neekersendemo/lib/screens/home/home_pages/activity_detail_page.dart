import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:neekersendemo/models/activity/activity.dart';
import 'package:http/http.dart' as http;
import 'package:neekersendemo/screens/home/home_page.dart';
import 'package:neekersendemo/screens/home/home_pages/activity_update_page.dart';

class ActivityDetailPage extends StatelessWidget {
  const ActivityDetailPage(
      {Key? key, required this.title, required this.id, required this.city})
      : super(key: key);
  final String title;
  final String id;
  final String city;

  Future<Activity> getActivityFromId() async {
    //string convert to guid by flutter_guid package
    var myId = Guid(id);

    var url = Uri.parse("http://10.0.2.2:5248/api/Activity/getById?Id=$myId");
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body);

    var res = responseBody;
    Activity activity = Activity(
      id: res['id'].toString(),
      title: res['title'],
      date: res['date'].toString(),
      description: res['description'],
      category: res['category'],
      city: res['city'],
      venue: res['venue'],
    );

    return activity;
  }

  Future deleteActivity(String id) async {
    var myId = Guid(id);
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:5248/api/Activity?Id=$myId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return const Center(
        child: Text("Başarılı"),
      );
    } else {
      throw Exception('Failed to create activity.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity Detail"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => HomePage(city: city),
              ),
              (Route<dynamic> route) => false,
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => ActivityUpdatePage(
                    id: id,
                    title: title,
                    city: city,
                  ),
                ),
                (Route<dynamic> route) => false,
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder<Activity>(
              future: getActivityFromId(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("error fetching data");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  Activity activity = snapshot.data!;
                  return ListView(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 50.0,
                        color: Colors.amberAccent,
                        child: Text("Title: ${activity.title}"),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 50.0,
                        color: Colors.amberAccent,
                        child: Text("Date: ${activity.date}"),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 50.0,
                        color: Colors.amberAccent,
                        child: Text("Description: ${activity.description}"),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 50.0,
                        color: Colors.amberAccent,
                        child: Text("Category: ${activity.category}"),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 50.0,
                        color: Colors.amberAccent,
                        child: Text("City: ${activity.city}"),
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 50.0,
                        color: Colors.amberAccent,
                        child: Text("Venue: ${activity.venue}"),
                      ),
                    ],
                  );
                }
                return const Text("Any Activity Data");
              },
            ),
          ),
          InkWell(
            onTap: () {
              deleteActivity(id).then(
                (value) => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => HomePage(city: city),
                  ),
                  (Route<dynamic> route) => false,
                ),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => HomePage(
                    city: city,
                  ),
                ),
                (Route<dynamic> route) => false,
              );
            },
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: const Text("Delete Activity",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
