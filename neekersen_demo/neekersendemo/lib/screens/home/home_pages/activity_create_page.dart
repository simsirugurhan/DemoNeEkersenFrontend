import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:neekersendemo/screens/home/home_page.dart';

TextEditingController _titleCreateTextFieldController = TextEditingController();
TextEditingController _dateCreateTextFieldController = TextEditingController();
TextEditingController _descriptionCreateTextFieldController =
    TextEditingController();
TextEditingController _categoryCreateTextFieldController =
    TextEditingController();
TextEditingController _cityCreateTextFieldController = TextEditingController();
TextEditingController _venueCreateTextFieldController = TextEditingController();

class ActivityCreatePage extends StatelessWidget {
  const ActivityCreatePage({Key? key, required this.city}) : super(key: key);
  final String city;

  Future createActivity(
      {required String title,
      required String date,
      required String description,
      required String category,
      required String city,
      required String venue}) async {
    DateTime dater = DateTime.parse(date);
    String dateri = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(dater);
    dateri = "${dateri}Z";

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5248/api/Activity/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "title": title,
        "date": dateri,
        "description": description,
        "category": category,
        "city": city,
        "venue": venue
      }),
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
        title: const Text("Activity Create"),
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
            icon: const Icon(Icons.arrow_back)),
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _titleCreateTextFieldController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
              ),
              TextField(
                controller: _dateCreateTextFieldController,
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
                          _dateCreateTextFieldController.text =
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
                controller: _descriptionCreateTextFieldController,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
              ),
              TextField(
                controller: _categoryCreateTextFieldController,
                decoration: const InputDecoration(
                  labelText: "Category",
                ),
              ),
              TextField(
                controller: _cityCreateTextFieldController,
                decoration: const InputDecoration(
                  labelText: "City",
                ),
              ),
              TextField(
                controller: _venueCreateTextFieldController,
                decoration: const InputDecoration(
                  labelText: "Venue",
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              InkWell(
                onTap: () {
                  createActivity(
                      title: _titleCreateTextFieldController.text,
                      date: _dateCreateTextFieldController.text,
                      description: _descriptionCreateTextFieldController.text,
                      category: _categoryCreateTextFieldController.text,
                      city: _cityCreateTextFieldController.text,
                      venue: _venueCreateTextFieldController.text);
                  _titleCreateTextFieldController.clear();
                  _dateCreateTextFieldController.clear();
                  _descriptionCreateTextFieldController.clear();
                  _categoryCreateTextFieldController.clear();
                  _cityCreateTextFieldController.clear();
                  _venueCreateTextFieldController.clear();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => HomePage(city: city),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Container(
                  width: 100,
                  height: 50.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: const Text("Create"),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
