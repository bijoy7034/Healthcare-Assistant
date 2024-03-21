import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  int? userId;
  List<dynamic> fetchedData = [];
  @override
  void initState() {
    super.initState();
    fetchUserId().then((_) {
      fetchProfileData();
    });
  }


  Future<void> fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedUserId = prefs.getInt('id');

    setState(() {
      userId = storedUserId;
    });
  }
  Future<void> fetchProfileData() async {
    final url = Uri.parse('http://192.168.1.4:8000/api/ments/');
    final body = jsonEncode({'id': userId});
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      setState(() {
        fetchedData = responseData;
      });
      if (kDebugMode) {
        print(fetchedData);
      }
    } else {
      throw Exception('Failed to load profile data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.black,
        title: Text('Appointments', style: TextStyle(color: Colors.blueAccent),),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: FadeInUp(
          child: ListView.builder(
            itemCount: fetchedData.length,
            itemBuilder: (context, index) {
              final appointment = fetchedData[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade900,
                  ),
                  child: ListTile(
                    title: Text(
                      appointment['Doctor_Name'] ?? '', // Replace 'title' with the actual field name
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.green.shade300,
                          ),
                          child: Text(
                            appointment['appointment'] ?? '', // Replace 'description' with the actual field name
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.yellow.shade400,
                          ),
                          child: Text(
                            appointment['hospital'] ?? '', // Replace 'description' with the actual field name
                            style: TextStyle(color: Colors.black, fontSize: 10),
                          ),
                        ),
          
                      ],
                    ),
                    onTap: () {
                      // Handle tap on the appointment tile
                    },
                    trailing:appointment['my_time_field'] == null? Text('Time Not Set', style: TextStyle(color: Colors.amber),):Text(
                      appointment['my_time_field'] ?? '', // Replace 'description' with the actual field name
                      style: TextStyle(color: Colors.green, fontSize: 10),
                    )
          
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

  }
}
