import 'dart:convert';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/Pages/appointments.dart';
import 'package:mobile/Pages/daily.dart';
import 'package:mobile/Pages/hospitals.dart';
import 'package:mobile/Pages/prediction.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentication/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  int? userId;
  Map<String, dynamic>? profileData;
  Map<String, dynamic>? userData;
  final List<double> weightData = [70, 71, 72, 73, 74, 75, 76];



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
    final url = Uri.parse('http://192.168.1.4:8000/api/profile/');
    // final url = Uri.parse('http://10.0.2.2:8000/api/profile/');

    final body = jsonEncode({'id': userId});
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      setState(() {
        userData = responseData['users'];
        profileData = responseData['profile'];
      });
      print(userData);
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 25, right: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              FadeInUp(
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Good Day,',
                          style: TextStyle(color: Colors.blueAccent, fontSize: 20),
                        ),
                        Text(
                          "${userData != null ? userData!['username'] ?? '' : ''}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        )
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors
                            .grey.shade700,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 500,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(25.0),
                                    topRight: Radius.circular(25.0),
                                  ),
                                ),
                        
                                child: Column(

                                  children: [
                                    const SizedBox(height: 30,),
                                    const Center(
                                      child: Text(
                                        'Profile',
                                        style: TextStyle(fontSize: 30, color: Colors.blueAccent),
                                      ),
                                    ),
                                    const SizedBox(height: 30,),
                                    Text("${userData != null ? userData!['username'] ?? '' : ''}", style: TextStyle(color: Colors.white),),
                                    Text("${userData != null ? userData!['email'] ?? '' : ''}", style: TextStyle(color: Colors.white),),
                                    Text("DOB: ${profileData != null ? profileData!['birth_date'] ?? '' : ''}", style: TextStyle(color: Colors.white),),
                                    Text("Country: ${profileData != null ? profileData!['country'] ?? '' : ''}", style: TextStyle(color: Colors.white),),

                                    const Spacer(),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          padding: const EdgeInsets.all(12), // Adjust padding as needed
                                        ),
                                        onPressed: () async {
                                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                                      await prefs.clear();
                                      Navigator.pushReplacement(
                                        context,
                                          MaterialPageRoute(builder: (context) => const Login()));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.blueAccent,
                                          content: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Logout successful'),
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }, child: const Padding(
                                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                                      child: Text('Logout', style: TextStyle(color: Colors.white),),
                                    )),
                                    const SizedBox(height: 30,)
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.person,
                          color: Colors.blueAccent,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade800,
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(12), // Adjust padding as needed
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FadeInUp(
                          delay: Duration(milliseconds: 500),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.green.shade200,
                                  Colors.green.shade300
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set the border radius value
                            ),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.bloodtype,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'Blood Pressure',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 18.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                    '${profileData != null ? profileData!['blood_low'] ?? '' : ''}/${profileData != null ? profileData!['blood_high'] ?? '' : ''}',
                                          style: TextStyle(
                                              color: Colors.green.shade700,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 30),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'mmHg',
                                    style: TextStyle(color: Colors.green.shade700),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: FadeInUp(
                          delay: Duration(milliseconds: 500),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.purple.shade200,
                                  Colors.purpleAccent.shade100
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set the border radius value
                            ),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.sports_gymnastics,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          'BMI',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 18.0,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${profileData != null? profileData!['bmi'] ?? '' : ''}',
                                          style: const TextStyle(
                                              color: Colors.purple,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 30),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Text(
                                    'Normal',
                                    style: TextStyle(color: Colors.purple),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              FadeInUp(
                delay: Duration(milliseconds: 800),
                child: const Row(
                  children: [
                    Icon(Icons.bed_sharp, color: Colors.white,),
                    SizedBox(width: 10,),
                    Text('Sleep Analysis(Daily)', style: TextStyle(color: Colors.white),),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              FadeInUp(
                delay: Duration(milliseconds: 800),
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
                              color: Colors.amber,
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: FadeInUp(
                  delay: Duration(milliseconds: 900),
                  child: Row(
                    children: [
                      Container(
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[850],
                              padding: const EdgeInsets.all(10), // Adjust padding as needed
                            ),
                            onPressed: (){

                            }, icon: Icon(Icons.insights, color: Colors.white,),
                            label: Text('Insights', style: TextStyle(color: Colors.white),)),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[850],
                              padding: const EdgeInsets.all(10), // Adjust padding as needed
                            ),
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Appointments()));
                            }, icon: Icon(Icons.list, color: Colors.white,),
                            label: Text('Appointments', style: TextStyle(color: Colors.white),)),
                      ),
                      SizedBox(width: 10,),
                      Container(
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[850],
                              padding: const EdgeInsets.all(12), // Adjust padding as needed
                            ),
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Hospitals()));
                            }, icon: Icon(Icons.local_hospital, color: Colors.white,),
                            label: Text('Hospitals', style: TextStyle(color: Colors.white),)),
                      ),

                      // Add more widgets as needed
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              FadeInUp(
                delay: Duration(milliseconds: 1000),
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DailyAnalysis()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.green.shade300,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.analytics_outlined, size: 35, color: Colors.white,),
                        SizedBox(width: 10,),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Daily Analysis', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 19 ),),
                            Text('Get your daily insights' , style: TextStyle(color: Colors.white70),)
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, color: Colors.white,)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              FadeInUp(
                delay: Duration(milliseconds: 1000),
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Prediction()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.online_prediction_sharp, size: 35, color: Colors.white,),
                        SizedBox(width: 10,),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Prediction', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 19 ),),
                            Text('Predictive care' , style: TextStyle(color: Colors.white70),)
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios, color: Colors.white,)
                      ],
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}




