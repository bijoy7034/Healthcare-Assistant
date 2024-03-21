import 'dart:convert';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyAnalysis extends StatefulWidget {
  const DailyAnalysis({super.key});

  @override
  State<DailyAnalysis> createState() => _DailyAnalysisState();
}

class _DailyAnalysisState extends State<DailyAnalysis> {

  int? userId;
  String? today;
  String? weight;
  String? sleep;
  String? low;
  String? high;


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
    final url = Uri.parse('http://192.168.1.4:8000/api/weight/');
    final body = jsonEncode({'id': userId});
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      setState(() {
        today = responseData['res'];
      });

    } else {
      throw Exception('Failed to load profile data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
          title: const Text(
            'Daily Analysis',
            style: TextStyle(color: Colors.blueAccent),
          )),
      body: SingleChildScrollView(
        child: SlideInUp(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0),
              ),
            ),
            child: Column(
              children: [
                today == '1' ?
                Column(
                  children: [
                    const SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green, width: 0.6),
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.grey[850]
                        ),
          
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.today, color: Colors.green.shade300,),
                                  const SizedBox(width: 10,),
                                  Text('Todays Insights are Uploaded ', style: TextStyle(color: Colors.green.shade300),),
                                ],
                              ),
                            ],
                          )),
                    )
                  ],
                )
          
                    : Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text('Enter Todays Insight',
                          style: TextStyle(color: Colors.white)),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            filled: true,
                            prefixIcon: const Icon(Icons.man),
                            prefixIconColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 7.0,
                              horizontal: 10,
                            ),
                            fillColor: Colors.grey.shade800,
                            labelText: "Weight",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade800),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set the same border radius here
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blueAccent),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.orange),
                            ),
                            labelStyle: const TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Quicksand',
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        onChanged: (val) {
                          setState(() {
                            weight = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            filled: true,
                            prefixIcon: const Icon(Icons.bloodtype),
                            prefixIconColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 7.0,
                              horizontal: 10,
                            ),
                            fillColor: Colors.grey.shade800,
                            labelText: "Pressure (High)",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade800),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set the same border radius here
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blueAccent),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.orange),
                            ),
                            labelStyle: const TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Quicksand',
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        onChanged: (val) {
                          setState(() {
                            high = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            filled: true,
                            prefixIcon: const Icon(Icons.bloodtype_rounded),
                            prefixIconColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 7.0,
                              horizontal: 10,
                            ),
                            fillColor: Colors.grey.shade800,
                            labelText: "Pressure (Low)",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade800),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set the same border radius here
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blueAccent),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.orange),
                            ),
                            labelStyle: const TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Quicksand',
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        onChanged: (val) {
                          setState(() {
                            low = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                            filled: true,
                            prefixIcon: const Icon(Icons.bedtime_rounded),
                            prefixIconColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 7.0,
                              horizontal: 10,
                            ),
                            fillColor: Colors.grey.shade800,
                            labelText: "Sleep",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade800),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set the same border radius here
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.blueAccent),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.orange),
                            ),
                            labelStyle: const TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Quicksand',
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        onChanged: (val) {
                          setState(() {
                           sleep = val;
                          });
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                ),
                                onPressed: addInsights,
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
          
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0, bottom: 10),
                  child: FadeIn(
                    child: const Row(
                      children: [
                        Icon(Icons.bed_sharp, color: Colors.white,),
                        SizedBox(width: 10,),
                        Text('Sleep Analysis(Daily)', style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                ),
                ElasticIn(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[850]
                        ),
                        padding: const EdgeInsets.all(13),
                        height: 200,
                        child: Chart(
                          layers: [
                            ChartAxisLayer(
                              settings: ChartAxisSettings(
                                x: ChartAxisSettingsAxis(
                                  frequency: 1.0,
                                  max: 13.0,
                                  min: 7.0,
                                  textStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 10.0,
                                  ),
                                ),
                                y: ChartAxisSettingsAxis(
                                  frequency: 100.0,
                                  max: 300.0,
                                  min: 0.0,
                                  textStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                              labelX: (value) => value.toInt().toString(),
                              labelY: (value) => value.toInt().toString(),
                            ),
                            ChartBarLayer(
                              items: List.generate(
                                13 - 7 + 1,
                                    (index) => ChartBarDataItem(
                                  color: Colors.green.shade400,
                                  value: Random().nextInt(280) + 20,
                                  x: index.toDouble() + 7,
                                ),
                              ),
                              settings: const ChartBarSettings(
                                thickness: 8.0,
                                radius: BorderRadius.all(Radius.circular(4.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          
          ),
        ),
      ),
    );
  }
  addInsights() async {
    final Uri url = Uri.parse('http://192.168.1.4:8000/api/addWeight/');
    final Map<String, dynamic> data = {
      "id":userId,
      "weight": weight,
      "low" : low,
      "high":high,
      "sleep": sleep
    };
    try{
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        // Data added successfully
        print('Data added successfully');
        fetchUserId().then((_) {
          fetchProfileData();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            content: Stack(
              children: [
                ElasticIn(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Added!!', style: TextStyle(color: Colors.white, fontSize: 14),),
                        SizedBox(height: 3,),
                        Text(
                          'Added Successfully',
                          style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold, fontFamily: 'Quicksand'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),

        );
      } else {

        print('Failed to add data: ${response.statusCode}');
      }
    }catch(error){
      print('Error: $error');
    }
  }
}
