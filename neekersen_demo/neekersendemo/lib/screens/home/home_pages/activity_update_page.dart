import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:neekersendemo/models/activity/activity.dart';
import 'package:http/http.dart' as http;
import 'package:neekersendemo/screens/home/home_pages/activity_detail_page.dart';

TextEditingController _titleUpdateTextFieldController = TextEditingController();
TextEditingController _dateUpdateTextFieldController = TextEditingController();
TextEditingController _descriptionUpdateTextFieldController =
    TextEditingController();
TextEditingController _categoryUpdateTextFieldController =
    TextEditingController();
TextEditingController _cityUpdateTextFieldController = TextEditingController();
TextEditingController _venueUpdateTextFieldController = TextEditingController();

class ActivityUpdatePage extends StatelessWidget {
  const ActivityUpdatePage(
      {Key? key, required this.id, required this.title, required this.city})
      : super(key: key);
  final String id;
  final String title;
  final String city;

  Future<Activity> getActivity() async {
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

  Future updateActivity(
      {required String title,
      required String date,
      required String description,
      required String category,
      required String city,
      required String venue}) async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:5248/api/Activity/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "id": id,
        "title": title,
        "date": date,
        "description": description,
        "category": category,
        "city": city,
        "venue": venue
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return const Center(
        child: Text("Başarılı"),
      );
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update activity.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Activity"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      ActivityDetailPage(id: id, title: title, city: city),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: FutureBuilder(
        future: getActivity(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("error fetching data"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            Activity activity = snapshot.data!;

            _titleUpdateTextFieldController.text = activity.title;
            _categoryUpdateTextFieldController.text = activity.category;
            _cityUpdateTextFieldController.text = activity.city;
            _dateUpdateTextFieldController.text = activity.date;
            _descriptionUpdateTextFieldController.text = activity.description;
            _venueUpdateTextFieldController.text = activity.venue;

            return ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _titleUpdateTextFieldController,
                      autofocus: false,
                      decoration: const InputDecoration(
                        labelText: "Title",
                      ),
                    ),
                    TextField(
                      controller: _dateUpdateTextFieldController,
                      autofocus: false,
                      onTap: () async {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000, 1),
                          lastDate: DateTime(2050, 12),
                        ).then((selectedDate) {
                          //do whatever you want
                          if (selectedDate != null) {
                            /*_dateUpdateTextFieldController.text =
                                selectedDate.toString();*/
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: DateTime.now().hour,
                                  minute: DateTime.now().minute),
                            ).then((selectedTime) {
                              if (selectedTime != null) {
                                DateTime dating = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    selectedTime.hour,
                                    selectedTime.minute);
                                _dateUpdateTextFieldController.text =
                                    dating.toString();
                              }
                            });
                          }
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Date",
                      ),
                    ),
                    TextField(
                      controller: _descriptionUpdateTextFieldController,
                      autofocus: false,
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                    ),
                    TextField(
                      controller: _categoryUpdateTextFieldController,
                      autofocus: false,
                      decoration: const InputDecoration(
                        labelText: "Category",
                      ),
                    ),
                    TextField(
                      controller: _cityUpdateTextFieldController,
                      autofocus: false,
                      decoration: const InputDecoration(
                        labelText: "City",
                      ),
                    ),
                    TextField(
                      controller: _venueUpdateTextFieldController,
                      autofocus: false,
                      decoration: const InputDecoration(
                        labelText: "Venue",
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    InkWell(
                      onTap: () {
                        updateActivity(
                            title: _titleUpdateTextFieldController.text,
                            date: _dateUpdateTextFieldController.text,
                            description:
                                _descriptionUpdateTextFieldController.text,
                            category: _categoryUpdateTextFieldController.text,
                            city: _cityUpdateTextFieldController.text,
                            venue: _venueUpdateTextFieldController.text);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                ActivityDetailPage(
                                    id: id, title: title, city: city),
                          ),
                          (route) => false,
                        );
                      },
                      child: Container(
                        width: 100,
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: const Text(
                          "Update",
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          }

          return const Text("Any data!");
        },
      ),
    );
  }
}
